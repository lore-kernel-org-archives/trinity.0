From: Andy Honig <ahonig@google.com>
Subject: [PATCH] improve randomness in rand64()
Date: Fri, 19 Jul 2013 14:39:15 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1307191432480.14274@exit8.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=CykwyfcVwx4Ht1FKwXiAR7DHcf2d5GKKzi2zUVtDez0=;
        b=liVKXTc4tkZjZb4HTsXkCbuqnGvCBBDu7gPk79WOLPBh5+FaDkiLWFXnF8IzCTTWvJ
         e+A1MnwW1SIIHVqHW3eJVZFxxVI+PoahQ+nXOM9JJ4v0/z7WEFMOazhxPTKXaT+Oos9d
         rZZdgBzNZZ8PCutMimsnW3eb/dlyaoDf7VlvTGXNR8lbp9E62LtBkXfodshrCZ4M9IW9
         u1rgSlhktAT3xHdjMQyoypxsbstzEiU0Ct6ZPK1t73c7w1XlsHy4MEyOCU3vEzCo53CB
         PWbNS50f5Xm2muVivMsP1KgS6I66VmzNcQGmKKHBYz2bwx8uAPAlid0/lHlbMiAdA5pL
         cFcg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org

Commit 6112813df53ce6762f5c8de1d4382d67f9f2f769 introduced
code to occasionally invert the valuerand64().  However the code 
mistakenly zeroed the value instead by xoring it with itself.

Signed-off-by: Andy Honig <ahonig@google.com>

---
 random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/random.c b/random.c
index a12ba42..b148714 100644
--- a/random.c
+++ b/random.c
@@ -214,7 +214,7 @@ u64 rand64(void)
 	}
 
 	if (rand_bool())
-		r ^= r;
+		r = ~r;
 
 	/* increase distribution in MSB */
 	if ((rand() % 10)) {
-- 
1.8.3
