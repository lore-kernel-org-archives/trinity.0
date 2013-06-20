From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [patch 1/2] add init() function to struct syscall
Date: Thu, 20 Jun 2013 14:15:15 +1000
Message-ID: <1371701715.21846.33.camel@concordia>
References: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
	 <20130620024052.GB24618@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130620024052.GB24618@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, trinity@vger.kernel.org

On Wed, 2013-06-19 at 22:40 -0400, Dave Jones wrote:
> On Wed, Jun 19, 2013 at 10:09:09PM -0400, Vince Weaver wrote:
>  > 
>  > While working on the perf_event_open() sysfs init problem, I was wondering
>  > if it might be easier if we added the possibility of an init() routine
>  > to each syscall structure.  That way trinity can support doing setup
>  > before fuzzing begins.
>  > 
>  > Below is a quick patch implementing this, it seems to work but I still 
>  > don't have the best grasp of trinity internals.
>  > 
>  > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
>  > 
>  > diff --git a/include/syscall.h b/include/syscall.h
>  > index ccbe436..a58a506 100644
>  > --- a/include/syscall.h
>  > +++ b/include/syscall.h
>  > @@ -32,6 +32,7 @@ struct arglist {
>  >  struct syscall {
>  >  	void (*sanitise)(int childno);
>  >  	void (*post)(int);
>  > +	int (*init)(void);
>  >  
>  >  	unsigned int number;
>  >  	const char name[80];
> 
> Nothing wrong with this patch, but it's highlighted a bug that's been in trinity
> for a while.  Changes to the syscall struct should cause everything in syscalls/*
> to be rebuilt. But somehow the dependency magic in the Makefile doesn't pick it up.
> 
> Anyone with better make-fu than me want to take a stab at that ?

I'm not a make expert, but I think it's because it's looking for .deps/syscalls/foo.d
whereas we generate .deps/foo.d

This patch works for me, touching include/syscall.h rebuilds a few
things and then everything under syscalls.

I guess the other approach would be to flatten the directory structure
where we include the .d files.

cheers


diff --git a/Makefile b/Makefile
index f5a35b6..e64d87d 100644
--- a/Makefile
+++ b/Makefile
@@ -63,14 +63,11 @@ trinity: test $(OBJS) $(HEADERS)
        $(QUIET_CC)$(CC) $(CFLAGS) -o trinity $(OBJS)
        @mkdir -p tmp
 
-df = $(DEPDIR)/$(*F)
+df = $(DEPDIR)/$(*D)/$(*F)
 
-# FIXME:
-# Dependancy information for .c files in subdirs seems to be broken.
-# Example: touch include/sanitise.h should cause syscalls/*.c to be rebuilt.
-#
 %.o : %.c
        $(QUIET_CC)$(CC) $(CFLAGS) -o $@ -c $<
+       @mkdir -p $(DEPDIR)/$(*D)
        @gcc -MM $(CFLAGS) $*.c > $(df).d
        @mv -f $(df).d $(df).d.tmp
        @sed -e 's|.*:|$*.o:|' <$(df).d.tmp > $(df).d
@@ -83,7 +80,7 @@ clean:
        @rm -f core.*
        @rm -f trinity
        @rm -f tags
-       @rm -f $(DEPDIR)/*.d
+       @rm -rf $(DEPDIR)/*
 
 devel:
        @perl -p -i -e 's/^#CFLAGS \+\= -Werror/CFLAGS += -Werror/' Makefile

