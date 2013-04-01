From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 3/9] Fix bitrot in include/syscalls-ia64.h
Date: Mon,  1 Apr 2013 21:58:33 +0300
Message-ID: <1364842720-24127-3-git-send-email-tt.rantala@gmail.com>
References: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=/TZS+VB9lpJzD436R5R95P/hGOwI/Nan+PtrxI8/8wI=;
        b=mb2Db8qzjjKnOlIU4kWReGc3GagZwdoKZOy8k5vDn0BX5jrGd3hC1lNpDWkv8ds+lJ
         06x0lXFwJiMJtp369FuqNM96ng0c7pxA4dhQHODAfhVYFhkqBj2+zXjIVVoKFYKm+oC2
         oSXk0VV8Dk7S7VUWKlBKJQXujClHggbCKKr2iC94XPU+RX0r+pv3tp2qL89RwgbQy6qq
         gDbQJ/E0iyavt2qCMH31v8Sw3ZFkAR0jSfqXC0yOQfxr85e0JVh5ABVMeV5Bj/xkZGM4
         Jcq8ZIwlQ8NTe6mcZzOJgXjSDXvgHzoid9nplcajRyXoIXnPcIRd0Mqp+HC5qY7WO19j
         Mr+Q==
In-Reply-To: <1364842720-24127-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com, trinity@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>

---
 include/syscalls-ia64.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/syscalls-ia64.h b/include/syscalls-ia64.h
index 740e50e..0ff0f75 100644
--- a/include/syscalls-ia64.h
+++ b/include/syscalls-ia64.h
@@ -1,13 +1,11 @@
+#ifndef _SYSCALLS_IA64_H
+#define _SYSCALLS_IA64_H 1
+
 /* Syscalls from arch/ia64/kernel/entry.S as of 2.6.31rc2 */
 
 #include "sanitise.h"
-
-#include <fcntl.h>
-#include <signal.h>
-#include <asm/mman.h>
-#include <asm/perfmon.h>
-#include <asm/types.h>
-#include <sys/socket.h>
+#include "syscall.h"
+#include "syscalls/syscalls.h"
 
 struct syscalltable syscalls_ia64[] = {
 	{ .entry = &syscall_ni_syscall },
@@ -309,3 +307,5 @@ struct syscalltable syscalls_ia64[] = {
 	{ .entry = &syscall_pwritev },
 	{ .entry = &syscall_rt_tgsigqueueinfo },
 };
+
+#endif	/* _SYSCALLS_IA64_H */
-- 
1.7.9.5
