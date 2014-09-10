From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 2/2] Fix powerpc build on Ubuntu
Date: Wed, 10 Sep 2014 14:26:54 +1000
Message-ID: <1410323214-23324-2-git-send-email-mpe@ellerman.id.au>
References: <1410323214-23324-1-git-send-email-mpe@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1410323214-23324-1-git-send-email-mpe@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

In commit df1508cd4151 "move rtas syscall definition to ppc specific
directory" the rtas syscall got moved to syscalls/ppc, and we added a
rule in the Makefile to pick that up based on the output of
gcc -dumpmachine.

That rule only looks for "ppc*" though, on Ubuntu gcc emits
"powerpc-linux-gnu", or "powerpc64le-linux-gnu".
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index eeb8c740b19e..5eb21b55a1e3 100644
--- a/Makefile
+++ b/Makefile
@@ -62,7 +62,7 @@ MACHINE		= $(shell $(CC) -dumpmachine)
 SYSCALLS_ARCH	= $(shell case "$(MACHINE)" in \
 		  (sh*) echo syscalls/sh/*.c ;; \
 		  (ia64*) echo syscalls/ia64/*.c ;; \
-		  (ppc*) echo syscalls/ppc/*.c ;; \
+		  (ppc*|powerpc*) echo syscalls/ppc/*.c ;; \
 		  (sparc*) echo syscalls/sparc/*.c ;; \
 		  esac)
 
-- 
1.9.1
