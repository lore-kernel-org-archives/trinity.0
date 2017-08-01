From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: test processes are not all killed
Date: Tue, 1 Aug 2017 11:38:23 -0400
Message-ID: <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170801093813.nw3zj4nqb2jqpdtx@linux>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dai Xiang <xiangx.dai@intel.com>
Cc: trinity@vger.kernel.org

On Tue, Aug 01, 2017 at 05:38:13PM +0800, Dai Xiang wrote:
 > Hi!
 > I use below cmds(with root permission) include trinity to test and find an interesting issue:
 > 
 > cmd="trinity -q -q -l off -s $seed -x get_robust_list -x remap_file_pages -N 999999999"
 > cd /tmp
 > chroot --userspec nobody:nogroup / $cmd 2>&1 &
 > pid=$!
 > sleep 300s
 > kill -9 $pid
 > 
 > Then after run finish, i use pgrep and find test process do not kill
 > while i think the test logic is right:
 > 
 > 5292 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
 > 5293 trinity-watchdo
 > 5294 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
 > 70558 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
 > 
 > I do some simple tests and all processes can be killed.
 > 
 > Does trinity suppress kill or it run at background can not use this
 > way to kill?

It doesn't do anything special to mask signals (unless it happened to
call some of the signal syscalls with the right random arguments, which
is unlikely - the sanitize routines for the signal syscalls are pretty
dumb, or missing entirely)

More likely is you've found a kernel bug, or the processes are blocked
on something.

Looking at /proc/<pid>/stack can sometimes give clues as to where a
process is stuck.

Also a script like this is useful for tracing stuck pids

cd /sys/kernel/debug/tracing/
echo $1 >> set_ftrace_pid
echo function_graph >> current_tracer
echo 1 >> tracing_on
sleep 5
echo 0 >> tracing_on

cat /sys/kernel/debug/tracing/trace


Actually looking again, I see you have a trinity-watchdog process, which
current versions don't have, so maybe try updating to 1.7, (or better, the git
version) and seeing if it's reproducable there.  I don't even remember
what bugs got fixed that long ago.

	Dave
