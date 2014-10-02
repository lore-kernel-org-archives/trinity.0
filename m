From: Dave Jones <davej@redhat.com>
Subject: Re: BUG!: unreachable!
Date: Thu, 2 Oct 2014 11:48:25 -0400
Message-ID: <20141002154825.GA19347@redhat.com>
References: <542C3D04.4030503@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <542C3D04.4030503@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Wed, Oct 01, 2014 at 07:42:28PM +0200, Toralf F=F6rster wrote:
 > JJust FWIW with current git tree of trinity I run into this :
 >=20
 > [child2:30294] <timed out>
 > [child2:30294] <timed out>
 > BUG!: unreachable!
 >=20
 > BUG!: 9
 > BUG!: [30306] generate-args.c:fill_arg:367
 > [child3:30301] <timed out>
 > [child3:30301] <timed out>
 > [child3:30316] <timed out>
 > BUG!: unreachable!
 >=20
 > BUG!: 9
 > BUG!: [30316] generate-args.c:fill_arg:367
 > [child0:30306] trinity(show_backtrace+0x32) [0x80551f2]
 >=20
 > but I must admit this around the same time where the oom killer kill=
ed few tasks within the 32 bit KVM machine whre trintiy was fuzzying th=
e kernel.

This is really bad, something has scribbled over trinity's syscall
definitions, and the type of the argument is garbage.

Not enough info to really say what the cause of that was,
whether it was a trinity bug, or uml bug.

Hm, I wonder if it's worth mprotect(PROT_READ)'ing trinity's
core structures that become read-only after setup.

	Dave
