From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: *** Error in `trinity': free(): invalid pointer: 0xb755c014 ***
Date: Thu, 29 Jan 2015 15:41:07 -0500
Message-ID: <20150129204107.GA24526@codemonkey.org.uk>
References: <54CA8315.70408@gmx.de>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54CA8315.70408@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

 > *** Error in `trinity': free(): invalid pointer: 0xb755c00c ***
 > ======= Backtrace: =========
 > /lib/libc.so.6(+0x734ef)[0xb76824ef]
 > /lib/libc.so.6(+0x79992)[0xb7688992]
 > /lib/libc.so.6(+0x7aac1)[0xb7689ac1]
 > trinity(freeptr+0x14)[0x805cd04]
 > trinity(handle_syscall_ret+0x28)[0x805a728]
 > trinity(child_random_syscalls+0x225)[0x805d595]
 > trinity(child_process+0x85)[0x8053025]
 > trinity(main_loop+0x1be)[0x8057f4e]
 > trinity(main+0x269)[0x8051d29]
 > /lib/libc.so.6(__libc_start_main+0xf5)[0xb762bee5]
 > trinity[0x80522c5]
 >
 > 
 > Points this to a trinity or to a kernel regression ?

Should be fixed in current git.
Commit 8631cc19943ba1801394b256c0aedfb3e0a2c90b

thanks,

	Dave
