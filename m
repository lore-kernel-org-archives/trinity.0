From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH] Fix 2.6.32 compiler errors
Date: Wed, 27 Mar 2013 21:12:12 +0200
Message-ID: <CA+ydwtrauKTKhB7XcZyGP1xJgbwN5hwsgPYcQdpU3FwHq-PBmA@mail.gmail.com>
References: <515341F8.7000806@hp.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=A6T5CPr/HWa0xCTuKUaA37S4eU5N1eLE33Yu2NNxoIE=;
        b=oMQK3Pab0oOPiWb06EJBSXedPfh47fwKyxRL6xSZ7dIfu9Gvj9oh5qmbMITEIJoPLU
         CXcWodxbFaqCM/ROSec1DeoLs/wjMNG6Q6cIjdoDhM5AqzzR7m0a7UwT99uV0ddnmv9W
         ddiHnXc1sLF8zp/d7woCa6X3P/jvNht2IZBUyqHhCQ1V6HGDLyyUvWEX+wrWXSqmfKjB
         k6egLbDqD/3jzNYYTYu+dHltsVnBnXdju0axUFoLdoVp+mcsmcLoFUn0nfWpcBfIvIiU
         SATopZP6ZBmW5kfQYoJmLMIpaeaLA0PFTn1teHNU+eDknrKwj491AWkVMy1OTtyfQd8x
         QFFw==
In-Reply-To: <515341F8.7000806@hp.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Brian Haley <brian.haley@hp.com>
Cc: trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

2013/3/27 Brian Haley <brian.haley@hp.com>:
[...]
> diff --git a/ioctls/vhost.c b/ioctls/vhost.c
> index 4ead0e6..3db8e66 100644
> --- a/ioctls/vhost.c
> +++ b/ioctls/vhost.c
> @@ -1,3 +1,4 @@

Hi, please #include "config.h" here.

> +#ifdef USE_VHOST
>  #include <linux/vhost.h>
>
>  #include "trinity.h"
> @@ -35,3 +36,4 @@ static const struct ioctl_group vhost_grp = {
>  };
>
>  REG_IOCTL_GROUP(vhost_grp)
> +#endif /* USE_VHOST */

Thanks,
Tommi
