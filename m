From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] net/bpf.c: Remove AUDIT_ARCH_H8300.
Date: Sat, 16 Nov 2013 13:29:51 +0100
Message-ID: <5287653F.2020809@redhat.com>
References: <1384564859-22889-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1384564859-22889-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org, Vinson Lee <vlee@twitter.com>

On 11/16/2013 02:20 AM, Vinson Lee wrote:
> From: Vinson Lee <vlee@twitter.com>
>
> AUDIT_ARCH_H8300 was removed from include/uapi/linux/audit.h in Linux
> 3.13 commit 6f6f467eaaa0ac4fb77714d0172d65c781dabb8c.
>
> commit 6f6f467eaaa0ac4fb77714d0172d65c781dabb8c
> Author: Guenter Roeck <linux@roeck-us.net>
> Date:   Fri Aug 30 06:12:40 2013 -0700
>
>      Drop remaining references to H8/300 architecture
>
>      With the architecture gone, any references to it are no longer n=
eeded.
>
>      Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
>      Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>
> This patch fixes this build error.
>
>    CC	net/bpf.o
> net/bpf.c:135:18: error: =E2=80=98AUDIT_ARCH_H8300=E2=80=99 undeclare=
d here (not in a function)
>    AUDIT_ARCH_FRV, AUDIT_ARCH_H8300, AUDIT_ARCH_I386, AUDIT_ARCH_IA64=
,
>                    ^
>
> Signed-off-by: Vinson Lee <vlee@twitter.com>

Although the elements in the array could then be rearragned, but fair e=
nough:

Acked-by: Daniel Borkmann <dborkman@redhat.com>

Thanks !
