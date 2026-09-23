# Cask for NoiXdev/homebrew-tap. Bumped by Printy's release workflow, which
# dispatches bump.yml with the checksum of the DMG it just uploaded.
#
# Casks carry a `version` and interpolate it into the url — the opposite of a
# formula. See SETUP.md.
cask "printy" do
  version "0.1.0"
  sha256 "REPLACE_ON_FIRST_RELEASE"

  url "https://github.com/NoiXdev/printy/releases/download/v#{version}/Printy_#{version}_universal.dmg"
  name "Printy"
  desc "Watch folders and print the files that land in them"
  homepage "https://github.com/NoiXdev/printy"

  depends_on macos: :ventura

  app "Printy.app"

  zap trash: [
    "~/Library/Application Support/com.noidee.printy",
    "~/Library/Caches/com.noidee.printy",
    "~/Library/Preferences/com.noidee.printy.plist",
    "~/Library/Saved Application State/com.noidee.printy.savedState",
  ]
end
