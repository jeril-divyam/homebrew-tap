# typed: false
# frozen_string_literal: true

# Maintained by hand. lakeview is a Rust crate, so there is no GoReleaser
# pipeline to regenerate this file: bump the version, urls and sha256s from the
# release workflow's job summary when tagging a version.
class Lakeview < Formula
  desc "Terminal browser for lakeFS"
  homepage "https://github.com/jeril-divyam/lakeview"
  version "0.1.7"
  license "MIT"

  on_macos do
    # Apple silicon only.
    on_arm do
      url "https://github.com/jeril-divyam/lakeview/releases/download/v0.1.7/lakeview_0.1.7_darwin_arm64.tar.gz"
      sha256 "661d78e143868d4d884e833994954530953fc195d449ac56ade7f0fac770fcca"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jeril-divyam/lakeview/releases/download/v0.1.7/lakeview_0.1.7_linux_amd64.tar.gz"
      sha256 "a54bbc946e6c3dc73258c7b93bee76d94cbe3101785f529b05a7cc02ad1b2b91"
    end
    on_arm do
      url "https://github.com/jeril-divyam/lakeview/releases/download/v0.1.7/lakeview_0.1.7_linux_arm64.tar.gz"
      sha256 "9f8a0e43eac4546061fe58a201cf57017e4bba4f85da5213a9e46b8006053078"
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
