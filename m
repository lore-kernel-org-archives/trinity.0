From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [patch 1/2] add init() function to struct syscall
Date: Thu, 20 Jun 2013 19:33:21 +1000
Message-ID: <1371720801.1171.2.camel@concordia>
References: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
	 <20130620024052.GB24618@redhat.com> <1371701715.21846.33.camel@concordia>
	 <20130620044810.GA28377@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130620044810.GA28377@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, trinity@vger.kernel.org

On Thu, 2013-06-20 at 00:48 -0400, Dave Jones wrote:
> On Thu, Jun 20, 2013 at 02:15:15PM +1000, Michael Ellerman wrote:
>  > On Wed, 2013-06-19 at 22:40 -0400, Dave Jones wrote:
>  > > Nothing wrong with this patch, but it's highlighted a bug that's been in trinity
>  > > for a while.  Changes to the syscall struct should cause everything in syscalls/*
>  > > to be rebuilt. But somehow the dependency magic in the Makefile doesn't pick it up.
>  > > 
>  > > Anyone with better make-fu than me want to take a stab at that ?
>  > 
>  > I'm not a make expert, but I think it's because it's looking for .deps/syscalls/foo.d
>  > whereas we generate .deps/foo.d
> 
> Bah, I knew it would be something that simple that I was overlooking.

Ain't it always :)

>  > This patch works for me, touching include/syscall.h rebuilds a few
>  > things and then everything under syscalls.
> 
> Looks good to me.
> 
>  > I guess the other approach would be to flatten the directory structure
>  > where we include the .d files.
>  
> That sounds like it would be a mess if we're unfortunate enough to have the same
> name file in 2 dirs.  Your patch seems to do the right thing, so I'll
> just apply that and move on.

Yeah that's why I went with that approach.

Turns out we already had dupes:

$ find . -name random.c -o -name socket.c -o -name watchdog.c
./watchdog.c
./ioctls/watchdog.c
./ioctls/socket.c
./syscalls/socket.c
./ioctls/random.c
./random.c


cheers
