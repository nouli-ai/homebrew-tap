class Nouli < Formula
  desc "Multi-turn harness for decision models"
  homepage "https://nouli.ai/"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
  end

  if OS.mac?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.6.0/nouli-0.6.0-aarch64-apple-darwin.tar.gz"
    sha256 "3e6957df81acb73337357d30fe65a1ed046d8f3a4973bba6f74f84012e71b19c"
  elsif Hardware::CPU.arm?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.6.0/nouli-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "e30a7618c46cf68a7ae2d24393932fe2185c254df3af2c5267b1b8458a778985"
  else
    url "https://github.com/nouli-ai/nouli/releases/download/v0.6.0/nouli-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "d2ad6c36acb0e4fac6bcf27e0e7bb420f095ab4695ffce3df0c7cddd7f746aa4"
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
