From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: stupid Q : how can I derive your patch from the trinity list
Date: Sun, 26 May 2013 17:04:35 +0200
Message-ID: <51A22483.9040903@gmx.de>
References: <51A1E8DB.10000@gmx.de> <51A1FE73.2070807@redhat.com> <51A2045D.1000402@gmx.de> <51A207AB.7010706@gmx.de> <51A20828.4070001@redhat.com> <51A21D34.30003@gmx.de> <51A22187.6030001@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51A22187.6030001@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org

On 05/26/2013 04:51 PM, Daniel Borkmann wrote:
> If you add an #include <linux/types.h> into trinity.h before gc.h
> is included?
>=20

This doesn't help:

diff --git a/include/trinity.h b/include/trinity.h
index b0dc2f8..fb42036 100644
--- a/include/trinity.h
+++ b/include/trinity.h
@@ -2,6 +2,7 @@
 #define _TRINITY_H 1

 #define GC_THREADS
+#include <linux/types.h>
 #include <gc.h>

 #include "types.h"
lines 1-12/12 (END)


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
