From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Randomly reopening file descriptors
Date: Thu, 18 Aug 2016 12:45:36 +0200
Message-ID: <57B591D0.7040808@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: trinity@vger.kernel.org

Hi,

I know we're not supposed to send feature requests, so I'm going to
thinly veil this feature request as a request for pointers on how to
make the change myself.

I've discovered that a few bugs only appear within the first few minutes
of trinity starting up -- in particular, proc file and socket bugs. If
the bug hasn't showed up within the first few minutes of running, no
matter how many hours or days it runs for, the bug will not show up at
all.

I *think* this is because a lot of system calls on these fds put the
file/socket in a state where it can't get back to its original state.
For sockets, for example, there is no way to "undo" a listen() call;
once it's in a listening state it will remain in a listening state for
the duration of its lifetime.

Therefore I think it would be useful if the parent process occasionally
reopened/recreated its file descriptors.

AFAICT the only things that currently open file descriptors are:

- open_fds() called ONCE in main() before entering the main loop

- get_new_random_fd() as a syscall argument, however this does not
   replace existing fds and so it will only be used for a single syscall
   before getting closed again

I may be wrong about any or all of the above, any pointers on how to
best randomly replace the persistent/global fds would be appreciated.


Vegard
