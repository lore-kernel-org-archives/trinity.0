From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] fix divide by zero in random/taviso()
Date: Tue, 21 Jan 2014 14:47:57 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1401211441570.5901@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401171519070.6751@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1401171541490.6771@vincent-weaver-1.um.maine.edu> <20140117210356.GA10744@redhat.com> <CAKB9nXvQmAU-PXjqbezf7G5bWfrjMTD5LjoFnj98K8Tyy5eQ2Q@mail.gmail.com>
 <20140121190703.GA27774@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140121190703.GA27774@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: Andrew Honig <ahonig@google.com>, trinity@vger.kernel.org

On Tue, 21 Jan 2014, Dave Jones wrote:

> random.c:57:16: warning: Division by zero
>                 if (!temp) r %= temp;
>                            ~~^~~~~~~
> random.c:62:26: warning: Division by zero
>                 if (!temp) r |= rand() % temp;
>                                 ~~~~~~~^~~~~~
> 
> Vince, want to send a follow-up fix ?

Yes, brown-paper bag time.  Never trust "it compiles and runs" as 
testing for a bug that only shows up 1 in 4 billion times anyway.

I've copied the code into a test harness and actually ran it with code 
that returns zero more often to verify it works (after hacking things 
so gcc didn't "helpfully" optimize the zero generating code away).

---

The previous fix to the divide-by-zero bug in random/taviso()
(fea56c28830f "fix divide by zero in random/taviso()")
had the zero-checks inverted.  This meant the old div-by-zero bug
was still there, and worse, it meant that the number being generated
always had 32-bits of zeros in the bottom half on a 64-bit machine.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/random.c b/random.c
index 75fa868..38ed22f 100644
--- a/random.c
+++ b/random.c
@@ -54,12 +54,12 @@ static unsigned long taviso(void)
 
 	case 1:	temp = rand();
 		r = rand();
-		if (!temp) r %= temp;
+		if (temp) r %= temp;
 #if __WORDSIZE == 64
 		r <<= 32;
 
 		temp = rand();
-		if (!temp) r |= rand() % temp;
+		if (temp) r |= rand() % temp;
 #endif
 		break;
 
