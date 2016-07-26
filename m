From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH v2] Fix build on older kernels without BPF.
Date: Mon, 25 Jul 2016 20:59:29 -0400
Message-ID: <20160726005929.GA17542@codemonkey.org.uk>
References: <20160712190217.GA5525@codemonkey.org.uk>
 <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
 <20160721201048.GA9384@codemonkey.org.uk>
 <CACKvgLE23r+RGDWhp3D0z9_gnbWCXJS45=mZGV+o6L3pZ=Ypkw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACKvgLE23r+RGDWhp3D0z9_gnbWCXJS45=mZGV+o6L3pZ=Ypkw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Mon, Jul 25, 2016 at 05:24:43PM -0700, Vinson Lee wrote:

 > > for each of these, otherwise the next syscall will be in the wrong slot.
 > 
 > I tried making that change but trinity would crash in
 > copy_syscall_table with memcpy with a NULL from[n].entry.
 > 
 > Program received signal SIGSEGV, Segmentation fault.
 > 0x000000000041300e in copy_syscall_table (from=0x63d840, nr=329) at
 > /usr/include/bits/string3.h:52
 > 52  return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
 > (gdb) bt
 > #0  0x000000000041300e in copy_syscall_table (from=0x63d840, nr=329)
 > at /usr/include/bits/string3.h:52
 > #1  0x00000000004130f3 in select_syscall_tables () at tables.c:491
 > #2  0x0000000000413e95 in main (argc=1, argv=0x7fffffffe438) at trinity.c:115
 > 
 > tables.c
 >    470  static struct syscalltable * copy_syscall_table(struct
 > syscalltable *from, unsigned int nr)
 >    471  {
 >    472          unsigned int n;
 >    473          struct syscallentry *copy;
 >    474
 >    475          copy = alloc_shared(nr * sizeof(struct syscallentry));
 >    476          if (copy == NULL)
 >    477                  exit(EXIT_FAILURE);
 >    478
 >    479          for (n = 0; n < nr; n++) {
 >    480                  memcpy(copy + n , from[n].entry, sizeof(struct
 > syscallentry));
 >    481                  copy[n].number = n;
 >    482                  copy[n].active_number = 0;
 >    483                  from[n].entry = &copy[n];
 >    484          }
 >    485          return from;
 >    486  }


stick a 
		if (from[n] == NULL)
			continue

before the memcpy. Does that dtrt ?

We might segv somewhere else after patching this up. It's been so long since
I touched this stuff I don't fully recall how it works.  I'll poke at it
some tomorrow.

	Dave
