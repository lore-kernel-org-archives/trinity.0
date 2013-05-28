From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: stupid Q : how can I derive your patch from the trinity list
Date: Tue, 28 May 2013 22:12:00 +0200
Message-ID: <51A50F90.6040400@gmx.de>
References: <51A1E8DB.10000@gmx.de> <51A1FE73.2070807@redhat.com> <51A2045D.1000402@gmx.de> <51A207AB.7010706@gmx.de> <51A20828.4070001@redhat.com> <51A21D34.30003@gmx.de> <51A22187.6030001@redhat.com> <51A22483.9040903@gmx.de> <51A3179D.7010801@redhat.com> <51A5073E.7080807@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51A5073E.7080807@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org

On 05/28/2013 09:36 PM, Daniel Borkmann wrote:
> On 05/27/2013 10:21 AM, Daniel Borkmann wrote:
> Just found some time to have a look into this. The issue was that the
> trinity.h header must be included before some asm headers, then it wo=
rks
> on newer kernels.
>=20
> I've attached the updated patch. Let me know if you still encounter a=
ny
> problems.

So I just added this on top of your three patches sent out earlier:
diff --git a/syscalls/modify_ldt.c b/syscalls/modify_ldt.c
index a9de3a4..d601338 100644
--- a/syscalls/modify_ldt.c
+++ b/syscalls/modify_ldt.c
@@ -9,7 +9,6 @@
 #define __ASSEMBLY__ 1
 #include <asm/ldt.h>

-#include "trinity.h"
 #include "sanitise.h"
 #include "shm.h"


and get now at a stable 32bit Gentoo Linux :

  CC    syscalls/setreuid16.o
syscalls/modify_ldt.c: In function =E2=80=98sanitise_modify_ldt=E2=80=99=
:  CC   syscalls/setuid.o

syscalls/modify_ldt.c:26:3: error: implicit declaration of function =E2=
=80=98bdw_malloc=E2=80=99 [-Werror=3Dimplicit-function-declaration]
syscalls/modify_ldt.c:26:3: error: nested extern declaration of =E2=80=98=
bdw_malloc=E2=80=99 [-Werror=3Dnested-externs]
syscalls/modify_ldt.c:26:7: error: assignment makes pointer from intege=
r without a cast [-Werror]
cc1: all warnings being treated as errors
make: *** [syscalls/modify_ldt.o] Error 1
make: *** Waiting for unfinished jobs....

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
