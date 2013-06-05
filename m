From: =?GB2312?B?wfW6vbHy?= <liuhangbin@gmail.com>
Subject: Re: [PATCH] compat: define NETLINK_CRYPTO constant
Date: Wed, 5 Jun 2013 17:59:19 +0800
Message-ID: <CAPwn2JR-3QnAkfOxuD+3kRMgVyDazoREfQsd5++aYwXVj3ntGw@mail.gmail.com>
References: <1370425885-24383-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=e1SKCIwAaBM6Jd//+5vt89jNP55LwIukw0o5oHqboO4=;
        b=Fo00tZmjdSnP2KBiexPwpmXTf/DjLH+BoQbrmj1YcgcQhb3kynMHbXnXJgFjanHioH
         dV3nAvtKDuzfqN7b5lhADWEOCAefHoK+8deP1OxaSckR7JSOb11NY5ptl6TxB8Av51Jb
         2xrU7nnS7Znal8/wM4NVNDVB5gtV9nACiIs5MqA8zQVyWAFvkG/dkderImrrFpVw20pI
         mFlGgZrd+tdWFjn1aOeyC0VMI+BSU6oZSB7xLmH0Sb8RUPJ3DjLIdpafzlw4dbMsNS1i
         YCHvAv6NQUSP9ERdDUU3ib+FhJ2dujVR6JPmzHBfZ8ySEdE9f4qE15d97kuw6b47ZY9b
         fjMg==
In-Reply-To: <1370425885-24383-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

OK, I saw baf2603 have fixed this issue, please ignore this patch

2013/6/5 Hangbin Liu <liuhangbin@gmail.com>:
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/compat.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/compat.h b/include/compat.h
> index 20455f3..cef29f7 100644
> --- a/include/compat.h
> +++ b/include/compat.h
> @@ -180,6 +180,11 @@ enum {
>  #define SYS_SENDMMSG 20
>  #endif
>
> +/* linux/netlink.h */
> +#ifndef NETLINK_CRYPTO
> +#define NETLINK_CRYPTO 21
> +#endif
> +
>  /* linux/rds.h */
>  #ifndef RDS_CANCEL_SENT_TO
>  #define RDS_CANCEL_SENT_TO              1
> --
> 1.8.1.4
>
