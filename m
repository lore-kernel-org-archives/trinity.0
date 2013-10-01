From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] converted COLOR_ARG macro to a function
Date: Mon, 30 Sep 2013 21:10:34 -0400
Message-ID: <20131001011034.GA2140@redhat.com>
References: <alpine.DEB.2.02.1309301739430.17550@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309301739430.17550@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Mon, Sep 30, 2013 at 05:43:01PM -0700, Ildar Muslukhov wrote:
 > 
 > This patch converts COLOR_ARG macro to a function. The sole purpose is to 
 > make the code a bit more readable.
 > 
 > Signed-off-by: Ildar Muslukhov <ildarm@google.com>
 > 
 > ---
 >  include/log.h |   3 ++
 >  syscall.c     | 164 ++++++++++++++++++++++++++++++----------------------------
 >  2 files changed, 87 insertions(+), 80 deletions(-)
 > 
 > diff --git a/include/log.h b/include/log.h
 > index f3fc7c4..627985c 100644
 > --- a/include/log.h
 > +++ b/include/log.h
 > @@ -19,6 +19,9 @@
 >  #define WHITE if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_WHITE);
 >  #define CRESET if (monochrome == FALSE)	sptr += sprintf(sptr, "%s", ANSI_RESET);
 >  
 > +#define CYANPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_CYAN);
 > +#define CRESETPTR if (monochrome == FALSE)	*sptr += sprintf(*sptr, "%s", ANSI_RESET);
 
We only use CYANPTR once. Might as well just inline it ?

 > --- a/syscall.c
 > +++ b/syscall.c
 > @@ -41,14 +41,14 @@ long syscall32(int num_args, unsigned int call,
 >  
 >  	if (num_args <= 6) {
 >  		long __res;
 > -#if defined( __i386__)
 > +#if defined(__i386__)
 >  		__asm__ volatile (
 >  			"pushl %%ebp\n\t"
 >  			"movl %7, %%ebp\n\t"
 >  			"int $0x80\n\t"
 >  			"popl %%ebp\n\t"
 >  			: "=a" (__res)
 > -			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),"d" ((long)(a3)), "S" ((long)(a4)),"D" ((long)(a5)), "g" ((long)(a6))
 > +			: "0" (call), "b" ((long)(a1)), "c" ((long)(a2)), "d" ((long)(a3)), "S" ((long)(a4)), "D" ((long)(a5)), "g" ((long)(a6))
 >  			: "%ebp" /* mark EBP reg as dirty */
 >  			);
 >  #elif defined(__x86_64__)
 > @@ -58,7 +58,7 @@ long syscall32(int num_args, unsigned int call,
 >  			"int $0x80\n\t"
 >  			"popq %%rbp\n\t"
 >  			: "=a" (__res)
 > -			: "0" (call),"b" ((long)(a1)),"c" ((long)(a2)),"d" ((long)(a3)), "S" ((long)(a4)),"D" ((long)(a5)), "g" ((long)(a6))
 > +			: "0" (call), "b" ((long)(a1)), "c" ((long)(a2)), "d" ((long)(a3)), "S" ((long)(a4)), "D" ((long)(a5)), "g" ((long)(a6))
 >  			: "%rbp" /* mark EBP reg as dirty */
 >  			);
 >  #else
 > @@ -73,7 +73,7 @@ long syscall32(int num_args, unsigned int call,
 >  	UNUSED(a5);
 >  	UNUSED(a6);
 >  #endif
 > -		__syscall_return(long,__res);
 > +		__syscall_return(long, __res);
 >  	}
 
I suspect this belongs in a different diff ;)
 

Otherwise, looks ok.

	Dave
