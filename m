From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: stupid Q : how can I derive your patch from the trinity list
Date: Sun, 26 May 2013 16:51:51 +0200
Message-ID: <51A22187.6030001@redhat.com>
References: <51A1E8DB.10000@gmx.de> <51A1FE73.2070807@redhat.com> <51A2045D.1000402@gmx.de> <51A207AB.7010706@gmx.de> <51A20828.4070001@redhat.com> <51A21D34.30003@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <51A21D34.30003@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On 05/26/2013 04:33 PM, Toralf F=C3=B6rster wrote:
> On 05/26/2013 03:03 PM, Daniel Borkmann wrote:
>>
>> Hm, interesting ... I'm using Fedora 17 and don't see it.
>>
>> Do you have x86_64?
>
> nope, I do have a 32bit Gentoo Linux, sys-kernel/linux-headers packag=
es
> is 3.8 and gcc is 4.6.3

If you add an #include <linux/types.h> into trinity.h before gc.h
is included?
