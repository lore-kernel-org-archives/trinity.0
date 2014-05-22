From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Thu, 22 May 2014 13:43:15 +1000
Message-ID: <1400730195.14864.6.camel@concordia>
References: <20140512174332.GA3345@redhat.com>
	 <1399963428.2395.2.camel@concordia> <20140513140006.GA32674@redhat.com>
	 <1400052389.8826.1.camel@concordia> <20140514133522.GA10167@redhat.com>
	 <1400726436.14864.4.camel@concordia> <20140522034056.GA21777@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140522034056.GA21777@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, 2014-05-21 at 23:40 -0400, Dave Jones wrote:
> On Thu, May 22, 2014 at 12:40:36PM +1000, Michael Ellerman wrote:
>  
>  > Sorry I didn't get back to you on this. I've been chasing a bug that trinity
>  > found for us.
>  > 
>  > Running aae6d6a I've seen this once, but only once:
>  > 
>  > [watchdog] Sanity check failed! Found pid 1885550132!
>  > [watchdog] problem checking on pid 112 (1:Operation not permitted)
>  > [watchdog] pid 1885550132 has disappeared (oom-killed maybe?). Reaping.
>  > [watchdog] pid 678326126 has disappeared (oom-killed maybe?). Reaping.
>  > [watchdog] pid 1697185792 has disappeared (oom-killed maybe?). Reaping.
>  > [watchdog] Reaped 3 dead children
>  > Killed
> 
> If it happens again, check /proc/sys/kernel/pid_max.
> I wonder if something scribbled in there.

It hasn't happened again, but I haven't rebooted since it did, and I still have:

$ cat /proc/sys/kernel/pid_max
65536

> Though looking at the pids in the dump above, I wonder if there's
> something more screwed up, like we corrupted the ptrs to the pid map
> in the shm.

Yeah it looks more like that to me.

cheers


