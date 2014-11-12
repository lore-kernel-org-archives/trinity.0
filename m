From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH] selinux: convert WARN_ONCE() to printk_once() in
 selinux_nlmsg_perm()
Date: Wed, 12 Nov 2014 16:35:33 -0500
Message-ID: <20141112213533.GA11274@madcap2.tricolour.ca>
References: <2373486.3IgvVOFVQB@sifl>
 <2504561.J229oUfjhi@sifl>
 <20141112212515.GF28076@madcap2.tricolour.ca>
 <1709228.3j5ciILylX@sifl>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1709228.3j5ciILylX@sifl>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <pmoore@redhat.com>
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, trinity@vger.kernel.org, sds@tycho.nsa.gov, vlee@twopensource.com, eparis@parisplace.org, james.l.morris@oracle.com, serge@hallyn.com

On 14/11/12, Paul Moore wrote:
> On Wednesday, November 12, 2014 04:25:15 PM Richard Guy Briggs wrote:
> > On 14/11/12, Paul Moore wrote:
> > > My apologies, I should have noticed this sooner, but printk_once() is
> > > probably not a good choice here as only the first invalid netlink message
> > > will be displayed.  This is fine if all the invalid netlink messages
> > > happen the same, but that isn't likely to be the case.
> > 
> > This was the same situation with WARN_ONCE(), hence my comment about
> > difficulty in debugging...
> 
> Unfortunately I didn't realize your point until now.
> 
> > > Richard, any objections if I convert the printk_once() to a printk(WARN)
> > > and update the patch description accordingly?
> > 
> > Use pr_warn() instead...
> 
> Normally, yes, but the rest of the SELinux code uses printk(WARN) and I'm a 
> stickler for consistency.

And Joe Perches hasn't handed a patch you've accepted yet to convert it
all over?

As you prefer...

> paul moore

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
