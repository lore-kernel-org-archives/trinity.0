From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 3/4] Fix compile error in net/bpf.c for non x86
Date: Sat,  1 Jun 2013 21:46:17 +1000
Message-ID: <1370087178-23439-3-git-send-email-michael@ellerman.id.au>
References: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1370087178-23439-1-git-send-email-michael@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

In bpf.c there is an architecture check with cases for i386, x86-64 and
"other". But the other case typos TRUE_ARCH, leading to a build error.

---

Should this be in include/arch-foo.h ?
---
 net/bpf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpf.c b/net/bpf.c
index cc748de..1643077 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -150,7 +150,7 @@ static const uint32_t bpf_seccomp_jmp_arch_vars[] = {
 # define TRUE_ARCH		AUDIT_ARCH_X86_64
 #else
 # define TRUE_REG_SYSCALL	((uint32_t) rand()) /* TODO later */
-# define TRUE_ARCH_NR		((uint32_t) rand()) /* TODO later */
+# define TRUE_ARCH		((uint32_t) rand()) /* TODO later */
 #endif
 
 struct seccomp_data {
-- 
1.7.10.4
