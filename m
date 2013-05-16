From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH trinity] net: add generation of semi-random BPF filters
Date: Thu, 16 May 2013 12:26:19 -0400
Message-ID: <20130516162619.GA22510@redhat.com>
References: <1368698056-411-1-git-send-email-dborkman@redhat.com>
 <20130516135547.GA7393@redhat.com>
 <51950355.7090602@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51950355.7090602@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org

On Thu, May 16, 2013 at 06:03:33PM +0200, Daniel Borkmann wrote:
 > On 05/16/2013 03:55 PM, Dave Jones wrote:
 > > On Thu, May 16, 2013 at 11:54:16AM +0200, Daniel Borkmann wrote:
 > >   > BPF filters are used in networking and in application sand-boxing
 > >   > and even have a arch-dependant JIT compiler in the kernel, so add
 > >   > a more detailed semi-random BPF generator.
 > >   >
 > >   > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
 > >   > ---
 > >   >  Compile-tested only!
 > >
 > > Very nice.
 > >
 > > merged and pushed.
 > 
 > Thanks, just for the record, in case someone might need this e.g. when
 > trinity hits here ... in the kernel source tree under tools/net/ is a
 > BPF JIT disassembler.

Hmm, I suppose at some point I should add some way of dumping page_rand too.
Given that can be changed by multiple processes at the same time though,
it's a bit of a mess. Also it would be spamming the hell out of the logs.

Perhaps instead of page_rand, the bpf code should do it's own allocation
and then we have a pre-do-syscall hook to do hexdumping of allocations.

This is another case where we really need some post-syscall cleanup operations
too, to free the allocation. (There are a few of these, grep for leak in syscalls/)

I'm probably going to cut a 1.2 release later this month when I get back
from vacation, because it's been a while, and things are pretty quiet right now,
and this stuff is probably going to be for after that.

	Dave
