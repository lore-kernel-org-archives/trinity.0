From: Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH] Fix BITS_PER_LONG for ppc32
Date: Wed, 27 Mar 2013 10:06:20 +0400
Message-ID: <1364364380-3075-1-git-send-email-kda@linux-powerpc.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com, kda@linuxpowerpc.org, Denis Kirjanov <kda@linux-powerpc.org>

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/arch-ppc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/arch-ppc.h b/include/arch-ppc.h
index 8c1a71a..792a54a 100644
--- a/include/arch-ppc.h
+++ b/include/arch-ppc.h
@@ -17,7 +17,7 @@
 #define TASK_SIZE 		(PAGE_OFFSET)
 
 #define PAGE_SHIFT		12
-#define BITS_PER_LONG		64
+#define BITS_PER_LONG		32
 #define PTE_RPN_SHIFT		(PAGE_SHIFT)
 #define PTE_FILE_MAX_BITS	(BITS_PER_LONG - PTE_RPN_SHIFT)
 
-- 
1.8.0.2

