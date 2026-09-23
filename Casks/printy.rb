# Cask for NoiXdev/homebrew-tap. Bumped by Printy's release workflow, which
# dispatches bump.yml with the checksum of the DMG it just uploaded.
#
# Casks carry a `version` and interpolate it into the url — the opposite of a
# formula. See SETUP.md.
cask "printy" do
  version "1.0.0"
  sha256 "f0c79f7efb87c4f5dc3ec3156cf7f8906407cff8588964c497e93103b7bb7dea"

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
