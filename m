From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/4] make: Add cscope target
Date: Fri, 25 Oct 2013 01:39:25 +0400
Message-ID: <1382650768-30954-2-git-send-email-gorcunov@gmail.com>
References: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kVPWvD0S90rg46IBmD4nqqRulb9o4uJLNFn5SMorkCM=;
        b=OFADKwoEZs0fUHGfd7RQMnoDw781AvYxQYiZ44p7zjvvch0xjdAs737jVVWzijQ7u2
         hya9x7RHShjRUMS1m2JyalnGbUJmwi+crTYLIfgINsRjRCF+ZPhCArdNJQ9DaySyrRgm
         LLCz7byecypbUWQv8qV3aADxB4Fd1CWy/HCXq/+ov4A4qIjj6XW8feW1lWmjP4TBsnnB
         cxF1iv3LnfMuXTNPMou5fuoalLGa5hpbT1bmWJrJPyeNiODRAOPQgqFaSZtcTLhPbZF4
         8N17A5c5IRyvzyatuuLlwWPi4NDi1FL1Cv33Cwzyu5xc+cYGXlaifm3zUHl96UvlYEgD
         rmZQ==
In-Reply-To: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Just another source indexing system which might
be preferred over tags.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index b0bdb36..76f078b 100644
--- a/Makefile
+++ b/Makefile
@@ -125,3 +125,6 @@ coverity:
 	cov-build --dir cov-int make
 	tar czvf trinity-coverity.tgz cov-int
 
+cscope:
+	@find . -name '*.[hcS]' ! -path './.*' -print > cscope.files
+	@cscope -bkqu
-- 
1.8.3.1
