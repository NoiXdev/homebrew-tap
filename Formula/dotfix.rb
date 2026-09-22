# Formula for NoiXdev/homebrew-tap. Copied there by the release workflow;
# kept here so it is versioned alongside the binary it installs.
#
# The url is written out in full rather than interpolating `version`. Homebrew
# requires `url` before `version` (FormulaAudit/ComponentsOrder) and derives
# the version from the url itself, so interpolating would force the wrong
# order. A release bump therefore rewrites the url and the sha256 — not a
# separate version field.
class Dotfix < Formula
  desc "Keep macOS terminal setups in sync across machines"
  homepage "https://github.com/NoiXdev/dotfix"
  url "https://github.com/NoiXdev/dotfix/releases/download/v1.0.0/dotfix-v1.0.0-macos-universal.tar.gz"
  sha256 "1e5d5df949375efaf55a3b1f25c46dfe83f4ea64051677362fe3191a26a7ef52"
  license "MIT"

  depends_on :macos

  def install
    bin.install "dotfix"
  end

  test do
    assert_match "dotfix", shell_output("#{bin}/dotfix --version")
  end
end
