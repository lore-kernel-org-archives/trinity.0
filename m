From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [bug] child processes stall forever and don't get killed
Date: Fri, 9 Sep 2016 09:32:36 -0400
Message-ID: <20160909133236.qm32kmsz3wfby53y@codemonkey.org.uk>
References: <1139550397.1201862.1473415639192.JavaMail.zimbra@redhat.com>
 <210078090.1267922.1473417016250.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <210078090.1267922.1473417016250.JavaMail.zimbra@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Stancek <jstancek@redhat.com>
Cc: trinity@vger.kernel.org

On Fri, Sep 09, 2016 at 06:30:16AM -0400, Jan Stancek wrote:
 > Hi,
 > 
 > I'm running v1.6-643-gecea2b06d5f3 on RHEL7.3 and I'm seeing an issue
 > where all child processes stall and none of them is getting killed.
 > They are usually in a syscalls like read, recv, nanosleep, etc.
 > 
 > I suspect this commit introduced the problem, because any syscall
 > that started but not completed is now considered to "make progress":
 > 
 >   commit ecf6dfd83d4c886d78d4605163cb8c3f1728db62
 >   Author: Dave Jones <davej@codemonkey.org.uk>
 >   Date:   Fri Aug 12 15:05:01 2016 -0400
 > 
 >     if we haven't done a syscall yet, treat child as "making progress".
 >     
 >     Chances are that we haven't been scheduled because some other
 >     children are hogging the cpu.
 > 
 > I'm seeing more the opposite of what commit above says. Most CPUs
 > are idle, because N-1 children are stuck in recv/read/...
 > and last child manages to keep going. Then by a chance it also hits
 > a syscall that doesn't complete and system stays idle
 > (after ~hour I gave up waiting).

Need to think some more on this, but as a quick guess...
try replacing the <= BEFORE with < BEFORE

I'll try and find some time to look into this soon. I'm surprised I
haven't also seen it happen though.  How many CPUs & how many child
processes ?

	Dave
