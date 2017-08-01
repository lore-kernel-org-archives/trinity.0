From: Dai Xiang <xiangx.dai@intel.com>
Subject: test processes are not all killed
Date: Tue, 1 Aug 2017 17:38:13 +0800
Message-ID: <20170801093813.nw3zj4nqb2jqpdtx@linux>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hi!
I use below cmds(with root permission) include trinity to test and find an interesting issue:

cmd="trinity -q -q -l off -s $seed -x get_robust_list -x remap_file_pages -N 999999999"
cd /tmp
chroot --userspec nobody:nogroup / $cmd 2>&1 &
pid=$!
sleep 300s
kill -9 $pid

Then after run finish, i use pgrep and find test process do not kill
while i think the test logic is right:

5292 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
5293 trinity-watchdo
5294 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999
70558 trinity -q -q -l off -s 3648957937 -x get_robust_list -x remap_file_pages -N 999999999

I do some simple tests and all processes can be killed.

Does trinity suppress kill or it run at background can not use this
way to kill?

Thanks
Xiang
