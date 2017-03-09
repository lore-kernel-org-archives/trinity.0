From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Check for bpf_prog_type BPF_PROG_TYPE_PERF_EVENT.
Date: Thu,  9 Mar 2017 00:00:14 +0000
Message-ID: <1489017614-11280-1-git-send-email-vlee@freedesktop.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

BPF_PROG_TYPE_PERF_EVENT is not available until Linux 4.9.

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 configure | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/configure b/configure
index dff66d3fbe50..03632d7a7952 100755
--- a/configure
+++ b/configure
@@ -236,6 +236,8 @@ void main()
 	union bpf_attr attr = {
 		.map_flags = 0,
 	};
+
+	enum bpf_prog_type type = BPF_PROG_TYPE_PERF_EVENT;
 }
 EOF
 
-- 
2.9.3
