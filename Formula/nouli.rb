class Nouli < Formula
  desc "Multi-turn harness for decision models"
  homepage "https://nouli.ai/"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
  end

  if OS.mac?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.5.1/nouli-0.5.1-aarch64-apple-darwin.tar.gz"
    sha256 "1f65b7f0c55ea53020df69f1e88e4272817266060f639328fb406286f7bb628a"
  elsif Hardware::CPU.arm?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.5.1/nouli-0.5.1-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "5afc3275f937551fc3901f8db176486666b331827b9442623d2807d6074656a4"
  else
    url "https://github.com/nouli-ai/nouli/releases/download/v0.5.1/nouli-0.5.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4e65df7881b5245592f804b0dcb5039d0ce757ee8af3d7727815de8155de9f70"
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
