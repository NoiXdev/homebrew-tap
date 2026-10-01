# Cask for NoiXdev/homebrew-tap. Bumped by macSCP's release workflow, which
# dispatches bump.yml with the checksum of the DMG it just uploaded.
#
# No formula beside this one, and deliberately so: macSCP ships `macscp-cli`
# inside the app bundle and installs it from Settings, so a release carries no
# separate CLI asset for a formula to download.
#
# Casks carry a `version` and interpolate it into the url — the opposite of a
# formula. See SETUP.md.
cask "macscp" do
  version "1.6.0"
  sha256 "ffc5fa69f8ceb1c039bb617f66f895eb130f715fc86f85a645f8ff2b99204de1"

  url "https://github.com/NoiXdev/macSCP/releases/download/v#{version}/macSCP-#{version}.dmg"
  name "macSCP"
  desc "Two-pane SFTP client with saved sessions and a built-in terminal"
  homepage "https://github.com/NoiXdev/macSCP"

  # LSMinimumSystemVersion in the app's Info.plist is 15.0.
  depends_on macos: :sequoia

  app "macSCP.app"

  # Measured against the app on 2026-10-01 rather than copied from a sibling
  # cask: the stores sit in a plain `macSCP` directory, NOT under the bundle
  # id (`dev.noix.macscp`), and nothing is written to ~/Library/Caches — so
  # a Caches entry would name a path that never exists.
  #
  # `zap` removes saved sessions, settings, snippets, tunnels and login sets.
  # It does NOT remove passwords or passphrases: those live in the macOS
  # Keychain, which a cask cannot delete and should not try to.
  zap trash: [
    "~/Library/Application Support/macSCP",
    "~/Library/Preferences/dev.noix.macscp.plist",
    "~/Library/Saved Application State/dev.noix.macscp.savedState",
  ]
end
