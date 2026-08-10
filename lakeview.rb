# typed: false
# frozen_string_literal: true

# Maintained by hand. lakeview is a Rust crate, so there is no GoReleaser
# pipeline to regenerate this file: bump the version, urls and sha256s from the
# release workflow's job summary when tagging a version.
class Lakeview < Formula
  desc "Terminal browser for lakeFS"
  homepage "https://github.com/jeril-divyam/lakeview"
  version "0.1.1"
  license "MIT"

  on_macos do
    # Apple silicon only.
    on_arm do
      url "https://github.com/jeril-divyam/lakeview/releases/download/v0.1.1/lakeview_0.1.1_darwin_arm64.tar.gz"
      sha256 "2ab4c20a724dbd936b16dfe64e30ce1cf947e34a1fdde44cd7fd27c3f2af997b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jeril-divyam/lakeview/releases/download/v0.1.1/lakeview_0.1.1_linux_amd64.tar.gz"
      sha256 "00eeba65b6fe2a5ea65c98da10c2a03a31601f6461917c071b258510732b0e89"
    end
    on_arm do
      url "https://github.com/jeril-divyam/lakeview/releases/download/v0.1.1/lakeview_0.1.1_linux_arm64.tar.gz"
      sha256 "7a28fe05df18b24b83f3f5a5bb659b4d742b911a8d918a00c08296f3e0d176aa"
    end
  end

  def install
    bin.install "lakeview"
    doc.install "README.md", "lakeview.example.toml"
    # `license` above only records which one it is; this ships the notice.
    prefix.install "LICENSE"
  end

  test do
    assert_match "lakeview #{version}", shell_output("#{bin}/lakeview --version")

    # Every path below names its config explicitly, so the test never depends on
    # where a config directory lands or on one already being there. `check` is
    # left out for the same reason: it is the only command that goes to the
    # network, and what answers a lakeFS port on the machine running this is not
    # something a formula test should have an opinion about.
    config = testpath/"lakeview.toml"

    # No config yet: it should say which file it wanted and how to make one,
    # rather than failing somewhere inside the TUI.
    output = shell_output("#{bin}/lakeview --config #{config} 2>&1", 1)
    assert_match "lakeview init", output

    # `init` writes a starter config, and `profiles` reads it back. The template
    # it writes takes its secret from the environment, and a profile is resolved
    # as the config loads, so the variable has to be there for any subcommand.
    ENV["LAKEFS_SECRET_ACCESS_KEY"] = "test-secret"
    system bin/"lakeview", "init", "--config", config
    assert_predicate config, :exist?
    assert_match "local", shell_output("#{bin}/lakeview profiles --config #{config}")
  end
end
