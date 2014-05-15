From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] syscall: Take SYSCALL_OFFSET into account
Date: Thu, 15 May 2014 11:23:05 -0400
Message-ID: <20140515152305.GA32618@redhat.com>
References: <1400067338-12416-1-git-send-email-markos.chandras@imgtec.com>
 <20140514152209.GA15614@redhat.com>
 <53747A20.1020305@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53747A20.1020305@imgtec.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markos Chandras <Markos.Chandras@imgtec.com>
Cc: trinity@vger.kernel.org

On Thu, May 15, 2014 at 09:26:08AM +0100, Markos Chandras wrote:

 > > I'm wondering if just removing those lines I just quoted would be
 > > the right thing to do (after applying your patch).
 > > 
 > 
 > Removing these four lines may work but it will break the following:
 > 
 > 209                 output(1, "%s (%d) returned ENOSYS, marking as
 > inactive.\n",
 > 210                         entry->name, call);
 > 
 > 'call' will have the syscall (shm->syscall[childno].nr) number without
 > the offset which will simply print the wrong syscall number for mips and
 > ia64.

You're right. I just fixed this up in git after removing those other
lines yesterday.

 > I am not that familiar with the code yet to be able to tell whether the
 > 'search_syscall_table' or 'deactivate_syscall' functions need the offset
 > as well or not.

They should be safe, as they use/return the number as index into the tables
we constructed.  But shout if something looks odd, and I'll look into it.

	Dave
