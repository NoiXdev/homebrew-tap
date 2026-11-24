# Cask for NoiXdev/homebrew-tap. Bumped by MacCommander's release workflow,
# which dispatches bump.yml with the checksum of the DMG it just uploaded.
#
# Casks carry a `version` and interpolate it into the url — the opposite of a
# formula. See SETUP.md.
cask "maccommander" do
  version "0.2.0"
  sha256 "28f9e7ec57be2acccc464128e45c82acf9249ff878a4388e896e7c2f7ffb9182"

  url "https://github.com/NoiXdev/mac-commander/releases/download/v#{version}/MacCommander-#{version}.dmg"
  name "MacCommander"
  desc "Native file manager with an optional dual-pane mode"
  homepage "https://github.com/NoiXdev/mac-commander"

  # 0.1.1 is Apple silicon only. Releases after it are universal: delete this
  # line together with the first bump past 0.1.1.
  depends_on arch: :arm64
  # LSMinimumSystemVersion in the app's Info.plist is 15.0.
  depends_on macos: :sequoia

  app "MacCommander.app"

  # From the app's data page (docs.noix.dev/maccommander/reference/data-and-privacy).
  # Settings live in the preferences domain `dev.noix.MacCommander`; saved
  # shares in Application Support. Files opened from archives sit in $TMPDIR
  # and are emptied at every launch and quit, so they need no entry here.
  #
  # `zap` does NOT remove share passwords: those live in the macOS Keychain,
  # which a cask cannot delete and should not try to.
  zap trash: [
    "~/Library/Application Support/MacCommander",
    "~/Library/Preferences/dev.noix.MacCommander.plist",
    "~/Library/Saved Application State/dev.noix.MacCommander.savedState",
  ]
end
