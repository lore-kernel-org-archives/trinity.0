From: Dave Jones <davej@redhat.com>
Subject: Re: msgrcv (70) returned ENOSYS, marking as inactive.
Date: Thu, 13 Jun 2013 16:33:57 -0400
Message-ID: <20130613203357.GB32137@redhat.com>
References: <CA+ydwtrxkFecyx5mK_ogvV+MP+iHmTFYySLXRjHOT0cZQmeidw@mail.gmail.com>
 <20130613201553.GA32137@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130613201553.GA32137@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: trinity@vger.kernel.org

On Thu, Jun 13, 2013 at 04:15:53PM -0400, Dave Jones wrote:
 > On Thu, Jun 13, 2013 at 10:41:30PM +0300, Tommi Rantala wrote:
 >  > Latest trinity from git is constantly complaining:
 > 
 > weird.
 > 
 >  > [32492] Random reseed: 3901037224
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > [watchdog] 200253 iterations. [F:161784 S:38468]
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 >  > msgrcv (70) returned ENOSYS, marking as inactive.
 > 
 > puzzling.  this should (obviously) only occur once.
 > Maybe it's happening once per thread at the same time,
 > so they're all racing. (I should add some locking around
 > the modifications of the syscall table I suppose).

Something that's even more puzzling about this..
What are the odds all threads hit that at the same time
(unless you did -C msgrcv, which it doesn't look like you
 did from the core dump)

I wonder if I've broken seeding again.
Leave logging enabled, and compare a couple of the child logs,
just to make sure they're doing different syscalls.

Would be surprised though, the only thing remotely relevant
that changed is yesterdays rand32 changes in 7d86b1ca5ddc1ac04468d6ee7a0a74e931b67dae

	Dave
