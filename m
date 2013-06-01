From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 2/4] Ignore vim swap files
Date: Sat,  1 Jun 2013 21:46:16 +1000
Message-ID: <1370087178-23439-2-git-send-email-michael@ellerman.id.au>
References: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

---
 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 25f8a38..2b3edaa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,3 +10,4 @@ trinity-*.tgz
 victims
 tags
 config.h
+.*.swp
-- 
1.7.10.4
