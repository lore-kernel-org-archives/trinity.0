From: Dave Jones <davej@redhat.com>
Subject: Re: is -1 really too "large" ?
Date: Mon, 21 Oct 2013 15:52:10 -0400
Message-ID: <20131021195210.GA28909@redhat.com>
References: <52657514.3020707@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52657514.3020707@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Mon, Oct 21, 2013 at 08:40:20PM +0200, Toralf F=F6rster wrote:
 > got today :
 >=20
 >  run trinity at Mon Oct 21 20:38:27 CEST 2013 28#-1 M=3D/mnt/nfsv4
 >=20
 > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs00000000000049240000=
00cb': Device or resource busy
 > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000003fdd0000=
00a9': Device or resource busy
 > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs00000000000034230000=
007a': Device or resource busy
 > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000002d320000=
006b': Device or resource busy
 > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs0000000000001a7c0000=
0035': Device or resource busy
 > rm: cannot remove '/mnt/nfsv4/victims/v1/v2/.nfs00000000000017600000=
002a': Device or resource busy
 > Trinity v1.3pre  Dave Jones <davej@redhat.com>
 > Done parsing arguments.
 > Marking all syscalls as enabled.
 > [init] Enabled 351 syscalls. Disabled 0 syscalls.
 > [init] Using pid_max =3D 32768
 > [init] Started watchdog process, PID is 15311
 > [main] Main thread is alive.
 > [main] Generating file descriptors
 > [main] Something went wrong during nftw(/mnt/nfsv4/victims/v1/v2). (=
-1:Value too large for defined data type)

So NFS returned -EOVERFLOW. Not sure why it would do that, but I'm goin=
gto guess it
came from nftw internally doing an lseek.  lseek's man page suggests..

       EOVERFLOW
              The resulting file offset cannot be represented in an off=
_t.

64bit server and 32 bit client perhaps ?

	Dave
