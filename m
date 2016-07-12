From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Fix build on older kernels without BPF.
Date: Tue, 12 Jul 2016 15:02:17 -0400
Message-ID: <20160712190217.GA5525@codemonkey.org.uk>
References: <1468348986-13200-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468348986-13200-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Tue, Jul 12, 2016 at 06:43:06PM +0000, Vinson Lee wrote:

 > diff --git a/syscalls/bpf.c b/syscalls/bpf.c
 > index b2f57d3..4788082 100644
 > --- a/syscalls/bpf.c
 > +++ b/syscalls/bpf.c
 > @@ -1,13 +1,16 @@
 >  /*
 >   * SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 >   */
 > +#ifdef USE_BPF
 >  #include <linux/bpf.h>
 > +#endif
 >  #include <linux/filter.h>
 >  #include "arch.h"
 >  #include "net.h"
 >  #include "random.h"
 >  #include "sanitise.h"
 >  
 > +#ifdef USE_BPF
 >  static unsigned long bpf_prog_types[] = {
 >  	BPF_PROG_TYPE_UNSPEC,
 >  	BPF_PROG_TYPE_SOCKET_FILTER,
 > @@ -15,9 +18,11 @@ static unsigned long bpf_prog_types[] = {
 >  	BPF_PROG_TYPE_SCHED_CLS,
 >  	BPF_PROG_TYPE_SCHED_ACT,
 >  };
 > +#endif
 >  
 >  static const char license[] = "GPLv2";
 >  
 > +#ifdef USE_BPF
 >  static void bpf_prog_load(struct syscallrecord *rec)
 >  {
 >  	unsigned long *insns = NULL, len = 0;
 > @@ -49,18 +54,22 @@ static void bpf_prog_load(struct syscallrecord *rec)
 >  	rec->a2 = (unsigned long) attr;
 >  	rec->a3 = sizeof(attr);
 >  }
 > +#endif
 >  
 >  static void sanitise_bpf(struct syscallrecord *rec)
 >  {
 >  	switch (rec->a1) {
 > +#ifdef USE_BPF
 >  	case BPF_PROG_LOAD:
 >  		bpf_prog_load(rec);
 >  		break;
 > +#endif
 >  	default:
 >  		break;
 >  	}
 >  }
 >  
 > +#ifdef USE_BPF
 >  static void post_bpf(struct syscallrecord *rec)
 >  {
 >  	union bpf_attr *attr;
 > @@ -84,10 +93,15 @@ static void post_bpf(struct syscallrecord *rec)
 >  		break;
 >  	}
 >  }
 > +#else
 > +static void post_bpf(__unused__ struct syscallrecord *rec) { }
 > +#endif
 >  
 >  static unsigned long bpf_flags[] = {
 > +#ifdef USE_BPF
 >  	BPF_MAP_CREATE, BPF_MAP_LOOKUP_ELEM, BPF_MAP_UPDATE_ELEM, BPF_MAP_DELETE_ELEM,
 >  	BPF_MAP_GET_NEXT_KEY, BPF_PROG_LOAD,
 > +#endif
 >  };

This might be cleaner to wrap the whole of syscalls/bpf.c in one ifdef, and then
add additional ones to include/syscalls-*.h to look like

#ifdef USE_BPF
	{ .entry = &syscall_bpf },
#else
	{ .entry = NULL },
#endif

I can't remember if the tables code handles a NULL .entry in the middle though.
Might need some tweaking.

	Dave
