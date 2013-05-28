From: Dave Jones <davej@redhat.com>
Subject: Re: generic-sanitise.c:fill_arg:294 unreachable!
Date: Tue, 28 May 2013 11:20:08 -0400
Message-ID: <20130528152008.GA3560@redhat.com>
References: <51A4C931.90908@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51A4C931.90908@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Tue, May 28, 2013 at 05:11:45PM +0200, Toralf F=F6rster wrote:
 > run into this today while fuzzying a stable Gentoo Linux image (chro=
oted) and kernel 3.10-rc3:
 >=20
 >=20
 > [29118] [36] statfs64(pathname=3D"/mnt/hostfs/v1/v2/f19735", sz=3D0x=
3fba7c8f) =3D -1 (Invalid argument)
 > generic-sanitise.c:fill_arg:294 unreachable!
 > [watchdog] pid 29096 hasn't made progress in 30 seconds! (last:13697=
53604 now:1369753634 diff:30). Stuck in syscall 279:mq_timedsend. Sendi=
ng SIGKILL.
 > [28242] Random reseed: 504311294
 >=20
 >=20
 > and later :
 >=20
 >=20
 > [29123] [128] setdomainname(name=3D0, len=3D0) =3D -1 (Operation not=
 permitted)
 > [29123] [129] pread64(fd=3D12, buf=3D0x895a000[page_rand], count=3D4=
096, pos=3D16) =3D -1 (Is a directory)
 > generic-sanitise.c:fill_arg:294 unreachable!
 > [watchdog] pid 29118 hasn't made progress in 30 seconds! (last:13697=
53633 now:1369753663 diff:30). Stuck in syscall 279:mq_timedsend. Sendi=
ng SIGKILL.
 > [28242] Random reseed: 1774374230
 > [29133] [0] setresuid(ruid=3D0x8fffffff, euid=3D0x45009081, suid=3D0=
x67a8cbc6) =3D -1 (Operation not permitted)
 >=20
 >=20
 >=20
 > [29133] [31] acct(name=3D0) =3D -1 (Operation not permitted)
 > [29133] [32] pipe2(fildes=3D4, flags=3D0x4000) =3D -1 (Bad address)
 > generic-sanitise.c:fill_arg:294 unreachable!
 > [watchdog] pid 29121 hasn't made progress in 30 seconds! (last:13697=
53635 now:1369753665 diff:30). Stuck in syscall 279:mq_timedsend. Sendi=
ng SIGKILL.
 > [28242] Random reseed: 641723094
 > [29143] [0] unlinkat(dfd=3D12, pathname=3D"/mnt/hostfs/v1/v2/f19735"=
, flag=3D0x74fe39d0) =3D -1 (Invalid argument)
 >=20
 >=20
 > expected or rather a ToDo ?

unexpected. Very strange. Can you apply this, and see what it prints ou=
t ?

diff --git a/generic-sanitise.c b/generic-sanitise.c
index 0fb2f52..2232437 100644
--- a/generic-sanitise.c
+++ b/generic-sanitise.c
@@ -291,6 +291,9 @@ static unsigned long fill_arg(int childno, int call=
, int argnum)
 		return mode;
=20
 	default:
+		printf("name: %s\n", syscalls[call].entry->name);
+		printf("argnum: %d\n", argnum);
+		printf("argtype: %d\n", argtype);
 		BUG("unreachable!\n");
 		return 0;
 	}
=20
