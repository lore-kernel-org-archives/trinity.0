From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: minor trinity patch
Date: Thu, 23 May 2013 21:58:27 +0300
Message-ID: <CA+ydwtrggwedMpTeOfbSDAYDT7H=zZU7qAzSs6SzDW1Yx3Gi4g@mail.gmail.com>
References: <20121220165100.GA8748@ngolde.de>
	<20121220171726.GA7543@redhat.com>
	<20121220172246.GA16285@ngolde.de>
	<20121220172741.GA17760@redhat.com>
	<20121220200255.GB16285@ngolde.de>
	<20121220201903.GA14944@redhat.com>
	<20130522141458.GA18931@ngolde.de>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=tBXKFeXgd2ewnV3RSdmKbEfunPZzzNlj4uQRGt3iYVI=;
        b=vbbtaG3WRMvhVzc7/d50D944LD3VZAV7xZQBmfWfQGPIWF/cGUFgsfHaqw1g3/+gIl
         4EPmQGFjd+Bc6/ackzdkyhQVxwk1QUl5tLpoNIGEdRjyk1C5qzac+QlW95U7cZit5+JE
         5ivofnfN0kcWjC3CH/vGpfZb7AQCJbPDq/vBVWnjZ+Ek4M5NejYH4DjFuVZRvZ/YWnkJ
         dDebkWIb0+HkgJCv/vaOmtxFVNeC8MiyiX/dJ1Ds7xH7RPI0W6hMjtQH4bhjUh8jVxq+
         9sLHZutSev+ph2rXbGPJ3vwIVHO96IV6WD1fcShX3IaYpJp1zPRTNVpwEtREZu6aw0xI
         TP4w==
In-Reply-To: <20130522141458.GA18931@ngolde.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nico Golde <nico@ngolde.de>
Cc: trinity@vger.kernel.org

2013/5/22 Nico Golde <nico@ngolde.de>:
> Hi,
> I'm not sure if you would like to change this....
> In devices.c you scan for the device name in /proc/devices using the %as
> string.
> On bionic this doesn't seem to work and therefore no devices are found and
> because of this no ioctl group ever matches.

No objections to changing this.

> I changed the code the following way:
> @@ -21,7 +22,8 @@ static size_t bldevs, chrdevs, miscdevs;
>  static void parse_proc_devices(void)
>  {
>         FILE *fp;
> -       char *name, *line = NULL;
> +       char *line = NULL;
> +       char name[32];

It would be IMO preferable to not hardcode the max length.

>         size_t n = 0;
>         int block, major;
>         void *new;
> @@ -33,30 +35,31 @@ static void parse_proc_devices(void)
>         block = 0;
>
>         while (getline(&line, &n, fp) >= 0) {
> +               memset(name, 0, sizeof(name));
>                 if (strcmp("Block devices:\n", line) == 0)
>                         block = 1;
> -               else if (sscanf(line, "%d %as", &major, &name) == 2) {
> +               else if (strcmp("Character devices:\n", line) == 0)
> +                       block = 0;
> +               else if (sscanf(line, "%d %s", &major, &name) == 2) {
>                         if (block) {
>                                 new = realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
>                                 if (!new) {
> -                                       free(name);
>                                         continue;
>                                 }
>                                 block_devs = new;
>                                 block_devs[bldevs].major = major;
>                                 block_devs[bldevs].minor = 0;
> -                               block_devs[bldevs].name = name;
> +                               block_devs[bldevs].name = strdup(name);
>                                 bldevs++;
>                         } else {
>                                 new = realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
>                                 if (!new) {
> -                                       free(name);
>                                         continue;
>                                 }
>                                 char_devs = new;
>                                 char_devs[chrdevs].major = major;
>                                 char_devs[chrdevs].minor = 0;
> -                               char_devs[chrdevs].name = name;
> +                               char_devs[chrdevs].name = strdup(name);
>                                 chrdevs++;
>                         }
>                 }
>
>
> I also added the additional strcmp just to make sure that the code works also
> if the order of character devices/block devices in /proc/devices changes at
> some point.
>
> Cheers
> Nico
