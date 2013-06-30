From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 8/8] ioctls/vhost: VHOST_SCSI_* ioctls
Date: Sun, 30 Jun 2013 22:33:12 +0300
Message-ID: <1372620792-16384-9-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=YnRtrWIJbboq3UCre9HRi2S80dPn8Zqk5gKFIL0itO4=;
        b=vebFc4o88qqrE/F68kX4TeoGvWn1xUwkHyuZtUVlzmR6SU0QGm6SzQZCcRrmmksoMM
         G5kNIJRk8h0RGXMrgojHXm53vqhv7tz82bo5K2ODWpsn/9yAphxXbYwJTriwikidcR/m
         r0XIqheQyo9ISlanBUeiaqTr/CjO2hM0YhoItTImw9svj7EwplYEk1kDxeeH6TTh1ubA
         /o3AIOSbPyq5lCSKV1K/Tt4Km+6zYun/bPolcuenBuOwleQ9DOMAHkSg69/utQIfcqYe
         HtIZhU4llXIrqvS+jTvcXt+HGnmcEjMYpEVm3OQpS3nCrfbLNrwgAZQxQy1+EGMx2d4o
         iVMg==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 ioctls/vhost.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/ioctls/vhost.c b/ioctls/vhost.c
index 58a8b09..3842678 100644
--- a/ioctls/vhost.c
+++ b/ioctls/vhost.c
@@ -22,6 +22,21 @@ static const struct ioctl vhost_ioctls[] = {
 	IOCTL(VHOST_SET_VRING_CALL),
 	IOCTL(VHOST_SET_VRING_ERR),
 	IOCTL(VHOST_NET_SET_BACKEND),
+#ifdef VHOST_SCSI_SET_ENDPOINT
+	IOCTL(VHOST_SCSI_SET_ENDPOINT),
+#endif
+#ifdef VHOST_SCSI_CLEAR_ENDPOINT
+	IOCTL(VHOST_SCSI_CLEAR_ENDPOINT),
+#endif
+#ifdef VHOST_SCSI_GET_ABI_VERSION
+	IOCTL(VHOST_SCSI_GET_ABI_VERSION),
+#endif
+#ifdef VHOST_SCSI_SET_EVENTS_MISSED
+	IOCTL(VHOST_SCSI_SET_EVENTS_MISSED),
+#endif
+#ifdef VHOST_SCSI_GET_EVENTS_MISSED
+	IOCTL(VHOST_SCSI_GET_EVENTS_MISSED),
+#endif
 };
 
 static const char *const vhost_devs[] = {
-- 
1.8.1.4
