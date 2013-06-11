From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Tue, 11 Jun 2013 18:21:08 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306111815001.6833@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu> <20130611210542.GA17585@redhat.com> <alpine.DEB.2.10.1306111720440.28238@vincent-weaver-1.um.maine.edu> <20130611213230.GB17585@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130611213230.GB17585@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Tue, 11 Jun 2013, Dave Jones wrote:

> yeah, that's what I've done in a lot of other places (actually BUG() in those cases).
> For the most part they're present just to shut up -Wswitch-default, which
> has caught a few cases in the past where I've missed an option.

I'll go back through and check out all of the switch statements (there 
are a lot of them) and make sure they handle the default case 
consistently.
  
> ok, I'll apply what you sent so far. (and hold off on running it through Lindent for now,
> you really don't like whitespace huh? ;)

Not enough whitespace?  Or over-use of tabs?

Everyone hates my personal indent style so I try to match whatever project 
I contribute to, to the extent of using nano as an editor to make sure
emacs et al aren't introducing weird whitespace changes behind my back.
My contributions to outside projects are usually only one-liners so it
usually isn't an issue...

Vince
