From: Paul Moore <pmoore@redhat.com>
Subject: Re: [PATCH] selinux: convert WARN_ONCE() to printk_once() in selinux_nlmsg_perm()
Date: Wed, 12 Nov 2014 16:44:41 -0500
Message-ID: <1565079.bnAGdRA6Jv@sifl>
References: <2373486.3IgvVOFVQB@sifl> <1709228.3j5ciILylX@sifl> <20141112213533.GA11274@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20141112213533.GA11274@madcap2.tricolour.ca>
Sender: linux-security-module-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, trinity@vger.kernel.org, sds@tycho.nsa.gov, vlee@twopensource.com, eparis@parisplace.org, james.l.morris@oracle.com, serge@hallyn.com

On Wednesday, November 12, 2014 04:35:33 PM Richard Guy Briggs wrote:
> On 14/11/12, Paul Moore wrote:
> > On Wednesday, November 12, 2014 04:25:15 PM Richard Guy Briggs wrote:
> > > Use pr_warn() instead...
> > 
> > Normally, yes, but the rest of the SELinux code uses printk(WARN) and I'm
> > a stickler for consistency.
> 
> And Joe Perches hasn't handed a patch you've accepted yet to convert it
> all over?

Maybe I missed it, but I don't recall one ...

-- 
paul moore
security and virtualization @ redhat

