From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: HEAD of trinity broken on xc86
Date: Fri, 13 May 2016 15:46:05 -0400
Message-ID: <20160513194605.GA2114@codemonkey.org.uk>
References: <57362C39.2080703@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57362C39.2080703@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, May 13, 2016 at 09:34:17PM +0200, Toralf F=F6rster wrote:
 > Hi,
 >=20
 > something between f2ecc0e9a94871ebd8f27daf390516d03a22fa1d and HEAD =
gives at a x86 chroot (Gentoo Linux) :
 >=20
 > tfoerste@n22kvm-clone /mnt/ramdisk $ cd /mnt/ramdisk/; trinity -qqq =
-C4
 > Trinity 9  Dave Jones <davej@codemonkey.org.uk>
 > shm:0xb77a2000-0xc3d8ee84 (4 pages)
 > [main] Registered 13 fd providers.
 > Marking all syscalls as enabled.
 > [main] Enabled 380 syscalls. Disabled 0 syscalls.
 > [main] Using pid_max =3D 32768
 > Free memory: 2.86GB
 > Low on memory, disabling mmaping of 1GB pages
 > mmap failure

Odd. I just added a commit to print the errno. Can you try that ?

You could probably also git-bisect this pretty quickly.

	Dave
