From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFD] Efficient unit test and fuzz tools for kernel/libc
 porting
Date: Wed, 20 Jul 2016 15:47:35 +0000
Message-ID: <alpine.DEB.2.20.1607201544220.12251@digraph.polyomino.org.uk>
References: <577CB5B7.7040204@huawei.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <577CB5B7.7040204@huawei.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, trinity@vger.kernel.org, syzkaller@googlegroups.com, aponomarenko@rosalab.ru, Jess Hertz <jesse.hertz@nccgroup.trust>, Tim Newsham <tim.newsham@nccgroup.trust>, arnd@arndb.dea, catalin.marinas@arm.com, broonie@kernel.org, maxim.kuvyrkov@linaro.org, ynorov@caviumnetworks.com, pinskia@gmail.com, schwab@suse.de, agraf@suse.de, marcus.shawcroft@arm.com, dingtianhong@huawei.com, guohanjun@huawei.com, cuibixuan@huawei.com, lijinyue@huawei.com, lizefan@huawei.com

On Wed, 6 Jul 2016, Zhangjian (Bamvor) wrote:

> correct or not. After learn and compare some fuzz tools, I feel that there is
> no such fuzz tools could help me. So, I wrote a new fuzz tools base on the
> trinity and it found several wrapper issues in glibc. I will first explain the
> different with existing fuzz tools and paste my propsosal in the end.

I'm not at all clear on whether any of the people working on AArch64 ILP32 
glibc have run the glibc testsuite and investigated the results in detail 
(the patch submissions have failed to include glibc testsuite results and 
have included bugs that would have been detected by the glibc testsuite).  
But, if you've found bugs in a new glibc port that were not detected by 
the existing testsuite, then tests for those bugs should be contributed to 
glibc (even if no existing port has those bugs, improving the test 
coverage is still a good idea).

-- 
Joseph S. Myers
joseph@codesourcery.com
