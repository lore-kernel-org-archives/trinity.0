From: Dave Jones <davej@redhat.com>
Subject: Re: trinity seems not to reap all childs
Date: Wed, 13 Aug 2014 11:02:31 -0400
Message-ID: <20140813150231.GA11344@redhat.com>
References: <53E64DE1.1020905@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53E64DE1.1020905@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Sat, Aug 09, 2014 at 06:35:45PM +0200, Toralf F=F6rster wrote:
 > I do observe in the last few days that under a 32 bit Gentoo UML gue=
st sometimes 1 trinity job survives although all of its parents are gon=
e already.
 >=20
 >=20
 > The console output at th ehost system is :
 >=20
 > [main] Bailing main loop because Completed maximum number of operati=
ons..
 > [watchdog] [2604] Watchdog exiting because Completed maximum number =
of operations..
 > [init] Ran 100001 syscalls. Successes: 21199  Failures: 78802
 >=20
 >=20
 > A ps shows that there's still 1 job running in the guest :
 >=20
 > $ ssh tfoerste@trinity "ps fx -eo pid,start_time,command | grep -e t=
rinity -e sleep | grep -v grep"
 >  2723 17:55 trinity -C 2 -N 100000 -x mremap -q -V /mnt/ramdisk/vict=
ims/v1/v2

If it happens again, grab the output of /proc/2723/stack
(You might need something that enables CONFIG_STACKTRACE in your kernel=
,
 or apply the patch below if nothing does -- I still need to get that
 upstream)


 > [watchdog] 30087 iterations. [F:23623 S:6463 HI:9706]
 > [watchdog] 40138 iterations. [F:31443 S:8694 HI:9706]
 > [watchdog] 50215 iterations. [F:39370 S:10844 HI:9706]
 > [watchdog] 60221 iterations. [F:47228 S:12992 HI:9706]
 > [watchdog] 70225 iterations. [F:55100 S:15124 HI:9706]
 > [watchdog] 80278 iterations. [F:63007 S:17270 HI:9706]
 > [watchdog] 90287 iterations. [F:71013 S:19273 HI:9706]
 > [main] Bailing main loop because Completed maximum number of operati=
ons..
 > [watchdog] [2604] Watchdog exiting because Completed maximum number =
of operations..
 > [init] Ran 100001 syscalls. Successes: 21199  Failures: 78802
 >=20
 > killing the job helped fortunately:
 >=20
 >=20
 > $ ssh tfoerste@trinity kill 2723

Puzzling that the watchdog exited while there were still children aroun=
d.

Something else that might be interesting would be to attach to the
still running pid, and examine shm->running_childs

	Dave

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cb45f59685e6..38133ddb8bb4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1008,8 +1008,13 @@ config TRACE_IRQFLAGS
 	  either tracing or lock debugging.
=20
 config STACKTRACE
-	bool
+	bool "Stack backtrace support"
 	depends on STACKTRACE_SUPPORT
+	help
+	  This option causes the kernel to create a /proc/pid/stack for
+	  every process, showing its current stack trace.
+	  It is also used by various kernel debugging features that require
+	  stack trace generation.
=20
 config DEBUG_KOBJECT
 	bool "kobject debugging"
