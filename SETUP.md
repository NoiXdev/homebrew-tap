# Adding a product to this tap

One tap serves the whole organisation. Adding a product means adding a file
here — not creating another repository.

```
Formula/    command-line tools, one .rb per product
Casks/      GUI applications, one .rb per product
```

A product with both halves — a CLI and an app — gets an entry in each, under
the same name.

## The formula

```ruby
class Example < Formula
  desc "One line, no trailing full stop"
  homepage "https://github.com/NoiXdev/example"
  url "https://github.com/NoiXdev/example/releases/download/v1.0.0/example-v1.0.0-macos-universal.tar.gz"
  sha256 "REPLACE_ON_FIRST_RELEASE"
  license "MIT"

  depends_on :macos

  def install
    bin.install "example"
  end

  test do
    assert_match "example", shell_output("#{bin}/example --version")
  end
end
```

**Write the url out in full and do not add a `version` field.** Homebrew
requires `url` before `version` (`FormulaAudit/ComponentsOrder`) and derives
the version from the url itself, so a url interpolating `#{version}` forces
the wrong order and `brew style` rejects it. This is why `bump.yml` rewrites
the **url and the sha256** rather than a version field.

## Releasing

The product's own release workflow builds the artefact, then calls this
repository:

```yaml
- name: Bump the tap
  env:
    GH_TOKEN: ${{ secrets.TAP_TOKEN }}
  run: |
    SHA=$(cut -d' ' -f1 checksum.txt)
    gh workflow run bump.yml --repo NoiXdev/homebrew-tap \
      -f kind=formula -f name=example \
      -f version="${GITHUB_REF_NAME#v}" -f sha256="$SHA"
```

`TAP_TOKEN` is a fine-grained PAT scoped to this repository only.

| Input | Meaning |
|---|---|
| `kind` | `formula` or `cask` |
| `name` | file name without `.rb` |
| `version` | without a leading `v` |
| `sha256` | checksum of the release asset |

## Testing a formula before releasing

No network and no release needed. Build the artefact, then point a local tap
at it:

```bash
TAP="$(brew --repository)/Library/Taps/noixdev/homebrew-tap"
mkdir -p "$TAP/Formula"
sed -e "s|url \".*\"|url \"file://$PWD/example.tar.gz\"|" \
    -e "s|REPLACE_ON_FIRST_RELEASE|$(shasum -a 256 example.tar.gz | cut -d' ' -f1)|" \
    Formula/example.rb > "$TAP/Formula/example.rb"

brew style noixdev/tap
brew audit --strict noixdev/tap/example
brew install noixdev/tap/example
brew test noixdev/tap/example
brew uninstall example && rm -rf "$TAP"
```

`brew style` and `brew audit` catch what only shows up at the first tag
otherwise.

## Requirements

A tap is only usable if what it points at is reachable: **this repository and
the releases it references must be public**, or every `brew tap` needs
credentials.

Check the name is free in homebrew-core before choosing one —
`brew search --formula "^name$"`. If it is, `brew install name` works after
tapping, without the full path.
