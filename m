From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/4] Teach trinity to not use some sockets family
Date: Thu, 31 Oct 2013 16:20:11 -0400
Message-ID: <20131031202011.GA15639@redhat.com>
References: <1382650768-30954-1-git-send-email-gorcunov@gmail.com>
 <CAM5jBj5dvv1HP6ffRnP+b5sQkd0mP3nDcEU-N6+pYvaZ6b3epw@mail.gmail.com>
 <20131031194943.GA8696@redhat.com>
 <20131031200545.GF9860@moon>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131031200545.GF9860@moon>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: trinity@vger.kernel.org, Vladimir Davydov <vdavydov@parallels.com>

On Fri, Nov 01, 2013 at 12:05:45AM +0400, Cyrill Gorcunov wrote:

 > > I'm about to apply your later series, but I noticed that that one
 > > instead of the --fds patch, has the -E change.
 > > 
 > > Do you still plan on submitting the --fds change later?
 > > The reason I ask is that it if we're doing --fds, then it might at some point
 > > mean we can deprecate (and then remove) use of -P in favor of it, so adding an
 > > inverse (-E) seems odd.
 > 
 > Hi Dave! To be fair, not sure at moment. Initially I wanted to implement a general
 > --fds option which might take more complex command line like sockets:PF_X,^PF_X and
 > such, then extend it to file:^pipe,epoll. But this end up in being somehow
 > more complex rework. So I decided to stick with simplier approach first -- -E option
 > which would exclude some socket protocols from being generated.
 > 
 > But sure, once time permit I can try to implement --fds option as well. Lets fisrt
 > summarize what kind of syntax it will carry.
 > 
 >  --fds [sockets:PF_X,^PF_X,N,^N,all,none],[files:pipe,^epoll,all,none]
 > 
 > Sounds good?

Sure. I just pushed out your 2nd patch set.

thanks,

	Dave
