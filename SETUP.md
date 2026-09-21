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
the wrong order and `brew style` rejects it.

## The cask

A cask is the opposite, and the difference matters when releasing:

```ruby
cask "example" do
  version "1.0.0"
  sha256 "REPLACE_ON_FIRST_RELEASE"

  url "https://github.com/NoiXdev/example/releases/download/v#{version}/example_#{version}_universal.dmg"
  name "Example"
  desc "One line, no trailing full stop"
  homepage "https://github.com/NoiXdev/example"

  depends_on macos: ">= :ventura"

  app "Example.app"
end
```

Casks **do** carry a `version`, and interpolating it into the url is the
convention rather than a mistake.

| | Formula | Cask |
|---|---|---|
| `version` field | none — derived from the url | yes |
| url | written out | interpolates `#{version}` |
| a release bumps | **url + sha256** | **version + sha256**, the url follows |

`bump.yml` handles both and refuses to guess: it checks a cask really has a
`version` line, reads a formula's current version out of its url, and fails
when the file did not change — a bump that quietly does nothing would leave
the tap pointing at the previous release while the release itself is out.

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

## Release notifications

Releases are announced in Discord by
[`SethCohen/github-releases-to-discord`](https://github.com/marketplace/actions/github-releases-to-discord),
as a step in the product's release workflow:

```yaml
- name: Announce on Discord
  if: env.WEBHOOK != ''
  env:
    WEBHOOK: ${{ secrets.DISCORD_WEBHOOK_RELEASE_NOTIFICATION }}
  uses: SethCohen/github-releases-to-discord@v1
  with:
    webhook_url: ${{ secrets.DISCORD_WEBHOOK_RELEASE_NOTIFICATION }}
    color: "2105893"
    username: "NoiX Releases"
```

The detour through `env` is the point. `if: secrets.X != ''` is not evaluated
— secrets are unavailable in `if` at job level and only partly at step level —
so the comparison is made against an `env` value instead. A repository without
a webhook then skips the step silently rather than failing the run.

`DISCORD_WEBHOOK_RELEASE_NOTIFICATION` is an organisation secret scoped to
public repositories, so every product inherits it. A repository secret of the
**same name** overrides it, which is how a single product gets its own
channel without a second variable or a branch in the workflow.

In a shared workflow the secret has to be declared, or the caller cannot pass
it through:

```yaml
on:
  workflow_call:
    secrets:
      DISCORD_WEBHOOK_RELEASE_NOTIFICATION:
        required: false
```

`required: false` matters — otherwise a repository without a webhook fails at
the call itself.
