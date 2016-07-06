From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [RFD] Efficient unit test and fuzz tools for kernel/libc porting
Date: Wed, 6 Jul 2016 11:09:13 +0200
Message-ID: <CACT4Y+a_5G-G1v4Xn-_dLacuVSNnxGorZMjGKKew6pihg_Hk-Q@mail.gmail.com>
References: <577CB5B7.7040204@huawei.com> <CACT4Y+ZvqA-6CQHjjx05bCPqcOXp7O2Gf8+2PeC7U5eXTL+Yrw@mail.gmail.com>
 <577CC058.9030103@huawei.com>
Mime-Version: 1.0
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=+Q/wJXQCfIee8mocwTrUmagn5JSCJvyyItk2p3YvAGA=;
        b=pgQ+oFHJ4AbE87j0nk6kGH/iZWGqQhg0nO3v8MU2o5Y1YWY5BHCeqyBr4atOoDsuLq
         71rC9JgoTqMMrjOhdZcHWBTCC4L9iEKflzcamUcZD/qkPzKpxxFXVspRzY1yQEQNenFA
         pQBr5/SrwlvbUDuxLophtSBgLBrRmtQeyvFTp33EkYvZRLmFcTpNkWxOGo2G3+eduynr
         cENBVcbEywasiqatjxaG3FmfoQOkKwego/8iP+rRxxMw8sYWU318vkBii+DKxeBqLi6m
         /EPWi/HK/tc4PJ0SUZTt3Mp/JzHAVeYJYKBZNUhDMke8+YYQt1PPNBePzmOfUying0Te
         l2Ng==
In-Reply-To: <577CC058.9030103@huawei.com>
Sender: linux-arch-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>
Cc: syzkaller <syzkaller@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, trinity@vger.kernel.org, aponomarenko@rosalab.ru, Jess Hertz <jesse.hertz@nccgroup.trust>, Tim Newsham <tim.newsham@nccgroup.trust>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, joseph@codesourcery.com, maxim.kuvyrkov@linaro.org, Yury Norov <ynorov@caviumnetworks.com>, pinskia@gmail.com, schwab@suse.de, agraf@suse.de, marcus.shawcroft@arm.com, Ding Tianhong <dingtianhong@huawei.com>, guohanjun@huawei.com, cuibixuan@huawei.com, lijinyue@huawei.com, Zefan Li <lizefan@huawei.com>

On Wed, Jul 6, 2016 at 10:24 AM, Zhangjian (Bamvor)
<bamvor.zhangjian@huawei.com> wrote:
> Hi, Dmitry
>
>
>> Hi Bamvor,
>>
>> Nice work!
>>
>> Coverage should be easy to do with CONFIG_KCOV, but do you need
>> fuzzing/coverage? It seems that testing a predefined set of special
>> values for each arg should be enough for your use case. Namely special
>> values that can detect endianess/truncation/sign extension/etc issues.
>
> Yes. We are trying to cover endianess/truncation/sign extension at this
> moment.
> For coverage, there are some code path in syscall wrapper in both glibc
> and kernel. E.g. overflow check in glibc. I am thinking if coverage
> could help on this.

Ah, you mean user-space coverage. You may try AFL in binary
instrumentation mode for this.


>> I think there is also a number of glibc functions that don't directly
>> map to syscalls. Most notably wrappers around various ioctl's (e.g.
>> ptsname). Do you test them?
>
> No. Currently, our tools only focus on the syscall function in glibc. In
> these syscall level, we could compare the parameter and return value
> directly. As you said, there are only several type of issues. It is easy
> to handle by tools.
>
> I do not know how to test these complex cases. E.g. the ptsname may call
> ioctl, *stat* syscall. Compare the original parameter is meaningless. But
> it seems a good type of testcase to show how the user use the syscalls.
> Do you have some ideas?

I don't have any ideas for automated testing. One could write a model,
of course....
