From: Dave Jones <davej@redhat.com>
Subject: Re: Error in `trinity': free(): invalid next size (normal):
 0x08683438 ***
Date: Mon, 22 Sep 2014 09:41:08 -0400
Message-ID: <20140922134108.GB32379@redhat.com>
References: <541CA0B8.4060809@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <541CA0B8.4060809@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Sep 19, 2014 at 11:31:36PM +0200, Toralf F=F6rster wrote:
 > After a rather longer time w/o any issue I saw today this at a 32 bi=
t Gentoox86 Linux KVM guest w/ v1.4-611-g01c61fc :
 >=20
 > ...
 > [child1:18922] <timed out>
 > [child1:18933] <timed out>
 > *** Error in `trinity': free(): invalid next size (normal): 0x086834=
38 ***
 > =3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
 > /lib/libc.so.6(+0x734ef)[0xb76064ef]
 > /lib/libc.so.6(+0x79992)[0xb760c992]
 > /lib/libc.so.6(+0x7aac1)[0xb760dac1]
 > trinity(output_syscall_prefix+0x1b5)[0x8054465]
 > trinity(child_random_syscalls+0x1ce)[0x805f52e]
 > trinity(child_process+0x7e)[0x8054f8e]
 > trinity(main_loop+0x1f9)[0x8059469]
 > trinity(main+0x254)[0x8053b94]
 > /lib/libc.so.6(__libc_start_main+0xf5)[0xb75afee5]
 > trinity[0x8054135]

No idea what happened here tbh.  My best guess is one of the prior
syscalls stomped on something.  I've got some work in progress to
fix some of this stuff up, which I'll land over the next couple weeks.

	Dave
