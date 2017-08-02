From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: test processes are not all killed
Date: Wed, 2 Aug 2017 12:41:43 -0400
Message-ID: <20170802164143.qyl4wuevc7xdwhus@codemonkey.org.uk>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux>
 <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
 <20170802030921.mwhtygus3oambllj@linux>
 <CA+ydwtoYiyyyiBvmMOO9ELvipyTePA8E2hmeNsU=pbhymdKSrA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ydwtoYiyyyiBvmMOO9ELvipyTePA8E2hmeNsU=pbhymdKSrA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Dai Xiang <xiangx.dai@intel.com>, trinity@vger.kernel.org

On Wed, Aug 02, 2017 at 05:57:21PM +0300, Tommi Rantala wrote:
 > 2017-08-02 6:09 GMT+03:00 Dai Xiang <xiangx.dai@intel.com>:
 > > On Tue, Aug 01, 2017 at 11:38:23AM -0400, Dave Jones wrote:
 > >> On Tue, Aug 01, 2017 at 05:38:13PM +0800, Dai Xiang wrote:
 > >>  > Hi!
 > >>  > I use below cmds(with root permission) include trinity to test and find an interesting issue:
 > >>  >
 > >>  > cmd="trinity -q -q -l off -s $seed -x get_robust_list -x remap_file_pages -N 999999999"
 > >>  > cd /tmp
 > >>  > chroot --userspec nobody:nogroup / $cmd 2>&1 &
 > >>  > pid=$!
 > >>  > sleep 300s
 > >>  > kill -9 $pid
 > 
 > Hi,
 > 
 > "kill -9 $pid" only kills the main trinity pid, right?
 > So the watchdog and all the forked child processes will not get killed.
 > 
 > Maybe Dave knows better if the other trinity processes will kill
 > themselves if they get re-parented.

They should, but only after it exits that sync() syscall.
There's a check in periodic_work() that checks the main pid is still
around every 10 syscalls.

	Dave
