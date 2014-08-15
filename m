From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: [child0:1694] <timed out>
Date: Fri, 15 Aug 2014 20:02:01 +0200
Message-ID: <53EE4B19.4000305@gmx.de>
References: <53ECEF3C.3080604@gmx.de> <20140814222722.GA19056@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140814222722.GA19056@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 08/15/2014 12:27 AM, Dave Jones wrote:
> On Thu, Aug 14, 2014 at 07:17:48PM +0200, Toralf F=C3=B6rster wrote:
>  > With latest git tree I do get now a lot of lines like :
>  >=20
>  > [child0:1694] <timed out>
>  > [child0:1694] <timed out>
>  > [child0:1694] <timed out>
>  > [child1:1695] <timed out>
>  > [child0:1694] <timed out>
>  > [child0:1694] <timed out>
>  > [child1:1695] <timed out>
>  >=20
>  > for a command like this: MALLOC_CHECK_=3D2 trinity -C 2 -N 100000 =
-x mremap -q -V /tmp/victims/v1/v2
>  >=20
>  > It is intended ?
>=20
> It's not a new thing (at least from Trinity's perspective).
> If a syscall takes more than a second to complete, we send it a kill
> signal.  Some syscalls might be blocking on an fd though, and will
> ignore those signals.  You might try checking out /proc/1694/stack
> and seeing where it's stuck.  Much of the time it'll be doing sometih=
ng
> like a read() on a network socket.  You could then exclude those
> by specifiying just a specific network protocol with -P, or if you're
> running current git, you can exclude sockets entirely with
> --disable-fds=3Dsockets
>=20
> 	Dave
>=20
>=20
/me wonders if dfdb9560d brought this message to my eyes ?

Well for the stack trace feature I've to wait till it is implemented - =
Richard Weinberger told me that there#S a guy just doing it.

But thx for the "--disable-fds=3Dsockets" hint - will play with it.
--=20
Toralf
