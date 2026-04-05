cask "termsurf" do
  version "0.1.3"
  sha256 "91ed3cf9c9bf196585cc5f0361554597e2e829da8b2d92b01bd192b1f46fae32"

  url "https://github.com/termsurf/termsurf/releases/download/v#{version}/termsurf-#{version}-aarch64-apple-darwin.tar.gz"
  name "TermSurf"
  desc "A protocol for embedding web browsers inside terminal emulators"
  homepage "https://termsurf.com"

  app "TermSurf Wezboard.app"
  binary "web"
  binary "wezboard"

  artifact "roamium", target: "/opt/homebrew/opt/termsurf-roamium"

  postflight do
    system_command "codesign", args: ["--force", "--sign", "-", staged_path/"web"]
    system_command "codesign", args: ["--force", "--sign", "-", staged_path/"wezboard"]
    system_command "codesign", args: ["--force", "--sign", "-", "/opt/homebrew/opt/termsurf-roamium/roamium"]
    system_command "codesign",
                   args: ["--force", "--deep", "--sign", "-",
                          "/Applications/TermSurf Wezboard.app"]
    # Clear quarantine on everything — the tarball propagates the attribute
    # to all extracted files, and Gatekeeper blocks unsigned binaries
    system_command "xattr", args: ["-cr", "/Applications/TermSurf Wezboard.app"]
    system_command "xattr", args: ["-cr", "/opt/homebrew/opt/termsurf-roamium"]
    system_command "xattr", args: ["-cr", staged_path/"web"]
    system_command "xattr", args: ["-cr", staged_path/"wezboard"]
  end

  zap trash: [
    "~/.config/termsurf",
    "~/.local/share/termsurf",
    "~/.local/state/termsurf",
  ]
end
