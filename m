From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 1/9] Use color clearing also in Makefile
Date: Mon,  1 Apr 2013 21:58:31 +0300
Message-ID: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=0EFENQxy8lKWhlr8v+1zCwTjW0EBBGzJCVlW6rYCnUQ=;
        b=uyPVYaCoGwdDH0rMaGYtp+kzyMkcZPmEU7JDxy5AekK2mGil1hd8AcnjCHyM/n3PcY
         VcNvKf7Q+kOqQ40OMKPu7m48B8H6pPfzHb7mkT5Jfm4gJXSjhcVnK0ubQ9HG2vCIPsAD
         VC9GmVGYpnDU4XpMJ53d14c8ByMWob5z9S5ePKZyOi9YdnGMxSnr8sw9bapiX2FchJNI
         goihdMmhtmJ4/+W0/IKAmrrVSrq0aHXDkVw/M/ZFLfeBYgSxzXABxHOcWdqHz1oi2oqt
         OOGP3RIZO8yjUyexGBuj5OiFEECQiyU4Oxnk2KIciHTYBpe3YEPUDrTg3xomhmFWBRHS
         rGFQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 2155f1f..69c9ab1 100644
--- a/Makefile
+++ b/Makefile
@@ -29,7 +29,7 @@ QUIET_CC = $(Q:@=@echo    '  CC	'$@;)
 all: trinity
 
 test:
-	@if [ ! -f config.h ]; then  echo "[1;31mRun configure.sh first.[1;37m" ; exit; fi
+	@if [ ! -f config.h ]; then  echo "[1;31mRun configure.sh first.[0m" ; exit; fi
 
 
 MACHINE		= $(shell $(CC) -dumpmachine)
-- 
1.7.9.5
