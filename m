From: Paul Moore <paul@paul-moore.com>
Subject: Re: "selinux_nlmsg_perm: unrecognized netlink message: protocol=0 nlmsg_type=0 sclass=30" warning on Linux 3.18-rc3
Date: Wed, 05 Nov 2014 16:57:29 -0500
Message-ID: <18386541.xBZWpSPpcC@sifl>
References: <CAHTgTXVyR3hoZDSp6QRTtJ9+cAuPXsPomfDBw0zisft=7H_7dA@mail.gmail.com> <1588252.T4atn8E9DE@sifl> <545A8DE8.1010106@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <545A8DE8.1010106@tycho.nsa.gov>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: Stephen Smalley <sds@tycho.nsa.gov>, Richard Guy Briggs <rgb@redhat.com>
Cc: Vinson Lee <vlee@twopensource.com>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, trinity@vger.kernel.org

On Wednesday, November 05, 2014 03:51:52 PM Stephen Smalley wrote:
> On 11/05/2014 03:48 PM, Paul Moore wrote:
> > On Tuesday, November 04, 2014 12:12:56 PM Vinson Lee wrote:
> >> Hi.
> >> 
> >> trinity triggered this kernel warning in selinux_netlink_send on Linux
> >> 3.18-rc3.
> > 
> > It looks like trinity sent a bogus netlink message to the kernel and
> > SELinux responded as I would expect it to, with a WARN_ONCE() message. 
> > Thank you for your help in testing, but I don't see a problem here that
> > needs to be resolved.
> 
> I guess the only thing new here is that this message used to be directed
> to the audit system via audit_log() and was changed to use WARN_ONCE().
> Why was that change made (the change description gives no rationale)?

My understanding was that the audit record didn't fit the hoped-for-but-not-
really-a-standard name value pair format that the audit folks like.  Richard 
wanted to either normalize the audit record or replace it with something else.

> Is this an appropriate use of WARN_ONCE()?

In retrospect, we could probably do better.  I don't think it should be an 
audit record, but I can see the point that a backtrace and scary WARNING! 
display are probably a bit too much.

Richard, how about converting this WARN_ONCE() to a printk_once(), or similar?

-- 
paul moore
www.paul-moore.com
