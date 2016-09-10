From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [bug] child processes stall forever and don't get killed
Date: Fri, 9 Sep 2016 21:46:30 -0400
Message-ID: <20160910014630.kszwikfkznrpzqic@codemonkey.org.uk>
References: <1139550397.1201862.1473415639192.JavaMail.zimbra@redhat.com>
 <210078090.1267922.1473417016250.JavaMail.zimbra@redhat.com>
 <20160909133236.qm32kmsz3wfby53y@codemonkey.org.uk>
 <907265021.1542338.1473430577178.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <907265021.1542338.1473430577178.JavaMail.zimbra@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Stancek <jstancek@redhat.com>
Cc: trinity@vger.kernel.org

On Fri, Sep 09, 2016 at 10:16:17AM -0400, Jan Stancek wrote:
 
 > >  > I'm seeing more the opposite of what commit above says. Most CPUs
 > >  > are idle, because N-1 children are stuck in recv/read/...
 > >  > and last child manages to keep going. Then by a chance it also hits
 > >  > a syscall that doesn't complete and system stays idle
 > >  > (after ~hour I gave up waiting).
 > > 
 > > Need to think some more on this, but as a quick guess...
 > > try replacing the <= BEFORE with < BEFORE
 > 
 > I've started new test with patch above reverted and that looks good
 > so far. No stalls after 1 hour. Previously it stalled after ~20-30
 > minutes. I noticed that when syscall stat messages (those which show
 > number of iteration) stopped appearing.

Ok, I committed that, but with a minor change to widen how long we spend
in BEFORE state slightly. I doubt that part will have a negative effect,
but holler if it does..

 > > I'll try and find some time to look into this soon. I'm surprised I
 > > haven't also seen it happen though.  How many CPUs & how many child
 > > processes ?
 > 
 > Anywhere from 2-8 CPUs, 8-32 children on x86_64, ppc64le and s390x
 > systems (RHEL7.3 Beta). It happened usually within 20-30 minutes.

Weird. I'm doing 24/7 runs on one quad core and didn't hit it.
But I wonder if I was just fortunate enough that I had some children
always making progress even if N-1 were stuck.

	Dave
