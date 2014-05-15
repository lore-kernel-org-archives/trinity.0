From: Markos Chandras <Markos.Chandras@imgtec.com>
Subject: Re: [PATCH] syscall: Take SYSCALL_OFFSET into account
Date: Thu, 15 May 2014 09:26:08 +0100
Message-ID: <53747A20.1020305@imgtec.com>
References: <1400067338-12416-1-git-send-email-markos.chandras@imgtec.com> <20140514152209.GA15614@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140514152209.GA15614@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 05/14/2014 04:22 PM, Dave Jones wrote:
> On Wed, May 14, 2014 at 12:35:38PM +0100, Markos Chandras wrote:
>  > MIPS and IA64 have their syscall tables starting at non-zero
>  > offsets so take that into account when executing a sycall
>  > otherwise trinity just fails with ENOSYS error messages.
>  > 
>  > Tested on MIPS 32/LE system.
>  > 
>  > Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>  > ---
>  >  syscall.c | 5 +++--
>  >  1 file changed, 3 insertions(+), 2 deletions(-)
>  > 
>  > diff --git a/syscall.c b/syscall.c
>  > index 968962b..a1ccb6b 100644
>  > --- a/syscall.c
>  > +++ b/syscall.c
>  > @@ -79,6 +79,7 @@ static long syscall32(unsigned int call,
>  >  static unsigned long do_syscall(int childno, int *errno_saved)
>  >  {
>  >  	int nr = shm->syscall[childno].nr;
>  > +	int call = nr + SYSCALL_OFFSET;
>  >  	unsigned long a1, a2, a3, a4, a5, a6;
>  >  	unsigned long ret = 0;
>  >  
>  > @@ -99,9 +100,9 @@ static unsigned long do_syscall(int childno, int *errno_saved)
>  >  	errno = 0;
>  >  
>  >  	if (shm->syscall[childno].do32bit == FALSE)
>  > -		ret = syscall(nr, a1, a2, a3, a4, a5, a6);
>  > +		ret = syscall(call, a1, a2, a3, a4, a5, a6);
>  >  	else
>  > -		ret = syscall32(nr, a1, a2, a3, a4, a5, a6);
>  > +		ret = syscall32(call, a1, a2, a3, a4, a5, a6);
>  >  
>  >  	*errno_saved = errno;
> 
> Oops. This was the intention of the code in mkcall() that calls
> do_syscall().
> 
> 152         /* Some architectures (IA64/MIPS) start their Linux syscalls
> 153          * At non-zero, and have other ABIs below.
> 154          */
> 155         call += SYSCALL_OFFSET;
> 
> Looking at that code closer, it seems that the code around line 193
> will do the wrong thing on MIPS/IA64 because we've done this addition.
> 
> I'm wondering if just removing those lines I just quoted would be
> the right thing to do (after applying your patch).
> 
> 	Dave
> 
Hi Dave,

Removing these four lines may work but it will break the following:

209                 output(1, "%s (%d) returned ENOSYS, marking as
inactive.\n",
210                         entry->name, call);

'call' will have the syscall (shm->syscall[childno].nr) number without
the offset which will simply print the wrong syscall number for mips and
ia64.

I am not that familiar with the code yet to be able to tell whether the
'search_syscall_table' or 'deactivate_syscall' functions need the offset
as well or not.

-- 
markos
