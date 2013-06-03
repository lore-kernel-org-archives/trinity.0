From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH 2/4] minor: move offsetof into trinity.h
Date: Mon,  3 Jun 2013 21:07:42 +0200
Message-ID: <c70de10f036bb80373036794bcfee4d92db393a6.1370285968.git.dborkman@redhat.com>
References: <cover.1370285968.git.dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <cover.1370285968.git.dborkman@redhat.com>
In-Reply-To: <cover.1370285968.git.dborkman@redhat.com>
References: <cover.1370285968.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, davej@redhat.com, dborkman@redhat.com

Move it there since it's of generic use somewhere in future
else as well.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 include/trinity.h | 4 ++++
 net/bpf.c         | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trinity.h b/include/trinity.h
index 3c2e482..158b566 100644
--- a/include/trinity.h
+++ b/include/trinity.h
@@ -32,4 +32,8 @@ extern unsigned int user_specified_children;
 #define max(x, y) ((x) >= (y) ? (x) : (y))
 #define min(x, y) ((x) <= (y) ? (x) : (y))
 
+#ifndef offsetof
+# define offsetof(type, member)	((size_t) &((type *) 0)->member)
+#endif
+
 #endif	/* _TRINITY_H */
diff --git a/net/bpf.c b/net/bpf.c
index bda72e1..2c0ed32 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -28,10 +28,6 @@
 # define SKF_AD_MAX	56
 #endif
 
-#ifndef offsetof
-# define offsetof(type, member)	((size_t) &((type *) 0)->member)
-#endif
-
 #define syscall_nr	(offsetof(struct seccomp_data, nr))
 #define arch_nr		(offsetof(struct seccomp_data, arch))
 
-- 
1.7.11.7
