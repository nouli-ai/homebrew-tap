class Nouli < Formula
  desc "Multi-turn harness for decision models"
  homepage "https://nouli.ai/"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
  end

  if OS.mac?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.5.0/nouli-0.5.0-aarch64-apple-darwin.tar.gz"
    sha256 "03dca325a00cec6785e706f962b03ce3b4137ab385c4e7e7fb25872ce222d510"
  elsif Hardware::CPU.arm?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.5.0/nouli-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "bb08a53dc3b39ca38157a9cd936c24bab9ef147c844e0eed0879eb6fbd66d261"
  else
    url "https://github.com/nouli-ai/nouli/releases/download/v0.5.0/nouli-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "63561a13cd4ae96da92a1129e485ba270efff295c41e2c7c155f770b31179b98"
  end

  def install
    if OS.linux? && OS::Linux::Glibc.system_version < Version.new("2.38")
      odie "Nouli requires system glibc 2.38 or newer; use Ubuntu 24.04 or a compatible GNU/Linux system"
    end
    bin.install "nouli"
  end

  test do
    assert_equal "nouli #{version}", shell_output("#{bin}/nouli --version").strip
    assert_match "Usage: nouli", shell_output("#{bin}/nouli --help")
    refute_path_exists testpath/".nouli"
  end
end
