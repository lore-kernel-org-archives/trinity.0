From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Thu, 13 Jun 2013 15:58:37 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu> <CA+ydwtr7eTOjtzWumr998TcxqhmX_M30aW99S=DF6mOwNURL=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CA+ydwtr7eTOjtzWumr998TcxqhmX_M30aW99S=DF6mOwNURL=w@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, trinity@vger.kernel.org

On Thu, 13 Jun 2013, Tommi Rantala wrote:

> Unable to opendir /sys/bus/event_source/devices : Resource temporarily
> unavailable
> [221186.493638] traps: trinity-child30[375] trap divide error
> ip:40dbae sp:7fff3c1d7ae0 error:0 in trinity[400000+28000]

The below patch should fix this problem.

Though in the case where /sys/bus/event_source/devices isn't available
trinity will try opening it again each time it tries to do a 
PERF_TYPE_READ_FROM_SYSFS type (1 time in 7).  Not sure if it's
worth rate-limiting that.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>


diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 32c11cf..11f49e8 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -406,6 +406,14 @@ static long long random_sysfs_config(__u32 *type, __u64 *config1) {
 	int i,j;
 	long long c=0,c1=0;
 
+	if (num_pmus==0) {
+		/* For some reason we didn't get initialized */
+		/* Fake it so we don't divide by zero        */
+		*type=rand32();
+		*config1=rand64();
+		return rand64();
+	}
+
 	i=rand()%num_pmus;
 
 	*type=pmus[i].type;
