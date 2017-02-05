From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 1/5] Makefile: use grep -c to avoid wc -l
Date: Sun,  5 Feb 2017 17:53:48 +0200
Message-ID: <20170205155352.13191-1-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GuF2tfDuZagCI4qJbrNR5Z2QYlDUdvJizLEiTRaaQ3U=;
        b=VOnvo/srjzd/0S9gDWcH+21qcgx3jFfFsFc0iEMGo1OkS56y719A3Vl/xnKfA9xGpz
         o9cOMgWrxsw/a6Nxg3zvEMXv0LSHqNA1zY0W9KleGpX+iRscpXTuv0Ett8Ymz9SILHKa
         P5oxD1b7neLohA7pL78u1hSxNl/J8ZLqgQR0KAATTrD4HRW7Q+GdlSdrvnworwwPK+wi
         PZkzLMZoistWQV1X7x2vRDhxuIKW7Uaiq/N29QK0yqz8xmX3HDx3swjv2BA9rlsyjR84
         vXa0kyEfouNoJ6xXNAJOGD1n40B9RgiLSUTAFT1zPiumoEPz1LTW4t9VU7q+eIxMk5CH
         40uQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b93fc3a..16fafe8 100644
--- a/Makefile
+++ b/Makefile
@@ -2,7 +2,7 @@ VERSION="1.8pre"
 
 INSTALL_PREFIX ?= $(DESTDIR)
 INSTALL_PREFIX ?= $(HOME)
-NR_CPUS := $(shell grep ^processor /proc/cpuinfo | /usr/bin/wc -l)
+NR_CPUS := $(shell grep -c ^processor /proc/cpuinfo)
 
 ifeq ($(CC),"")
 CC := gcc
-- 
2.9.3
