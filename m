From: =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>
Subject: [PATCH] load correct syscall table for s390 and s390x
Date: Sat,  1 Feb 2014 11:12:04 +0100
Message-ID: <1391249524-5384-1-git-send-email-dan@danny.cz>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

The actual syscall table for s390/s390x must be loaded depending on
the __s390x__ symbol.

building on s390 (32=bit) ends with
...
In file included from /builddir/build/BUILD/trinity-1.3/include/arch.h:27:0,
                 from tables.c:10:
tables.c: In function 'select_syscall_tables':
/builddir/build/BUILD/trinity-1.3/include/arch-s390.h:24:18: error: 'syscalls_s390x' undeclared (first use in this function)
 #define SYSCALLS syscalls_s390x
                  ^
tables.c:347:32: note: in expansion of macro 'SYSCALLS'
  syscalls = copy_syscall_table(SYSCALLS, ARRAY_SIZE(SYSCALLS));
                                ^
/builddir/build/BUILD/trinity-1.3/include/arch-s390.h:24:18: note: each undeclared identifier is reported only once for each function it appears in
 #define SYSCALLS syscalls_s390x
                  ^
tables.c:347:32: note: in expansion of macro 'SYSCALLS'
  syscalls = copy_syscall_table(SYSCALLS, ARRAY_SIZE(SYSCALLS));
                                ^
make: *** [tables.o] Error 1
---
 include/arch-s390.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/arch-s390.h b/include/arch-s390.h
index 030b4cf..c322030 100644
--- a/include/arch-s390.h
+++ b/include/arch-s390.h
@@ -8,6 +8,8 @@
 #define PAGE_SHIFT	12
 #define PTE_FILE_MAX_BITS 59
 
+#define SYSCALLS syscalls_s390x
+
 #else /* __s390x__ */
 
 #define KERNEL_ADDR	0UL
@@ -15,6 +17,8 @@
 #define PAGE_SHIFT	12
 #define PTE_FILE_MAX_BITS 26
 
+#define SYSCALLS syscalls_s390
+
 #endif /* __s390x__ */
 
 #define PAGE_OFFSET		0x0UL
@@ -22,5 +26,3 @@
 #define PTRACE_GETFPREGS	0
 #define PTRACE_SETREGS		0
 #define PTRACE_SETFPREGS	0
-
-#define SYSCALLS syscalls_s390x
-- 
1.8.1.4
