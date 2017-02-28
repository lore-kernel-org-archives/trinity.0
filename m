From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] fds/drm.c: Increase buffer size.
Date: Tue, 28 Feb 2017 18:02:33 -0500
Message-ID: <20170228230233.oaxwmv546oed6raz@codemonkey.org.uk>
References: <1488311356-12461-1-git-send-email-vlee@freedesktop.org>
 <20170228210855.sj2zpdw3fusqh4hv@codemonkey.org.uk>
 <CACKvgLGaKWEu_vGmqEOqeauZ7053TOh4iddndGEbJyiUk-VAnQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACKvgLGaKWEu_vGmqEOqeauZ7053TOh4iddndGEbJyiUk-VAnQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Tue, Feb 28, 2017 at 05:59:24PM -0500, Vinson Lee wrote:

 > >  > diff --git a/fds/drm.c b/fds/drm.c
 > >  > index 1f7b95f1eb34..b094183d8d0d 100644
 > >  > --- a/fds/drm.c
 > >  > +++ b/fds/drm.c
 > >  > @@ -83,7 +83,7 @@ static int open_drm_fds(void)
 > >  >      int fd, dfd;
 > >  >      DIR *dir;
 > >  >      struct dirent *entry;
 > >  > -    char buf[128];
 > >  > +    char buf[512];
 > >
 > > d_name is only 256. Does 256+10 make the error go away ?
 > >
 > > I don't think this is ever a problem in real life, because no-one is
 > > insane enough to name a device node in that dir that long, but we should
 > > shut the warning up.
 > >
 > > Is this a gcc7 thing ?
 > >
 > >         Dave
 > >
 > 
 > Yes, buf[256+10] also fixes the build error.
 > 
 > Yes, this build error occurs with 7.0.

Cool, I'll hack up your mail and apply it.

thanks,

	Dave

