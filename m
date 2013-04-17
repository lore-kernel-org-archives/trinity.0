From: Dave Jones <davej@redhat.com>
Subject: Re: Stuck in syscall 11:. Sending SIGKILL.
Date: Wed, 17 Apr 2013 16:39:26 -0400
Message-ID: <20130417203926.GA17149@redhat.com>
References: <516F0540.7080003@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <516F0540.7080003@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Wed, Apr 17, 2013 at 10:25:36PM +0200, Toralf F=F6rster wrote:
 > trinity forgot the name of syscall 11 (while running within a UML in=
stance)
 >=20
 > ...
 > [watchdog] 21055 iterations. [F:16827 S:4223]
 > [watchdog] pid 2481 hasn't made progress in 30 seconds! (last:136622=
9784 now:1366229814 diff:30). Stuck in syscall 267:clock_nanosleep. Sen=
ding SIGKILL.
 > [watchdog] pid 2500 hasn't made progress in 30 seconds! (last:136622=
9804 now:1366229834 diff:30). Stuck in syscall 267:clock_nanosleep. Sen=
ding SIGKILL.
 > [watchdog] pid 2519 hasn't made progress in 30 seconds! (last:136622=
9816 now:1366229846 diff:30). Stuck in syscall 11:. Sending SIGKILL.
 > [watchdog] pid 2522 hasn't made progress in 30 seconds! (last:136622=
9818 now:1366229848 diff:30). Stuck in syscall 11:. Sending SIGKILL.

Stuck in execve. Don't know why it couldn't print out the name,
but I knew about the problem of children not coming back from execve.
I guess I should do that syscall in a child of the child.

	Dave
