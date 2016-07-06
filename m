From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [RFD] Efficient unit test and fuzz tools for kernel/libc porting
Date: Wed, 6 Jul 2016 10:00:06 +0200
Message-ID: <CACT4Y+ZvqA-6CQHjjx05bCPqcOXp7O2Gf8+2PeC7U5eXTL+Yrw@mail.gmail.com>
References: <577CB5B7.7040204@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=cZvzUBpalYvw6QTogyh/VWyRhJq+qBOvPgz/+OZtc74=;
        b=MCVnaSV822udZwlXb3jH6P+n+b/JcIkOqpHnVW/7GQeMGQZTwmXtA8Fjt/+bw/Z9zO
         Qzfus1f4+AGhNVH3mxRgUtdHj1SC6Pe7pVpRi3XM5MQIfsurfFmSpUsTm28Utf9eVTEv
         8F6f+je83/UG+6BELEwKi8zFJgHXLuQQWS3qoySD1tcngTij1xqOIM4enMsoAcfZ8VCH
         ip+8HnTANmOztb9q6CwLPcFftYTVt0uMKAa/WEqkx1ukFWZYCw1VfsoWiWN4Y8KJLpXk
         c2Xn4mQeyqHLr2TDLY7E3WZfcWrKF/tBnu1CGnQGF9oUF0qvFGENXaT47aGU4jTzk381
         SLQg==
In-Reply-To: <577CB5B7.7040204@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzkaller <syzkaller@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, trinity@vger.kernel.org, aponomarenko@rosalab.ru, Jess Hertz <jesse.hertz@nccgroup.trust>, Tim Newsham <tim.newsham@nccgroup.trust>, arnd@arndb.dea, Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, joseph@codesourcery.com, maxim.kuvyrkov@linaro.org, Yury Norov <ynorov@caviumnetworks.com>, pinskia@gmail.com, schwab@suse.de, agraf@suse.de, marcus.shawcroft@arm.com, Ding Tianhong <dingtianhong@huawei.com>, guohanjun@huawei.com, cuibixuan@huawei.com, lijinyue@huawei.com, Zefan Li <lizefan@huawei.com>

On Wed, Jul 6, 2016 at 9:39 AM, Zhangjian (Bamvor)
<bamvor.zhangjian@huawei.com> wrote:
> HI,
>
> When I working on the ILP32 ABI for ARMv8 in last two years, I has
> encountered lots of syscall issues such as wrong number of arguments,
> different data type in binary interface. I realized that the correctness of
> argument passing between the C library and core kernel code is a common
> problem when bringing up new architecture or ABI to kernel and libc.
> Existing fuzz testing tools such as trinity[1], syzkaller[2] and triforce[3]
> only generate random or boundary values for syscall parameters and then
> inject them into kernel, but those tools won't validate if the results of
> those syscalls are correct or not. Thus they can not act as an unit test for
> ILP32. In this year, considering the abi of ILP32 is changes during
> discussion, I am thinking if I could use some sort of automatically tools to
> check whether the wrapper is correct or not. After learn and compare some
> fuzz tools, I feel that there is no such fuzz tools could help me. So, I
> wrote a new fuzz tools base on the trinity and it found several wrapper
> issues in glibc. I will first explain the different with existing fuzz tools
> and paste my propsosal in the end.
>
> Trinity is developed in a long time. It could randomize the parameter of
> syscall and run individual syscall standalone or parallel. When I do the
> long time parallel test(not for ILP32), it could report some bug, e.g. hang,
> panic. It is useful but it is indeed hard to debug because it usually fail
> after a long time running. I do not know what does it exactly do.
>
> Compare with Trinity, syzkaller is quite different. Here is the comparision
> between syzkaller and our tools:
> 1.  Syzkaller could recursively randomize base date type in syscall which
> means it is possible generate more meaningfull syscall test. But it only
> test the syscall through syscall() function. It assume that the c library is
> correct and stable. But it is wrong if we are porting new abi(such as ILP32)
> or architecture to glibc and kernel. We need to take c library into account.
> This is what my tools could do.
>
> 2.  Syzkaller could generate the readable short testcases. Our tools could
> only test individual syscall and check the correctness of parameter and
> return value. I think it is enough for the unit test which tests syscall one
> by one.
>
> 3.  Syzkaller could do the coverage. Our tools could not. I think it is
> useful for me. I plan to add the coverage later.
>
> In my ILP32 works, my tools reported several off_t endian issues in glibc.
> Our tools work like this:
>
> Dump the function                                 Dump the function
> prototype from                                    prototype from c
> vmlinux from the                                  library from the
> sys_call_table                                    given list(posix
> array in kernel.                                  interfaces or user
>        |                                          defined).
>        |                                                 |
>        |                                                 |
>       \|/                                               \|/
>        `                                                 `
> Generate jprobe        Modity Trinity to          Generate struct
> hook according to      support run syscall        fuzz generator
> prototype which        syscall from c             from the prototype.
> will recursively       libray instead             And add them of
> print the syscall      syscall() function         to trinity. Trinity
> value.                       |                    will recursively
>        \                     |                    print the function
>         \                    |                    parameter.
>          \                   |                           /
>           -----------------------------------------------
>                              |
>                             \|/
>                              `
>               Run the trinity each syscall once
>               and compare the function parameter
>               printed in kernel and userspace
>               If inconsistent, print specific
>               information, such endian issue,
>               32<->64bit conversion issue and
>               so on.
>
> Tools of function dump and hook generator based on the abi-dumper[4]. Other
> functions base on trinity. Return value test is similar except generating
> the kretprobe hook instead jprobe hook.
>
> There are some hacks and the original funtion of trinity may be broken. The
> main changes in trinity are as follows:
> 1.  Call syscall through c library via call_glibc_syscalls() instead of
> direct syscall via syscall().
> 2.  Add new file generate-struct.c including the missing data type mentioned
> in syscall. This file is generated by ./struct_extract.py with a little
> modification. It should be fully auto generated in future.
> 3.  Add more date types in fill_arg()(generate-args.c) and
> include/syscall.h.
> 4.  Modify the syscallentry struct in syscalls directory according to the
> newly added data types.
> 5.  Add or Change some output message for script.
> 6.  Add jprobe hooks in modules directory. Such hook will be inserted before
> trinity test and removed after test.
>
> Step to generate generate-struct.c and jprobe hooks:
> 1.  Compile the kernel/libc/binary which include the functions you want to
> generate.
> 2.  Dump function and struct information through modified abi-dumper.pl,
> named them as symbolinfo and typeinfo. You may need add "--all" and/or
> "--dump-static" depends on your binaries.
> 3.  Generate the file through trinity/scripts/struct_extract.py.
>
> We also submit a proposal to linuxcon europe last month. Hope we could get a
> chance to share our works face to face.
>
> The patches could be found at [5] and [6]. It works but ugly. We hope we
> could get some early response, such as if community is interested in this
> tools, whether this tools could merge into existence fuzz tools.


Hi Bamvor,

Nice work!

Coverage should be easy to do with CONFIG_KCOV, but do you need
fuzzing/coverage? It seems that testing a predefined set of special
values for each arg should be enough for your use case. Namely special
values that can detect endianess/truncation/sign extension/etc issues.

I think there is also a number of glibc functions that don't directly
map to syscalls. Most notably wrappers around various ioctl's (e.g.
ptsname). Do you test them?
