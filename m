From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Unable to opendir /sys/bus/event_source/devices : No such file
 or directory
Date: Fri, 21 Jun 2013 16:39:54 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306211636040.24830@vincent-weaver-1.um.maine.edu>
References: <51C4B36D.70001@gmx.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1949573013-1371847200=:24830"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51C4B36D.70001@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1949573013-1371847200=:24830
Content-Type: TEXT/PLAIN; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 21 Jun 2013, Toralf Förster wrote:

> Wasn't aware of this message before - and got it now when running
> trinity within a 32 bit user-mode-linux.
> 
> Is that directory helpful for trinity ?

It is used when coming up with possible events for the perf_event_open() 
syscall.

It's not fatal if the directory doesn't exist.  

I should probably remove the error message (or make it only show up at 
high verbosity levels?).

A patch that removes the message is included below.

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index cf10134..ef8cb4f 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -223,9 +223,6 @@ static int init_pmus(void) {
 
 	dir=opendir("/sys/bus/event_source/devices");
 	if (dir==NULL) {
-		fprintf(stderr,"Unable to opendir "
-			"/sys/bus/event_source/devices : %s\n",
-			strerror(errno));
 		return -1;
 	}
 
--8323329-1949573013-1371847200=:24830--
