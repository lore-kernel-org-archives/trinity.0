From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 2/8] Fix open() result check in check_tainted()
Date: Sun, 30 Jun 2013 22:33:06 +0300
Message-ID: <1372620792-16384-3-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=tVYVijceSvN/UlcEJitRpzh2KxiamxidrP5u6ICaWb4=;
        b=knoZ6brNdlK4PSB1IqW/caOnT7UNPai17k1uy2hgj9quZj3iUwVQX1xDf2C6XOptYB
         viBtJCv5XiwcABFZsO8xm9e2ZU6Y2niybYBlt2ArgVe6gTWEmLX+h/8hsEJrRBFG9uxN
         36MjZNuc4BNOvTXQYvp+SZIuAMQdDrsdwCzV5YK0LXNSYPSGfAicF3UZ2XFWgkHRrqjY
         I9l7Qo/i9LY+bEqpYOw0SaXZzJDAoHGElZUEFJOBK33As9JbaMKltAwdc0ExfabL38/w
         BvYkbLgu6CFMz4oZ3n/Bqxe6XKFH+RrEQVHe19IY3zcGiV7IFuk8jjU7vvm42/eWYzU5
         W3Eg==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/main.c b/main.c
index 648e56d..0e58433 100644
--- a/main.c
+++ b/main.c
@@ -57,7 +57,7 @@ int check_tainted(void)
 	char buffer[4];
 
 	fd = open("/proc/sys/kernel/tainted", O_RDONLY);
-	if (!fd)
+	if (fd < 0)
 		return -1;
 	ret = read(fd, buffer, 3);
 	close(fd);
-- 
1.8.1.4
