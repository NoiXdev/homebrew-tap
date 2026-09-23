# NoiX Homebrew tap

One tap for every NoiX product. Add it once, then install anything from it by
name.

```bash
brew tap NoiXdev/tap
```

A tap is a source of software definitions — adding it changes nothing on your
machine by itself, and it only needs doing once.

## Available

| | Install | Documentation |
|---|---|---|
| **dotfix** — keep macOS terminal setups in sync across machines | `brew install dotfix` | [docs.noix.dev/dotfix](https://docs.noix.dev/dotfix) |
| **Printy** — watch folders and print the files that land in them | `brew install --cask printy` | [docs.noix.dev/printy](https://docs.noix.dev/printy) |

A name is enough once the tap is added. If another tap offers something under
the same name, spell it out: `brew install NoiXdev/tap/dotfix`.

## Updating

```bash
brew update
brew upgrade dotfix
```

Only finished releases are published here. Pre-releases — betas and release
candidates — are deliberately left out, because `brew upgrade` makes no
distinction and would hand them to everyone. To try one, take it from that
product's releases page.

## Removing

```bash
brew uninstall dotfix
brew untap NoiXdev/tap
```

## Requirements

macOS. Everything published here is built for both Apple silicon and Intel in
a single binary.

---

Maintainers: adding a product is a file here, not a new repository. See
[SETUP.md](SETUP.md).
