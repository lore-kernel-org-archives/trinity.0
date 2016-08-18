From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: Randomly reopening file descriptors
Date: Thu, 18 Aug 2016 11:43:13 -0400
Message-ID: <20160818154313.7k7hyhckkjib5m7i@codemonkey.org.uk>
References: <57B591D0.7040808@oracle.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57B591D0.7040808@oracle.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: trinity@vger.kernel.org

On Thu, Aug 18, 2016 at 12:45:36PM +0200, Vegard Nossum wrote:
 > Hi,
 > 
 > I know we're not supposed to send feature requests, so I'm going to
 > thinly veil this feature request as a request for pointers on how to
 > make the change myself.
 > 
 > I've discovered that a few bugs only appear within the first few minutes
 > of trinity starting up -- in particular, proc file and socket bugs. If
 > the bug hasn't showed up within the first few minutes of running, no
 > matter how many hours or days it runs for, the bug will not show up at
 > all.
 > 
 > I *think* this is because a lot of system calls on these fds put the
 > file/socket in a state where it can't get back to its original state.
 > For sockets, for example, there is no way to "undo" a listen() call;
 > once it's in a listening state it will remain in a listening state for
 > the duration of its lifetime.
 
I'm currently reworking the socket code in particular, and one of the things
I want to do is move the listen() stuff into the child processes.
But that's incidental to the idea you propose..

 > Therefore I think it would be useful if the parent process occasionally
 > reopened/recreated its file descriptors.
 > 
 > AFAICT the only things that currently open file descriptors are:
 > 
 > - open_fds() called ONCE in main() before entering the main loop
 > 
 > - get_new_random_fd() as a syscall argument, however this does not
 >    replace existing fds and so it will only be used for a single syscall
 >    before getting closed again
 > 
 > I may be wrong about any or all of the above, any pointers on how to
 > best randomly replace the persistent/global fds would be appreciated.

Which I think makes sense to do.
A long time ago, Trinity did actually do something like this.
The last parts of it got removed around two years ago in 55eb1a867fa4ae88597743b91a57fe0d2257f1a8
A lot of stuff moved around/changed since then, so it's not simple
to resurrect as-is, but fundamentally, I think we just need something
we can plug into main_loop() to..

  - pick a random fd_provider
  - close() all (or maybe just some?) of the shm->objects[] for that provider
  - re-call the ->open() for that provider.

There may be some subtle bugs to work out in the ->open()'s of some providers
because they were written without this use-case in mind, but they should be
fairly trivial to fix up.

The only real thing missing is the second part, where we go from provider to
shm object cache.  We can either add a new member to the fd_provider struct
to point to the shm objects, or we can add new functions ->reopen etc
to each provider.  The former is probably less code, and more generic/future-proof.

Feel free to ask for more pointers if you need them.

	Dave
