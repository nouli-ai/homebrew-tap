class Nouli < Formula
  desc "Multi-turn harness for decision models"
  homepage "https://nouli.ai/"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
  end

  if OS.mac?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.4.3/nouli-0.4.3-aarch64-apple-darwin.tar.gz"
    sha256 "209fba56e6a56d2ec35f28de0cbf00a146f726f1fe2be4a0cdffcc2d5a11e254"
  elsif Hardware::CPU.arm?
    url "https://github.com/nouli-ai/nouli/releases/download/v0.4.3/nouli-0.4.3-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "80bbbf2863a80434b015bcd41ac0f0fa561c7089506f3d27c10eb7c5f60f006a"
  else
    url "https://github.com/nouli-ai/nouli/releases/download/v0.4.3/nouli-0.4.3-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "139fdd5074023fe75d5a3498a2165ca323102acaf3295f223dfdb2f9d5c88274"
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
