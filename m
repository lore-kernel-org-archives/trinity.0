From: Dave Jones <davej@redhat.com>
Subject: Re: Stuck in syscall 11:. Sending SIGKILL.
Date: Thu, 18 Apr 2013 11:28:29 -0400
Message-ID: <20130418152829.GB9175@redhat.com>
References: <516F0540.7080003@gmx.de>
 <20130417203926.GA17149@redhat.com>
 <51700E4E.5090506@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51700E4E.5090506@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Thu, Apr 18, 2013 at 05:16:30PM +0200, Toralf F=F6rster wrote:
 > On 04/17/2013 10:39 PM, Dave Jones wrote:
 > > Stuck in execve.=20
 >=20
 > It would be helpful if "trinity -L" could print the integer number t=
oo -
 > till now I either have to look into the log file or I do something l=
ike
 > "trinity -L | nl -ba ..."

Oversight. I had done this for the biarch case, but not uni-arch.

=46ixed and pushed out.

	Dave
