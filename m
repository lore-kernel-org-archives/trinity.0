From: Nico Golde <nico@ngolde.de>
Subject: Re: minor trinity patch
Date: Fri, 24 May 2013 01:47:12 +0200
Message-ID: <20130523234712.GS14739@ngolde.de>
References: <20121220165100.GA8748@ngolde.de> <20121220171726.GA7543@redhat.com> <20121220172246.GA16285@ngolde.de> <20121220172741.GA17760@redhat.com> <20121220200255.GB16285@ngolde.de> <20121220201903.GA14944@redhat.com> <20130522141458.GA18931@ngolde.de> <CA+ydwtrggwedMpTeOfbSDAYDT7H=zZU7qAzSs6SzDW1Yx3Gi4g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ydwtrggwedMpTeOfbSDAYDT7H=zZU7qAzSs6SzDW1Yx3Gi4g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hi,
* Tommi Rantala <tt.rantala@gmail.com> [2013-05-23 20:58]:
> 2013/5/22 Nico Golde <nico@ngolde.de>:
> > I changed the code the following way:
> > @@ -21,7 +22,8 @@ static size_t bldevs, chrdevs, miscdevs;
> >  static void parse_proc_devices(void)
> >  {
> >         FILE *fp;
> > -       char *name, *line = NULL;
> > +       char *line = NULL;
> > +       char name[32];
> 
> It would be IMO preferable to not hardcode the max length.

I agree, this is actually left over from quickly changing this.
Are you aware of a proper maximum defined in the kernel headers or do we want to 
allocate this completely dynamically?

Cheers
Nico
