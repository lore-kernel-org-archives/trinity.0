From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 3/8] Avoid needless get_filename() calls in generate_pathname()
Date: Sun, 30 Jun 2013 22:33:07 +0300
Message-ID: <1372620792-16384-4-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=Q/rKjOs7WliLqPJVrbQVk/xScWqFlgi10kXupJdZtlI=;
        b=jA9ObLnH+CF9y/aud2fLGelAK4svn5qQmJv+vrvntsimwvnw7SoyfkceozNeu5wd4G
         H53I9Kn8UgnIMFYq9ZGBH+R00gdf0+71U2jDm/cCtrtNldELBlJuNwZ3JKjZNj8EbSog
         staRK0TpDm24QIZTqDNlobYSMJYYZmbSFgp7rgwO8JqgKiXeHAEnjBvozVjmQuw826m4
         8RgcZ6CUce+XLrxwq0cUmCKS9N+puUYYvCLfHKegLz5fD1VnnUiCI183jrq1ff689+Q/
         QT5+u8PuY6/S8WGIniNB+3TuQHPRCEZSBq+WtEzQRATcT+F7D0trn+NYP93+9z0jKf80
         Aolw==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 files.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/files.c b/files.c
index 89a11d4..3319eef 100644
--- a/files.c
+++ b/files.c
@@ -363,13 +363,13 @@ char * generate_pathname(void)
 	case 0 ... 90:
 		/* 90% chance of returning an unmangled filename */
 		if ((rand() % 100) > 10)
-			return get_filename();
+			return pathname;
 
 	case 91 ... 99:
 		/* Create a bogus filename. */
 		newpath = malloc(page_size);	// FIXME: We leak this.
 		if (newpath == NULL)
-			return get_filename();	// give up.
+			return pathname;	// give up.
 
 		generate_random_page(newpath);
 
-- 
1.8.1.4
