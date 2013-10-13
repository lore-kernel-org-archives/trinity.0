From: Dave Jones <davej@redhat.com>
Subject: Re: [RFC] specify multiple victims directories
Date: Sat, 12 Oct 2013 20:06:37 -0400
Message-ID: <20131013000637.GA24562@redhat.com>
References: <52599266.9080907@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52599266.9080907@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Sat, Oct 12, 2013 at 08:18:14PM +0200, Toralf F=F6rster wrote:
 > Currently I can specify 1 directory which is usually a NFS share.
 > But that means that I'm just able to test 1 NFS version at a time.
 > Specifying multiple NFS directories would allow to mix NFS v[234[.[1=
2]]]
 > calls together.
 >=20
 > Symlinking into 1 directory and giving thats name to trinity is not =
a
 > solution b/c those symlinks would be mangeld by trinity itself soon.

I've had "support multiple -V" args on the todo for a while, but haven'=
t
found the time to get to it.  It's probably not a huge amount of code
to add though.

	Dave
=20
