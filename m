From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH trinity v2, RFT] trinity: use Boehm-Demers-Weiser's
 garbage collecting memory allocator
Date: Mon, 3 Jun 2013 09:25:20 +0300
Message-ID: <CA+ydwtrZKC+8UQA0gw_Qp9PffUT5wrzr3e+qnQnfyFc78zEKKQ@mail.gmail.com>
References: <1369564593-18728-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=yHauAl9ppelYrVytudwW2tBFYG692QVy/xH6CLHNtmw=;
        b=avs6eI8t59iBJDSukKWgBYiA+fDZCJTSdSMHpvtlj/olrDprN36HZe9K0WAJs4nDkP
         A31qC/00fR8fZ7xKLiZGGNVEmybdEp8gUSF3HT8udzQM47jwFWlQo5i89FDQxH8+fhVv
         dXp72BfujhEHSkjEiFSVOk/nLdWo64jPhfWKe+qxnIKtx7krGz3Px9DN7CCVdng7T70T
         AFbrWqx7XWqATqzgdRdUChOHN7/4PACFZlMMYYfZ/A8n/O4FZr5VLQg7mGde3YilLWVx
         dhyc1tvLb2Jh5XZ6dJFR+ZJ6hdoI5vhzp9WDpn+WrQexfo+g330KbXjxkabZgG4LEyYO
         c9Qw==
In-Reply-To: <1369564593-18728-1-git-send-email-dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

2013/5/26 Daniel Borkmann <dborkman@redhat.com>:
> diff --git a/devices.c b/devices.c
> index 0493c39..2e115f8 100644
> --- a/devices.c
> +++ b/devices.c
> @@ -8,6 +8,7 @@
>  #include <sys/types.h>
>  #include <linux/kdev_t.h>
>
> +#include "trinity.h"
>  #include "log.h"
>
>  static struct {
> @@ -37,9 +38,9 @@ static void parse_proc_devices(void)
>                         block = 1;
>                 else if (sscanf(line, "%d %as", &major, &name) == 2) {
>                         if (block) {
> -                               new = realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
> +                               new = bdw_realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
>                                 if (!new) {
> -                                       free(name);
> +                                       bdw_free(name);
>                                         continue;
>                                 }
>                                 block_devs = new;
> @@ -48,9 +49,9 @@ static void parse_proc_devices(void)
>                                 block_devs[bldevs].name = name;
>                                 bldevs++;
>                         } else {
> -                               new = realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
> +                               new = bdw_realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
>                                 if (!new) {
> -                                       free(name);
> +                                       bdw_free(name);
>                                         continue;
>                                 }
>                                 char_devs = new;
> @@ -63,7 +64,7 @@ static void parse_proc_devices(void)
>         }
>
>         fclose(fp);
> -       free(line);
> +       bdw_free(line);
>  }

'line' is allocated implicitly by getline(), is it safe to bdw_free() it?

Tommi
