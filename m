From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: "selinux_nlmsg_perm: unrecognized netlink message: protocol=0
 nlmsg_type=0 sclass=30" warning on Linux 3.18-rc3
Date: Wed, 5 Nov 2014 17:25:37 -0500
Message-ID: <20141105222537.GG5902@madcap2.tricolour.ca>
References: <CAHTgTXVyR3hoZDSp6QRTtJ9+cAuPXsPomfDBw0zisft=7H_7dA@mail.gmail.com>
 <1588252.T4atn8E9DE@sifl>
 <545A8DE8.1010106@tycho.nsa.gov>
 <18386541.xBZWpSPpcC@sifl>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18386541.xBZWpSPpcC@sifl>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Vinson Lee <vlee@twopensource.com>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, trinity@vger.kernel.org

On 14/11/05, Paul Moore wrote:
> On Wednesday, November 05, 2014 03:51:52 PM Stephen Smalley wrote:
> > On 11/05/2014 03:48 PM, Paul Moore wrote:
> > > On Tuesday, November 04, 2014 12:12:56 PM Vinson Lee wrote:
> > >> Hi.
> > >> 
> > >> trinity triggered this kernel warning in selinux_netlink_send on Linux
> > >> 3.18-rc3.

Vinson, have you ever seen an audit message reporting this problem
previously from trinity?

> > > It looks like trinity sent a bogus netlink message to the kernel and
> > > SELinux responded as I would expect it to, with a WARN_ONCE() message. 
> > > Thank you for your help in testing, but I don't see a problem here that
> > > needs to be resolved.
> > 
> > I guess the only thing new here is that this message used to be directed
> > to the audit system via audit_log() and was changed to use WARN_ONCE().
> > Why was that change made (the change description gives no rationale)?
> 
> My understanding was that the audit record didn't fit the hoped-for-but-not-
> really-a-standard name value pair format that the audit folks like.  Richard 
> wanted to either normalize the audit record or replace it with something else.

I didn't like that it was an audit record because that wasn't really an
auditable event since it failed, presenting no danger to the system, and
that it could potentially fill audit logs with useless reports.

I didn't really like that it was a WARN_ONCE, since it seemed a bit too
alarmist and also made it more difficult to debug.

The other recent WARN_ONCE conversions were partly influenced by an
effort to clean up locking in audit, but that is not the case here.

> > Is this an appropriate use of WARN_ONCE()?
> 
> In retrospect, we could probably do better.  I don't think it should be an 
> audit record, but I can see the point that a backtrace and scary WARNING! 
> display are probably a bit too much.
> 
> Richard, how about converting this WARN_ONCE() to a printk_once(), or similar?

I'd be agreeable to that.  While I was a bit concerned that a
WARN_ONCE() could be lost in the noise (evidently that's not the case!)
a printk_once() would more likely get lost in the noise.  Would it make
sense to make it a bit less infrequent than printk_once() and rate-limit
it at say, one per 5 seconds or more?

> paul moore

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
