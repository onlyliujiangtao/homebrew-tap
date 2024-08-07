class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.38.0",
      revision: "143750901ee320506f5083691990f61f1e7d93d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2913d02eb26edae814ff8b7d5e5756df4075e54ee5a640fa555d45173b465404"
    sha256 cellar: :any_skip_relocation, big_sur:       "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, catalina:      "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, mojave:        "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, ventura:       "5934c1c84b5d667a4758c3ead2a5cce420cfa2a310120cb19e3c22b8640b9861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efbcda984fa2b7f5e7bbb74be2aa14dedbc66b8404df2bf04f5e5d9a1e14829b"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.ini" => "frp/frpc.ini"
    etc.install "conf/frpc_full.ini" => "frp/frpc_full.ini"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.ini"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "local_port", shell_output("#{bin}/frpc http", 1)
    assert_match "local_port", shell_output("#{bin}/frpc https", 1)
    assert_match "local_port", shell_output("#{bin}/frpc stcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc tcp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc udp", 1)
    assert_match "local_port", shell_output("#{bin}/frpc xtcp", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc status -c #{etc}/frp/frpc.ini", 1)
    assert_match "admin_port", shell_output("#{bin}/frpc reload -c #{etc}/frp/frpc.ini", 1)
  end
end
