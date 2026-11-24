# Cask for NoiXdev/homebrew-tap. Bumped by Radarix's release workflow, which
# dispatches bump.yml with the checksum of the DMG it just uploaded.
cask "radarix" do
  version "1.2.0"
  sha256 "1d0d5d7c23a59f4959864d169d2e783a1141ad7c1308b95612a8dc69468105fd"

  url "https://github.com/NoiXdev/radarix/releases/download/v#{version}/Radarix-#{version}.dmg"
  name "Radarix"
  desc "Menu bar watcher for new and updated GitHub pull requests and issues"
  homepage "https://github.com/NoiXdev/radarix"

  # LSMinimumSystemVersion in the app's Info.plist is 15.0.
  depends_on macos: :sequoia

  app "Radarix.app"

  # Measured against the installed 1.0.0-rc.2 on 2026-11-24. The app and its
  # widget share their store in the App Group container; the widget, which is
  # sandboxed, also gets a container of its own. Application Support/Radarix
  # is where builds without the App Group (unsigned ones) keep the store
  # instead. Nothing is written to ~/Library/Caches or Saved Application State.
  #
  # `zap` removes accounts, watched repositories, what was seen and the
  # settings. It does NOT remove the GitHub sign-ins: those live in the macOS
  # Keychain, which a cask cannot delete and should not try to.
  zap trash: [
    "~/Library/Application Scripts/5V8ZCK434F.dev.noix.radarix",
    "~/Library/Application Scripts/dev.noix.radarix",
    "~/Library/Application Scripts/dev.noix.radarix.widget",
    "~/Library/Application Support/Radarix",
    "~/Library/Containers/dev.noix.radarix.widget",
    "~/Library/Group Containers/5V8ZCK434F.dev.noix.radarix",
    "~/Library/Preferences/dev.noix.radarix.plist",
  ]
end
