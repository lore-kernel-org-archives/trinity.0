From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH] selinux: convert WARN_ONCE() to printk_once() in
 selinux_nlmsg_perm()
Date: Wed, 12 Nov 2014 16:25:15 -0500
Message-ID: <20141112212515.GF28076@madcap2.tricolour.ca>
References: <2373486.3IgvVOFVQB@sifl>
 <49c549f887cd1a0284f79251765606eccacd11e3.1415818605.git.rgb@redhat.com>
 <2504561.J229oUfjhi@sifl>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2504561.J229oUfjhi@sifl>
Sender: linux-security-module-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <pmoore@redhat.com>
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, trinity@vger.kernel.org, sds@tycho.nsa.gov, vlee@twopensource.com, eparis@parisplace.org, james.l.morris@oracle.com, serge@hallyn.com

On 14/11/12, Paul Moore wrote:
> On Wednesday, November 12, 2014 02:01:34 PM Richard Guy Briggs wrote:
> > Convert WARN_ONCE() to printk_once() in selinux_nlmsg_perm().
> > 
> > After conversion from audit_log() in commit e173fb26, WARN_ONCE() was deemed
> > too alarmist, so switch it to printk_once().  If this gets buried in the
> > noise, it may be converted to a rate-limited call in the future.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  security/selinux/hooks.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index e663141..17d0066 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -4725,9 +4725,9 @@ static int selinux_nlmsg_perm(struct sock *sk, struct
> > sk_buff *skb) err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type,
> > &perm); if (err) {
> >  		if (err == -EINVAL) {
> > -			WARN_ONCE(1, "selinux_nlmsg_perm: unrecognized netlink 
> message:"
> > -				  " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
> > -				  sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
> > +			printk_once("selinux_nlmsg_perm: unrecognized netlink message:"
> > +				    " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
> > +				    sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
> >  			if (!selinux_enforcing || security_get_allow_unknown())
> >  				err = 0;
> >  		}
> 
> My apologies, I should have noticed this sooner, but printk_once() is probably 
> not a good choice here as only the first invalid netlink message will be 
> displayed.  This is fine if all the invalid netlink messages happen the same, 
> but that isn't likely to be the case.

This was the same situation with WARN_ONCE(), hence my comment about
difficulty in debugging...

> Richard, any objections if I convert the printk_once() to a printk(WARN) and 
> update the patch description accordingly?

Use pr_warn() instead...

> paul moore

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
