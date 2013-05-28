From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: stupid Q : how can I derive your patch from the trinity list
Date: Tue, 28 May 2013 23:29:14 +0200
Message-ID: <51A521AA.7090506@redhat.com>
References: <51A1E8DB.10000@gmx.de> <51A1FE73.2070807@redhat.com> <51A2045D.1000402@gmx.de> <51A207AB.7010706@gmx.de> <51A20828.4070001@redhat.com> <51A21D34.30003@gmx.de> <51A22187.6030001@redhat.com> <51A22483.9040903@gmx.de> <51A3179D.7010801@redhat.com> <51A5073E.7080807@redhat.com> <51A50F90.6040400@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51A50F90.6040400@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On 05/28/2013 10:12 PM, Toralf F=C3=B6rster wrote:
> On 05/28/2013 09:36 PM, Daniel Borkmann wrote:
>> On 05/27/2013 10:21 AM, Daniel Borkmann wrote:
>> Just found some time to have a look into this. The issue was that th=
e
>> trinity.h header must be included before some asm headers, then it w=
orks
>> on newer kernels.
>>
>> I've attached the updated patch. Let me know if you still encounter =
any
>> problems.
>
> So I just added this on top of your three patches sent out earlier:
> diff --git a/syscalls/modify_ldt.c b/syscalls/modify_ldt.c
> index a9de3a4..d601338 100644
> --- a/syscalls/modify_ldt.c
> +++ b/syscalls/modify_ldt.c
> @@ -9,7 +9,6 @@
>   #define __ASSEMBLY__ 1
>   #include <asm/ldt.h>
>
> -#include "trinity.h"
>   #include "sanitise.h"
>   #include "shm.h"
>
> and get now at a stable 32bit Gentoo Linux :
>
>    CC    syscalls/setreuid16.o
> syscalls/modify_ldt.c: In function =E2=80=98sanitise_modify_ldt=E2=80=
=99:  CC   syscalls/setuid.o
>
> syscalls/modify_ldt.c:26:3: error: implicit declaration of function =E2=
=80=98bdw_malloc=E2=80=99 [-Werror=3Dimplicit-function-declaration]
> syscalls/modify_ldt.c:26:3: error: nested extern declaration of =E2=80=
=98bdw_malloc=E2=80=99 [-Werror=3Dnested-externs]
> syscalls/modify_ldt.c:26:7: error: assignment makes pointer from inte=
ger without a cast [-Werror]
> cc1: all warnings being treated as errors
> make: *** [syscalls/modify_ldt.o] Error 1
> make: *** Waiting for unfinished jobs....

Yes, but this is wrong, obviously. Have a look into the v3 of the patch=
 I've
sent a couple of hours ago to you and the list (was attached in the las=
t mail):

In syscalls/modify_ldt.c, it starts with ...

diff --git a/syscalls/modify_ldt.c b/syscalls/modify_ldt.c
index 0331a3e..93271b5 100644
--- a/syscalls/modify_ldt.c
+++ b/syscalls/modify_ldt.c
@@ -1,3 +1,4 @@
+#include "trinity.h"
  #include "arch.h"

  #ifdef X86
@@ -8,6 +9,7 @@
  #include <sys/types.h>
  #define __ASSEMBLY__ 1
  #include <asm/ldt.h>
+
  #include "sanitise.h"
  #include "shm.h"
