From: Dave Jones <davej@redhat.com>
Subject: Re: *** Error in `trinity': double free or corruption (!prev):
 0x08208e78 ***
Date: Fri, 13 Jun 2014 13:30:04 -0400
Message-ID: <20140613173004.GA21623@redhat.com>
References: <539A15DE.7020101@gmx.de>
 <20140612220605.GA5771@redhat.com>
 <539B24FA.8070800@gmx.de>
 <20140613163812.GA17879@redhat.com>
 <539B3168.6050300@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <539B3168.6050300@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Jun 13, 2014 at 07:14:16PM +0200, Toralf F=F6rster wrote:
=20
 > $ trinity --list | grep Enabled$ | grep -v AVOID | cut -f3 -d' ' | w=
hile read s; do echo; echo $s; trinity -q -q -q -c $s -N 20 -C 1; done =
  =20
 >=20
 > with latest trinity git tee and latest kernel tree which exposed the=
 syscall "modify_ldt":
 >=20
 >=20
 > modify_ldt
 > Trinity 1.5pre  Dave Jones <davej@redhat.com>
 > [init] Marking syscall modify_ldt (123) as to be enabled.
 > Done parsing arguments.
 > *** Error in `trinity': double free or corruption (top): 0x0815d870 =
***
 > =3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
 > /lib/libc.so.6(+0x7a202)[0x400a3202]
 > /lib/libc.so.6(+0x7af80)[0x400a3f80]
 > trinity(mkcall+0x17a)[0x805b0ca]
 > trinity(child_process+0x95)[0x8054965]
 > trinity(main_loop+0x1e3)[0x80583f3]
 > trinity(main+0x252)[0x8053752]
 > /lib/libc.so.6(__libc_start_main+0xf5)[0x40045cc5]
 > trinity[0x8053cd5]

=46ixed.

thanks,

	Dave
