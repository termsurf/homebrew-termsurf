class Termsurf < Formula
  desc "A protocol for embedding web browsers inside terminal emulators"
  homepage "https://termsurf.com"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/termsurf/termsurf/releases/download/v0.1.0/termsurf-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "d938057ff8c5bd746a2b2c6b17a6efeee521714e8757678fbc852516e3a0e683"
    end
  end

  def install
    bin.install "web"
    bin.install "wezboard"

    # Roamium + Chromium dylibs and resources
    (prefix/"roamium").install Dir["roamium/*"]

    # Ad-hoc codesign (macOS requires valid signature)
    system "codesign", "--force", "--sign", "-", bin/"web"
    system "codesign", "--force", "--sign", "-", bin/"wezboard"
    system "codesign", "--force", "--sign", "-", prefix/"roamium/roamium"
  end

  def caveats
    <<~EOS
      Wezboard.app is not installed by Homebrew. To install the GUI:
        Download from https://github.com/termsurf/termsurf/releases

      Roamium (Chromium engine) is installed to:
        #{opt_prefix}/roamium/

      After installation, open Wezboard and type:
        web ryanxcharles.com
    EOS
  end

  test do
    assert_predicate bin/"web", :executable?
    assert_predicate bin/"wezboard", :executable?
    assert_predicate prefix/"roamium/roamium", :executable?
  end
end
