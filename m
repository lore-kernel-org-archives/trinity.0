From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2 2/2] Makefile: fix build with older glibc
Date: Mon,  4 Jan 2016 12:21:31 +0100
Message-ID: <1451906491-20710-2-git-send-email-jslaby@suse.cz>
References: <1451906491-20710-1-git-send-email-jslaby@suse.cz>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1451906491-20710-1-git-send-email-jslaby@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>

man 2 clock_gettime says:
Link with -lrt (only for glibc versions before 2.17).

If we do not do that, we get:
post-mortem.c:61: undefined reference to `clock_gettime'
syscall.o: In function `__do_syscall':
syscall.c:121: undefined reference to `clock_gettime'
watchdog.o: In function `is_child_making_progress':
watchdog.c:317: undefined reference to `clock_gettime'

So introduce (standard) LDLIBS into Makefile and add -lrt there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 0cdcf4be0ae0..a70c5bd958a5 100644
--- a/Makefile
+++ b/Makefile
@@ -37,6 +37,9 @@ CFLAGS += -Wstrict-prototypes -Wmissing-prototypes
 # needed for show_backtrace() to work correctly.
 LDFLAGS += -rdynamic
 
+# glibc versions before 2.17 for clock_gettime
+LDLIBS += -lrt
+
 # gcc only.
 ifneq ($(shell $(CC) -v 2>&1 | grep -c "clang"), 1)
 CFLAGS += -Wlogical-op
@@ -96,7 +99,7 @@ DEPDIR= .deps
 -include $(SRCS:%.c=$(DEPDIR)/%.d)
 
 trinity: version test $(OBJS) $(HEADERS)
-	$(QUIET_CC)$(CC) $(CFLAGS) $(LDFLAGS) -o trinity $(OBJS)
+	$(QUIET_CC)$(CC) $(CFLAGS) $(LDFLAGS) -o trinity $(OBJS) $(LDLIBS)
 	@mkdir -p tmp
 
 df = $(DEPDIR)/$(*D)/$(*F)
-- 
2.6.4
