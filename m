From: Dave Jones <davej@redhat.com>
Subject: Re: kernel: sock: sock_set_timeout: `trinity-main' (pid 1349) tries
 to set negative timeout
Date: Sat, 2 Nov 2013 17:28:53 -0400
Message-ID: <20131102212853.GA17724@redhat.com>
References: <527554F0.4070706@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <527554F0.4070706@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Sat, Nov 02, 2013 at 08:39:28PM +0100, Toralf F=F6rster wrote:
 > I'm observing such syslog messages in a user mode linux image and do=
 wonder why trinity-main
 > does such unusal things (and not the child which I'd expect of cours=
e) :
 >=20
 >=20
 > Nov  2 19:14:25 trinity kernel: sock: sock_set_timeout: `trinity-mai=
n' (pid 1349) tries to set negative timeout
 > Nov  2 19:14:25 trinity kernel: sock: sock_set_timeout: `trinity-mai=
n' (pid 1349) tries to set negative timeout

The main process periodically does setsockopt calls on all the open soc=
kets
that children inherit.

	Dave
