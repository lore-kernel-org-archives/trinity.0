From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] syscall: Take SYSCALL_OFFSET into account
Date: Wed, 14 May 2014 11:22:09 -0400
Message-ID: <20140514152209.GA15614@redhat.com>
References: <1400067338-12416-1-git-send-email-markos.chandras@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400067338-12416-1-git-send-email-markos.chandras@imgtec.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: trinity@vger.kernel.org

On Wed, May 14, 2014 at 12:35:38PM +0100, Markos Chandras wrote:
 > MIPS and IA64 have their syscall tables starting at non-zero
 > offsets so take that into account when executing a sycall
 > otherwise trinity just fails with ENOSYS error messages.
 > 
 > Tested on MIPS 32/LE system.
 > 
 > Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
 > ---
 >  syscall.c | 5 +++--
 >  1 file changed, 3 insertions(+), 2 deletions(-)
 > 
 > diff --git a/syscall.c b/syscall.c
 > index 968962b..a1ccb6b 100644
 > --- a/syscall.c
 > +++ b/syscall.c
 > @@ -79,6 +79,7 @@ static long syscall32(unsigned int call,
 >  static unsigned long do_syscall(int childno, int *errno_saved)
 >  {
 >  	int nr = shm->syscall[childno].nr;
 > +	int call = nr + SYSCALL_OFFSET;
 >  	unsigned long a1, a2, a3, a4, a5, a6;
 >  	unsigned long ret = 0;
 >  
 > @@ -99,9 +100,9 @@ static unsigned long do_syscall(int childno, int *errno_saved)
 >  	errno = 0;
 >  
 >  	if (shm->syscall[childno].do32bit == FALSE)
 > -		ret = syscall(nr, a1, a2, a3, a4, a5, a6);
 > +		ret = syscall(call, a1, a2, a3, a4, a5, a6);
 >  	else
 > -		ret = syscall32(nr, a1, a2, a3, a4, a5, a6);
 > +		ret = syscall32(call, a1, a2, a3, a4, a5, a6);
 >  
 >  	*errno_saved = errno;

Oops. This was the intention of the code in mkcall() that calls
do_syscall().

152         /* Some architectures (IA64/MIPS) start their Linux syscalls
153          * At non-zero, and have other ABIs below.
154          */
155         call += SYSCALL_OFFSET;

Looking at that code closer, it seems that the code around line 193
will do the wrong thing on MIPS/IA64 because we've done this addition.

I'm wondering if just removing those lines I just quoted would be
the right thing to do (after applying your patch).

	Dave
