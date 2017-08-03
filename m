From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: test processes are not all killed
Date: Wed, 2 Aug 2017 23:22:43 -0400
Message-ID: <20170803032243.v776bgfuwzjmirko@codemonkey.org.uk>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux>
 <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
 <20170802030921.mwhtygus3oambllj@linux>
 <20170802123735.dmkice7c5slkpeqp@codemonkey.org.uk>
 <20170803031712.pgjuefn2bbs4wyx5@hqi2-mobl3.ccr.corp.intel.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170803031712.pgjuefn2bbs4wyx5@hqi2-mobl3.ccr.corp.intel.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dai Xiang <xiangx.dai@intel.com>
Cc: trinity@vger.kernel.org

On Thu, Aug 03, 2017 at 11:17:12AM +0800, Dai Xiang wrote:
 
 > > Ah. You might just have a *lot* of dirty pages to write out.
 > > Does iotop show that journald is writing ?
 > 
 > use iotop -o:
 > 111 be/4 root        0.00 B/s    0.00 B/s  0.00 % 99.99 %
 > [kworker/0:2] <== sometime kworker/1:1 or so on
 > sometimes more processes called kworker run, do not find trinity.
 
You can try the ftrace stuff I suggested to trace what those kworker
threads are doing, but it really sounds like it's just accumulated a ton
of dirty pages to write out.

 > > Unless you're particularly focussed on stressing filesystems, you might
 > > want to skip the sync related syscalls (fsync,fdatasync,sync,syncfs)
 > 
 > How can i skip those syscalls?

use multiple -x arguments.
This is common enough, that it might be worth adding a --no-sync
argument that just does this for all relevant syscalls.

	Dave
