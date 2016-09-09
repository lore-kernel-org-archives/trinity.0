From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [bug] child processes stall forever and don't get killed
Date: Fri, 9 Sep 2016 10:16:17 -0400 (EDT)
Message-ID: <907265021.1542338.1473430577178.JavaMail.zimbra@redhat.com>
References: <1139550397.1201862.1473415639192.JavaMail.zimbra@redhat.com> <210078090.1267922.1473417016250.JavaMail.zimbra@redhat.com> <20160909133236.qm32kmsz3wfby53y@codemonkey.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20160909133236.qm32kmsz3wfby53y@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org



----- Original Message -----
> From: "Dave Jones" <davej@codemonkey.org.uk>
> To: "Jan Stancek" <jstancek@redhat.com>
> Cc: trinity@vger.kernel.org
> Sent: Friday, 9 September, 2016 3:32:36 PM
> Subject: Re: [bug] child processes stall forever and don't get killed
> 
> On Fri, Sep 09, 2016 at 06:30:16AM -0400, Jan Stancek wrote:
>  > Hi,
>  > 
>  > I'm running v1.6-643-gecea2b06d5f3 on RHEL7.3 and I'm seeing an issue
>  > where all child processes stall and none of them is getting killed.
>  > They are usually in a syscalls like read, recv, nanosleep, etc.
>  > 
>  > I suspect this commit introduced the problem, because any syscall
>  > that started but not completed is now considered to "make progress":
>  > 
>  >   commit ecf6dfd83d4c886d78d4605163cb8c3f1728db62
>  >   Author: Dave Jones <davej@codemonkey.org.uk>
>  >   Date:   Fri Aug 12 15:05:01 2016 -0400
>  > 
>  >     if we haven't done a syscall yet, treat child as "making progress".
>  >     
>  >     Chances are that we haven't been scheduled because some other
>  >     children are hogging the cpu.
>  > 
>  > I'm seeing more the opposite of what commit above says. Most CPUs
>  > are idle, because N-1 children are stuck in recv/read/...
>  > and last child manages to keep going. Then by a chance it also hits
>  > a syscall that doesn't complete and system stays idle
>  > (after ~hour I gave up waiting).
> 
> Need to think some more on this, but as a quick guess...
> try replacing the <= BEFORE with < BEFORE

I've started new test with patch above reverted and that looks good
so far. No stalls after 1 hour. Previously it stalled after ~20-30
minutes. I noticed that when syscall stat messages (those which show
number of iteration) stopped appearing.

> 
> I'll try and find some time to look into this soon. I'm surprised I
> haven't also seen it happen though.  How many CPUs & how many child
> processes ?

Anywhere from 2-8 CPUs, 8-32 children on x86_64, ppc64le and s390x
systems (RHEL7.3 Beta). It happened usually within 20-30 minutes.

Regards,
Jan

> 
> 	Dave
> 
> 
