From: Ildar Muslukhov <ildarm@google.com>
Subject: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Thu, 19 Sep 2013 14:24:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=7guKpmLRxgKml6l79lYw/ZrvjmOigxl9lJxPm6mEEGo=;
        b=R3QsF7Pu7UAmZypJZDCVR9K94TYISO4Vh2U9PSR2zGK8QQAdiCVdOiY9jo7l3mNc0A
         U81oTuBu1qMDKzLsq3pX05AH0AX3l6klc+SLtrfMoOP2qLj6f8Dtj6/ux88E10C/cC6C
         71rtIlWYAmNC38ATCOQzA/Yns9JoxklCWxxx6RFLRr4bfatpLFlNo11tmkJhS/jRh67l
         swa2W3CeyTTQbH7ZfTbBVn0PDGFCoK1Iry/T79oU7m9J3rThBwCie6Ud2gWn+ShRDMPT
         Z0nzq9LyUtzQEYyARmGUuRnnk6Khd7+5mp4HNFcbnH2Av5SUPn9PmfCVVsfuXUiyOlHg
         D6vA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: davej@redhat.com


This patch fixes missing 6th param for 32bit syscalls in i386 and x86_64 
archs.

Note: I have to remove static from syscall32, because gcc messes up with 
inline asm becuase of that.

Signed-off-by: Ildar Muslukhov <ildarm@google.com>

---
 include/syscall.h |  1 +
 syscall.c         | 44 +++++++++++++++++++++++++++++++++++---------
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/include/syscall.h b/include/syscall.h
index 9fc9885..faaeafc 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -134,6 +134,7 @@ void count_syscalls_enabled(void);
 void display_enabled_syscalls(void);
 void disable_non_net_syscalls(void);
 void init_syscalls(void);
+long syscall32(int num_args, unsigned int call, unsigned long a1, unsigned long a2, unsigned long a3, unsigned long a4, unsigned long a5, unsigned long a6);
 
 #define for_each_32bit_syscall(i) \
 	for (i = 0; i < max_nr_32bit_syscalls; i++)
diff --git a/syscall.c b/syscall.c
index 866ac71..63f25a6 100644
--- a/syscall.c
+++ b/syscall.c
@@ -33,22 +33,48 @@
 	return (type) (res); \
 } while (0)
 
-static long syscall32(int num_args, unsigned int call,
+long syscall32(int num_args, unsigned int call,
 	unsigned long a1, unsigned long a2, unsigned long a3,
-	unsigned long a4, unsigned long a5, __unused__ unsigned long a6)
+	unsigned long a4, unsigned long a5, unsigned long a6)
 {
 #if defined(__i386__) || defined (__x86_64__)
-	if (num_args < 6) {
+
+	if (num_args <= 6) {
 		long __res;
-		__asm__ volatile ("int $0x80"
+#if defined( __i386__)
+		__asm__ volatile (
+			"pushl %%ebp\n\t"
+			"movl %7, %%ebp\n\t"
+			"int $0x80\n\t"
+			"popl %%ebp\n\t"
+			: "=a" (__res)
+			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),"d" ((long)(a3)), "S" ((long)(a4)),"D" ((long)(a5)), "g" ((long)(a6))
+			: "%ebp" /* mark EBP reg as dirty */
+			);
+#elif defined(__x86_64__)
+		__asm__ volatile (
+			"pushq %%rbp\n\t"
+			"movq %7, %%rbp\n\t"
+			"int $0x80\n\t"
+			"popq %%rbp\n\t"
 			: "=a" (__res)
-			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),
-			"d" ((long)(a3)), "S" ((long)(a4)),
-			"D" ((long)(a5)));
+			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),"d" ((long)(a3)), "S" ((long)(a4)),"D" ((long)(a5)), "g" ((long)(a6))
+			: "%rbp" /* mark EBP reg as dirty */
+			);
+#else
+	//To shut up gcc on unused args. This code should never be reached.
+	__res = 0;
+	UNUSED(num_args);
+	UNUSED(call);
+	UNUSED(a1);
+	UNUSED(a2);
+	UNUSED(a3);
+	UNUSED(a4);
+	UNUSED(a5);
+	UNUSED(a6);
+#endif
 		__syscall_return(long,__res);
-		return __res;
 	}
-/* TODO: 6 arg 32bit x86 syscall goes here.*/
 #else
 
 // TODO: 32-bit syscall entry for non-x86 archs goes here.
-- 
1.8.4
