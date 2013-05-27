From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: stupid Q : how can I derive your patch from the trinity list
Date: Mon, 27 May 2013 10:21:49 +0200
Message-ID: <51A3179D.7010801@redhat.com>
References: <51A1E8DB.10000@gmx.de> <51A1FE73.2070807@redhat.com> <51A2045D.1000402@gmx.de> <51A207AB.7010706@gmx.de> <51A20828.4070001@redhat.com> <51A21D34.30003@gmx.de> <51A22187.6030001@redhat.com> <51A22483.9040903@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51A22483.9040903@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On 05/26/2013 05:04 PM, Toralf F=C3=B6rster wrote:
> On 05/26/2013 04:51 PM, Daniel Borkmann wrote:
>> If you add an #include <linux/types.h> into trinity.h before gc.h
>> is included?
>>
>
> This doesn't help:

Ok, I compiled this against a 3.6.9-2.fc17.x86_64. So let me check this
on the latest net.git kernel.

gc.h seems to be innocent here, might be an issue with sigcontext.h
itself, e.g.:

   http://lists.openbios.org/pipermail/openbios/2012-June/006924.html

Let me check and come back to you.

> diff --git a/include/trinity.h b/include/trinity.h
> index b0dc2f8..fb42036 100644
> --- a/include/trinity.h
> +++ b/include/trinity.h
> @@ -2,6 +2,7 @@
>   #define _TRINITY_H 1
>
>   #define GC_THREADS
> +#include <linux/types.h>
>   #include <gc.h>
>
>   #include "types.h"
> lines 1-12/12 (END)
>
>
