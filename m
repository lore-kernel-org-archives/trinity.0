From: Dave Jones <davej@redhat.com>
Subject: Re: [patch 1/2] add init() function to struct syscall
Date: Wed, 19 Jun 2013 22:40:52 -0400
Message-ID: <20130620024052.GB24618@redhat.com>
References: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Wed, Jun 19, 2013 at 10:09:09PM -0400, Vince Weaver wrote:
 > 
 > While working on the perf_event_open() sysfs init problem, I was wondering
 > if it might be easier if we added the possibility of an init() routine
 > to each syscall structure.  That way trinity can support doing setup
 > before fuzzing begins.
 > 
 > Below is a quick patch implementing this, it seems to work but I still 
 > don't have the best grasp of trinity internals.
 > 
 > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
 > 
 > diff --git a/include/syscall.h b/include/syscall.h
 > index ccbe436..a58a506 100644
 > --- a/include/syscall.h
 > +++ b/include/syscall.h
 > @@ -32,6 +32,7 @@ struct arglist {
 >  struct syscall {
 >  	void (*sanitise)(int childno);
 >  	void (*post)(int);
 > +	int (*init)(void);
 >  
 >  	unsigned int number;
 >  	const char name[80];

Nothing wrong with this patch, but it's highlighted a bug that's been in trinity
for a while.  Changes to the syscall struct should cause everything in syscalls/*
to be rebuilt. But somehow the dependency magic in the Makefile doesn't pick it up.

Anyone with better make-fu than me want to take a stab at that ?

	Dave
