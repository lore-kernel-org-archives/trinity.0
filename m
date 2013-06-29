From: Dave Jones <davej@redhat.com>
Subject: wtf bug of the day.
Date: Fri, 28 Jun 2013 22:24:20 -0400
Message-ID: <20130629022420.GA20808@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

I've beem holding off on cutting a new release of trinity until I've nailed
this one last bug[1].

When it happens, the watchdog process is in Z state, and the child processes
are all blocked on sockets (and no progress is made because the watchdog died).

In the one case I've managed to catch a core from the watchdog, it makes no damn sense..

Program terminated with signal 8, Arithmetic exception.
#0  check_shm_sanity () at watchdog.c:47
	if (shm->running_childs == 0)

what the hell does that even mean ?

'shm' is valid, shm->running_childs is '4'.

Any ideas ?

	Dave

[1] Until the next bug.
