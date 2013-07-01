From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: wtf bug of the day.
Date: Mon, 01 Jul 2013 18:18:51 +1000
Message-ID: <1372666731.31133.2.camel@concordia>
References: <20130629022420.GA20808@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130629022420.GA20808@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Fri, 2013-06-28 at 22:24 -0400, Dave Jones wrote:
> I've beem holding off on cutting a new release of trinity until I've nailed
> this one last bug[1].
> 
> When it happens, the watchdog process is in Z state, and the child processes
> are all blocked on sockets (and no progress is made because the watchdog died).
> 
> In the one case I've managed to catch a core from the watchdog, it makes no damn sense..
> 
> Program terminated with signal 8, Arithmetic exception.
> #0  check_shm_sanity () at watchdog.c:47
> 	if (shm->running_childs == 0)
> 
> what the hell does that even mean ?
> 
> 'shm' is valid, shm->running_childs is '4'.
> 
> Any ideas ?

You could add a SIGFPE handler and check whether it's coming from
another process or not.

Something like:

void sighandler(int signal, siginfo_t *siginfo, void *ucontext)
{
	printf("Took signal %d\n", signal);
	printf("Sent by process %d (uid %d)\n",
		siginfo->si_pid, siginfo->si_uid);
}

struct sigaction sigfpe_action = {
	.sa_sigaction = sighandler,
	.sa_flags = SA_SIGINFO,
};

if (sigaction(SIGFPE, &sigfpe_action, NULL)) {
	perror("sigaction");
	return 1;
}


cheers
