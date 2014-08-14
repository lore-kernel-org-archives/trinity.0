From: Dave Jones <davej@redhat.com>
Subject: Re: [child0:1694] <timed out>
Date: Thu, 14 Aug 2014 18:27:22 -0400
Message-ID: <20140814222722.GA19056@redhat.com>
References: <53ECEF3C.3080604@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53ECEF3C.3080604@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Aug 14, 2014 at 07:17:48PM +0200, Toralf F=F6rster wrote:
 > With latest git tree I do get now a lot of lines like :
 >=20
 > [child0:1694] <timed out>
 > [child0:1694] <timed out>
 > [child0:1694] <timed out>
 > [child1:1695] <timed out>
 > [child0:1694] <timed out>
 > [child0:1694] <timed out>
 > [child1:1695] <timed out>
 >=20
 > for a command like this: MALLOC_CHECK_=3D2 trinity -C 2 -N 100000 -x=
 mremap -q -V /tmp/victims/v1/v2
 >=20
 > It is intended ?

It's not a new thing (at least from Trinity's perspective).
If a syscall takes more than a second to complete, we send it a kill
signal.  Some syscalls might be blocking on an fd though, and will
ignore those signals.  You might try checking out /proc/1694/stack
and seeing where it's stuck.  Much of the time it'll be doing sometihng
like a read() on a network socket.  You could then exclude those
by specifiying just a specific network protocol with -P, or if you're
running current git, you can exclude sockets entirely with
--disable-fds=3Dsockets

	Dave
