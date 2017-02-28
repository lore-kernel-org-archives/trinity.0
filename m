From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] fds/drm.c: Increase buffer size.
Date: Tue, 28 Feb 2017 19:49:16 +0000
Message-ID: <1488311356-12461-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

Fix GCC format-truncation error.

  CC	fds/drm.o
fds/drm.c: In function ‘open_drm_fds’:
fds/drm.c:106:40: error: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size 119 [-Werror=format-truncation=]
   snprintf(buf, sizeof(buf), "/dev/dri/%s", entry->d_name);
                                        ^~
In file included from /usr/include/stdio.h:939:0,
                 from include/list.h:3,
                 from include/fd.h:3,
                 from fds/drm.c:4:
/usr/include/bits/stdio2.h:64:10: note: ‘__builtin___snprintf_chk’ output between 10 and 265 bytes into a destination of size 128
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 fds/drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fds/drm.c b/fds/drm.c
index 1f7b95f1eb34..b094183d8d0d 100644
--- a/fds/drm.c
+++ b/fds/drm.c
@@ -83,7 +83,7 @@ static int open_drm_fds(void)
 	int fd, dfd;
 	DIR *dir;
 	struct dirent *entry;
-	char buf[128];
+	char buf[512];
 
 	head = get_objhead(OBJ_GLOBAL, OBJ_FD_DRM);
 	head->destroy = &drmfd_destructor;
-- 
2.11.1
