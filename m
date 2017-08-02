From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: test processes are not all killed
Date: Wed, 2 Aug 2017 08:37:35 -0400
Message-ID: <20170802123735.dmkice7c5slkpeqp@codemonkey.org.uk>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux>
 <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
 <20170802030921.mwhtygus3oambllj@linux>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170802030921.mwhtygus3oambllj@linux>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dai Xiang <xiangx.dai@intel.com>
Cc: trinity@vger.kernel.org

On Wed, Aug 02, 2017 at 11:09:21AM +0800, Dai Xiang wrote:
 
 > root@local ~# cat /proc/30504/stack
 > [<ffffffff8122b5ac>] wb_wait_for_completion+0x5c/0x90
 > [<ffffffff8122ed26>] sync_inodes_sb+0x96/0x200
 > [<ffffffff81235135>] sync_inodes_one_sb+0x15/0x20
 > [<ffffffff81204913>] iterate_supers+0xc3/0x120
 > [<ffffffff81235455>] sys_sync+0x35/0x90
 > [<ffffffff818fd39e>] tracesys_phase2+0x84/0x89
 > [<ffffffffffffffff>] 0xffffffffffffffff

Ah. You might just have a *lot* of dirty pages to write out.
Does iotop show that journald is writing ?
If IO is progressing, it's not a bug. If it's completely idle, and we're
still stuck here, that's a kernel bug.

Unless you're particularly focussed on stressing filesystems, you might
want to skip the sync related syscalls (fsync,fdatasync,sync,syncfs)

	Dave
