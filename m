From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH v2] syscalls: use ARRAY_SIZE(x) instead of hard code define
Date: Fri, 7 Jun 2013 08:58:03 +0300
Message-ID: <CA+ydwtpcTdeTJiXYbM-5z55jM1Cj3i5FKo0-8W1ohZx=21nzpQ@mail.gmail.com>
References: <1370536117-17806-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=qO4FNXPeRIAoojtuXZiKQHDnJz29ra937DEmYt878pw=;
        b=0/SmYdLGsbGQXYu/VEUyqbdpgBj/KFVQ2S7ddRqwezmTMxlelYSm7VLKDDERC0IB1m
         pHo3/w40GeMyTYR2OgucnTRVHelrGMzL3iF8ySCMj27Itb6KflNzDmf8RdWAg/m8pJ6F
         XsUm1LtjmYEBxc3yiCOxxBNScjjKgyHjKNl1mCXSydIsjXt4XaXBcUV8nP5MVnhp0cZG
         iNxpyL16XU9TZunS6XMHJQDdQoR6cHoeiZ1FvUrYUIPJo5xZqN7ggXaa79oDoqBIRqMR
         BgovWoAkgR/X8asHfl8SPKLURobvlE714YoDa/qDj1VDyFiYE6JslfVD/H0fELOC9nsa
         O4BA==
In-Reply-To: <1370536117-17806-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: trinity@vger.kernel.org

2013/6/6 Hangbin Liu <liuhangbin@gmail.com>:
> @@ -58,15 +59,15 @@
>  #define SOL_ALG         279
>  #define SOL_NFC                280
>
> -#define NR_SOL_IP_OPTS 19
> -static int ip_opts[NR_SOL_IP_OPTS] = { IP_TOS, IP_TTL, IP_HDRINCL, IP_OPTIONS,
> +#define NR_SOL_IP_OPTS ARRAY_SIZE(ip_opts)
> +static int ip_opts[] = { IP_TOS, IP_TTL, IP_HDRINCL, IP_OPTIONS,

How about also adding 'const'... ?

Dave already picked the patch, so this could be done separately.

Tommi
