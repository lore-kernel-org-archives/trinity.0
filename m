From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: "invalid open call: O_CREAT or O_TMPFILE without mode" errors
Date: Mon, 20 Jul 2015 10:52:57 -0400
Message-ID: <20150720145257.GB23521@codemonkey.org.uk>
References: <CAHTgTXVFGfR0an5DcQKKt7HGmUVWddogDquL-oNMHYA8zfpBAw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHTgTXVFGfR0an5DcQKKt7HGmUVWddogDquL-oNMHYA8zfpBAw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@twopensource.com>
Cc: trinity@vger.kernel.org

On Thu, Jul 16, 2015 at 04:38:21PM -0700, Vinson Lee wrote:
 > Hi.
 > 
 > trinity stops running very soon after launch with invalid open call errors.
 > 
 > [main] Generating file descriptors
 > [main] Added 104 filenames from /dev
 > [main] Added 70615 filenames from /proc
 > [main] Added 29037 filenames from /sys
 > *** invalid open call: O_CREAT or O_TMPFILE without mode ***:
 > ./trinity terminated

Ugh. Is that some shiny new glibc ?

Probably something like this ?

Totally untested, I don't have a lot of time right now.

	Dave


diff --git a/syscalls/open.c b/syscalls/open.c
index 143e838fb7f5..9f65370b7225 100644
--- a/syscalls/open.c
+++ b/syscalls/open.c
@@ -31,11 +31,39 @@ unsigned long get_o_flags(void)
 	return mask;
 }
 
+static void sanitise_open(struct syscallrecord *rec)
+{
+	unsigned long flags;
+
+	flags = get_o_flags();
+
+	rec->a2 |= flags;
+
+	if (rec->a2 & O_CREAT)
+		rec->a3 = 0666;
+
+	if (rec->a2 & O_TMPFILE)
+		rec->a3 = 0666;
+}
+
+static void sanitise_openat(struct syscallrecord *rec)
+{
+	unsigned long flags;
+
+	flags = get_o_flags();
+
+	rec->a3 |= flags;
+
+	if (rec->a3 & O_CREAT)
+		rec->a4 = 0666;
+
+	if (rec->a3 & O_TMPFILE)
+		rec->a4 = 0666;
+}
+
 /*
  * SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, int, mode)
  */
-static void sanitise_open(struct syscallrecord *rec);
-
 struct syscallentry syscall_open = {
 	.name = "open",
 	.num_args = 3,
@@ -52,20 +80,9 @@ struct syscallentry syscall_open = {
 	.sanitise = sanitise_open,
 };
 
-static void sanitise_open(struct syscallrecord *rec)
-{
-	unsigned long flags;
-
-	flags = get_o_flags();
-
-	rec->a2 |= flags;
-}
-
 /*
  * SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags, int, mode)
  */
-static void sanitise_openat(struct syscallrecord *rec);
-
 struct syscallentry syscall_openat = {
 	.name = "openat",
 	.num_args = 4,
@@ -85,15 +102,6 @@ struct syscallentry syscall_openat = {
 	.sanitise = sanitise_openat,
 };
 
-static void sanitise_openat(struct syscallrecord *rec)
-{
-	unsigned long flags;
-
-	flags = get_o_flags();
-
-	rec->a3 |= flags;
-}
-
 /*
  * SYSCALL_DEFINE3(open_by_handle_at, int, mountdirfd,
  *               struct file_handle __user *, handle,
