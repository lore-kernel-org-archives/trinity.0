From: Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 1/2] ioctls/vfs.c: add more ioctls from linux/fs.h
Date: Wed, 21 Jun 2017 21:33:57 +0300
Message-ID: <20170621183358.25578-1-tommi.t.rantala@nokia.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LIXDApaCIxEyHCcOpu+K8uRgBeQGdXbPQo0E/J005i0=;
 b=bp+N1g61SuWyJVoBI0cin5EVeDVZpuU4Kl1M8V7Xjcy8bX6H3ybpiN9j0aOTAvcgbCkGxRPFvIHuuu6qQCSn0VNoT+0xfVqe1XciTtZDHWnlJIZiai4R1FtrsEqXQ4DqXL1jhyT2sypW+FIRzuGo+NmR8UTy7am4vXcXHljl/Jg=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>

Note that BLKTRACESETUP needs struct blk_user_trace_setup from
<linux/blktrace_api.h>:

  #define BLKTRACESETUP _IOWR(0x12,115,struct blk_user_trace_setup)
---
 ioctls/vfs.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/ioctls/vfs.c b/ioctls/vfs.c
index 0e31cc88..0bad6f56 100644
--- a/ioctls/vfs.c
+++ b/ioctls/vfs.c
@@ -1,6 +1,7 @@
 #include <stdio.h>
 #include <linux/fiemap.h>
 #include <linux/fs.h>
+#include <linux/blktrace_api.h>
 #include <linux/ioctl.h>
 #include <asm/ioctls.h>
 #include "ioctls.h"
@@ -114,6 +115,132 @@ static const struct ioctl vfs_ioctls[] = {
 	{ .name = "FIONREAD", .request = FIONREAD, },
 	{ .name = "FS_IOC_RESVSP", .request = FS_IOC_RESVSP, },
 	{ .name = "FS_IOC_RESVSP64", .request = FS_IOC_RESVSP64, },
+#ifdef BLKROSET
+	{ .name = "BLKROSET", .request = BLKROSET, },
+#endif
+#ifdef BLKROGET
+	{ .name = "BLKROGET", .request = BLKROGET, },
+#endif
+#ifdef BLKRRPART
+	{ .name = "BLKRRPART", .request = BLKRRPART, },
+#endif
+#ifdef BLKGETSIZE
+	{ .name = "BLKGETSIZE", .request = BLKGETSIZE, },
+#endif
+#ifdef BLKFLSBUF
+	{ .name = "BLKFLSBUF", .request = BLKFLSBUF, },
+#endif
+#ifdef BLKRASET
+	{ .name = "BLKRASET", .request = BLKRASET, },
+#endif
+#ifdef BLKRAGET
+	{ .name = "BLKRAGET", .request = BLKRAGET, },
+#endif
+#ifdef BLKFRASET
+	{ .name = "BLKFRASET", .request = BLKFRASET, },
+#endif
+#ifdef BLKFRAGET
+	{ .name = "BLKFRAGET", .request = BLKFRAGET, },
+#endif
+#ifdef BLKSECTSET
+	{ .name = "BLKSECTSET", .request = BLKSECTSET, },
+#endif
+#ifdef BLKSECTGET
+	{ .name = "BLKSECTGET", .request = BLKSECTGET, },
+#endif
+#ifdef BLKSSZGET
+	{ .name = "BLKSSZGET", .request = BLKSSZGET, },
+#endif
+#ifdef BLKBSZGET
+	{ .name = "BLKBSZGET", .request = BLKBSZGET, },
+#endif
+#ifdef BLKBSZSET
+	{ .name = "BLKBSZSET", .request = BLKBSZSET, },
+#endif
+#ifdef BLKGETSIZE64
+	{ .name = "BLKGETSIZE64", .request = BLKGETSIZE64, },
+#endif
+#ifdef BLKTRACESETUP
+	{ .name = "BLKTRACESETUP", .request = BLKTRACESETUP, },
+#endif
+#ifdef BLKTRACESTART
+	{ .name = "BLKTRACESTART", .request = BLKTRACESTART, },
+#endif
+#ifdef BLKTRACESTOP
+	{ .name = "BLKTRACESTOP", .request = BLKTRACESTOP, },
+#endif
+#ifdef BLKTRACETEARDOWN
+	{ .name = "BLKTRACETEARDOWN", .request = BLKTRACETEARDOWN, },
+#endif
+#ifdef BLKDISCARD
+	{ .name = "BLKDISCARD", .request = BLKDISCARD, },
+#endif
+#ifdef BLKIOMIN
+	{ .name = "BLKIOMIN", .request = BLKIOMIN, },
+#endif
+#ifdef BLKIOOPT
+	{ .name = "BLKIOOPT", .request = BLKIOOPT, },
+#endif
+#ifdef BLKALIGNOFF
+	{ .name = "BLKALIGNOFF", .request = BLKALIGNOFF, },
+#endif
+#ifdef BLKPBSZGET
+	{ .name = "BLKPBSZGET", .request = BLKPBSZGET, },
+#endif
+#ifdef BLKDISCARDZEROES
+	{ .name = "BLKDISCARDZEROES", .request = BLKDISCARDZEROES, },
+#endif
+#ifdef BLKSECDISCARD
+	{ .name = "BLKSECDISCARD", .request = BLKSECDISCARD, },
+#endif
+#ifdef BLKROTATIONAL
+	{ .name = "BLKROTATIONAL", .request = BLKROTATIONAL, },
+#endif
+#ifdef BLKZEROOUT
+	{ .name = "BLKZEROOUT", .request = BLKZEROOUT, },
+#endif
+#ifdef FITRIM
+	{ .name = "FITRIM", .request = FITRIM, },
+#endif
+#ifdef FS_IOC_GETFLAGS
+	{ .name = "FS_IOC_GETFLAGS", .request = FS_IOC_GETFLAGS, },
+#endif
+#ifdef FS_IOC_SETFLAGS
+	{ .name = "FS_IOC_SETFLAGS", .request = FS_IOC_SETFLAGS, },
+#endif
+#ifdef FS_IOC_GETVERSION
+	{ .name = "FS_IOC_GETVERSION", .request = FS_IOC_GETVERSION, },
+#endif
+#ifdef FS_IOC_SETVERSION
+	{ .name = "FS_IOC_SETVERSION", .request = FS_IOC_SETVERSION, },
+#endif
+#ifdef FS_IOC32_GETFLAGS
+	{ .name = "FS_IOC32_GETFLAGS", .request = FS_IOC32_GETFLAGS, },
+#endif
+#ifdef FS_IOC32_SETFLAGS
+	{ .name = "FS_IOC32_SETFLAGS", .request = FS_IOC32_SETFLAGS, },
+#endif
+#ifdef FS_IOC32_GETVERSION
+	{ .name = "FS_IOC32_GETVERSION", .request = FS_IOC32_GETVERSION, },
+#endif
+#ifdef FS_IOC32_SETVERSION
+	{ .name = "FS_IOC32_SETVERSION", .request = FS_IOC32_SETVERSION, },
+#endif
+#ifdef FS_IOC_FSGETXATTR
+	{ .name = "FS_IOC_FSGETXATTR", .request = FS_IOC_FSGETXATTR, },
+#endif
+#ifdef FS_IOC_FSSETXATTR
+	{ .name = "FS_IOC_FSSETXATTR", .request = FS_IOC_FSSETXATTR, },
+#endif
+#ifdef FS_IOC_SET_ENCRYPTION_POLICY
+	{ .name = "FS_IOC_SET_ENCRYPTION_POLICY", .request = FS_IOC_SET_ENCRYPTION_POLICY, },
+#endif
+#ifdef FS_IOC_GET_ENCRYPTION_PWSALT
+	{ .name = "FS_IOC_GET_ENCRYPTION_PWSALT", .request = FS_IOC_GET_ENCRYPTION_PWSALT, },
+#endif
+#ifdef FS_IOC_GET_ENCRYPTION_POLICY
+	{ .name = "FS_IOC_GET_ENCRYPTION_POLICY", .request = FS_IOC_GET_ENCRYPTION_POLICY, },
+#endif
 };
 
 static const struct ioctl_group vfs_grp = {
-- 
2.13.0
