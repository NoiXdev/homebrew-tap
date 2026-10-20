# Cask for NoiXdev/homebrew-tap. Bumped by Notefix's release workflow, which
# dispatches bump.yml with the checksum of the universal DMG it just uploaded.
#
# Casks carry a `version` and interpolate it into the url — the opposite of a
# formula. See SETUP.md.
cask "notefix" do
  version "0.9.0"
  sha256 "d420c8505e5435107ae5f36182acf57e3ae6fc2f4a88fd4a02c5554d2bc7cade"

  url "https://github.com/NoiXdev/notefix/releases/download/v#{version}/Notefix_#{version}_universal.dmg"
  name "Notefix"
  desc "Local-first notes with folders, sync between devices and a protected vault"
  homepage "https://github.com/NoiXdev/notefix"

  # The bundle embeds a widget extension built for macOS 14, so the app as
  # shipped needs Sonoma even though the app alone would launch on older
  # systems.
  depends_on macos: :sonoma

  app "Notefix.app"

  # Measured against the app on 2026-10-20 rather than copied from a sibling
  # cask (bundle id dev.noix.notefix). The widget keeps its own sandbox
  # container, and the app and widget share notes through the app group
  # container (Team ID prefix, no consent dialog).
  #
  # `zap` removes the notes database, settings, profiles and the widget
  # share. It does NOT remove server sign-ins or the Touch ID vault key:
  # those live in the macOS Keychain, which a cask cannot delete and should
  # not try to.
  zap trash: [
    "~/Library/Application Support/dev.noix.notefix",
    "~/Library/Caches/dev.noix.notefix",
    "~/Library/Containers/dev.noix.notefix.widget",
    "~/Library/Group Containers/5V8ZCK434F.dev.noix.notefix",
    "~/Library/Preferences/dev.noix.notefix.plist",
    "~/Library/WebKit/dev.noix.notefix",
  ]
end
