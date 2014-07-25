From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH] ignore patch file on top level
Date: Fri, 25 Jul 2014 15:43:47 +0800
Message-ID: <1406274227-24742-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=jzpUOPgqsOasS+znJMbImRlvLEtF5GxJ/mQgvs7rW3g=;
        b=SgTwFbz4JwQoquTEm86pEHndAFF7mWkUzHqNkfgGFZAw3zcLe4jFUjeJmUy/wU7gla
         R7XX5/ec0uGAgcqbdjbGc7w1mCil3nrKo3e+RiItr+9SGaZSZ5qkXIzA+HAiMA6h0iDa
         lCX4kb1kJZELAeCtWuTiJI+HPY5vGmSY/aDWi+NP7Ij/vGV5wzUiGKGO8YXNIBmfR3lV
         BOfk261+PEaPDOMOEeB3wkhBMw6d8lAYi5aKBCw61Pgi7bXw0Psapxu/M/OB535YqyFm
         cBAUn7YM1+CCAWuJN/TfkW//FEdFEPjt5vTEtG1OyCTqpP8SvPeVpKiHAXndmZClGS4l
         kEQg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Trinity <trinity@vger.kernel.org>
Cc: Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 1b13452..8940a43 100644
--- a/.gitignore
+++ b/.gitignore
@@ -16,3 +16,4 @@ cscope.*
 ncscope.*
 cov-int
 trinity-coverity.tar.xz
+/*.patch
-- 
1.9.3
