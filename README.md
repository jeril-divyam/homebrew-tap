# homebrew-tap

Homebrew formulae for my command-line tools.

## Install

Add the tap once:

```sh
brew tap jeril-divyam/tap
```

Then install anything from it:

```sh
brew install jeril-divyam/tap/<formula>
```

## Formulae

| Formula | What it is |
|---|---|
| [`lakeview`](lakeview.rb) | A terminal browser for [lakeFS](https://lakefs.io) |

## Adding a formula

Drop a `<name>.rb` file at the repo root:

```ruby
class Example < Formula
  desc "Short description"
  homepage "https://github.com/jeril-divyam/example"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeril-divyam/example/releases/download/v0.1.0/example-aarch64-apple-darwin.tar.gz"
      sha256 "REPLACE_ME"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/jeril-divyam/example/releases/download/v0.1.0/example-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "REPLACE_ME"
    end
  end

  def install
    bin.install "example"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/example --version")
  end
end
```

Then verify before pushing:

```sh
brew audit --strict --online jeril-divyam/tap/example
brew install --build-from-source jeril-divyam/tap/example
brew test jeril-divyam/tap/example
```
