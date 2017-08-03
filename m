From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: test processes are not all killed
Date: Thu, 3 Aug 2017 11:17:12 +0800
Message-ID: <20170803031712.pgjuefn2bbs4wyx5@hqi2-mobl3.ccr.corp.intel.com>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux>
 <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
 <20170802030921.mwhtygus3oambllj@linux>
 <20170802123735.dmkice7c5slkpeqp@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170802123735.dmkice7c5slkpeqp@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

On Wed, Aug 02, 2017 at 08:37:35AM -0400, Dave Jones wrote:
> On Wed, Aug 02, 2017 at 11:09:21AM +0800, Dai Xiang wrote:
>  
>  > root@local ~# cat /proc/30504/stack
>  > [<ffffffff8122b5ac>] wb_wait_for_completion+0x5c/0x90
>  > [<ffffffff8122ed26>] sync_inodes_sb+0x96/0x200
>  > [<ffffffff81235135>] sync_inodes_one_sb+0x15/0x20
>  > [<ffffffff81204913>] iterate_supers+0xc3/0x120
>  > [<ffffffff81235455>] sys_sync+0x35/0x90
>  > [<ffffffff818fd39e>] tracesys_phase2+0x84/0x89
>  > [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Ah. You might just have a *lot* of dirty pages to write out.
> Does iotop show that journald is writing ?

I do test again and only echo pid without kill pid but killall -9
trinity:
nobody   29553  0.0  0.4  55288 33212 pts/0    SL   09:42   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30107  0.0  0.3  56360 28308 ?        Ds   09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30109  0.0  0.4  55608 34932 ?        DNLs 09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30110  0.0  0.3  55424 30156 ?        Ds   09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30111  0.0  0.4  55464 32788 ?        DNs  09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30114  0.0  0.4  56584 32792 ?        Ds   09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30161  0.0  0.2  55464 23704 ?        Ds   09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30165  0.0  0.3  58564 30568 ?        DNs  09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999
nobody   30186  0.0  0.1  55436 14984 ?        Ds   09:51   0:00 trinity -q -q -l off -s -x get_robust_list -x remap_file_pages -N 999999999

The 29553 is printed but killall failed:
$ killall -9 trinity
trinity: no process found


use pstree:
  |-trinity-main -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c0 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c1 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c2 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c3 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c4 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c5 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   |-trinity-c6 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
  |   `-trinity-c7 -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999

use iotop -o:
111 be/4 root        0.00 B/s    0.00 B/s  0.00 % 99.99 %
[kworker/0:2] <== sometime kworker/1:1 or so on
sometimes more processes called kworker run, do not find trinity.

Thanks

Xiang
> If IO is progressing, it's not a bug. If it's completely idle, and we're
> still stuck here, that's a kernel bug.
> 
> Unless you're particularly focussed on stressing filesystems, you might
> want to skip the sync related syscalls (fsync,fdatasync,sync,syncfs)

How can i skip those syscalls?

> 
> 	Dave
> 
