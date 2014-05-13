From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Fwd: Trinity 1.4 tarball release.
Date: Tue, 13 May 2014 16:43:48 +1000
Message-ID: <1399963428.2395.2.camel@concordia>
References: <20140512174332.GA3345@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20140512174332.GA3345@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Mon, 2014-05-12 at 13:43 -0400, Dave Jones wrote:
> heh, I knew I'd forget something. Hopefully "cc'ing the trinity list"
> was the only thing this time around..


Hi Dave,

I gave this spin on a system of mine here.

I'm consistently ending up with a watchdog that is spinning using 100% cpu.

strace shows it spinning calling kill:

kill(17833, SIG_0)                      = -1 ESRCH (No such process)
kill(17833, SIG_0)                      = -1 ESRCH (No such process)
kill(17833, SIG_0)                      = -1 ESRCH (No such process)
kill(17833, SIG_0)                      = -1 ESRCH (No such process)
...

Which gdb agrees with:

(gdb) bt
#0  0x1001c790 in kill@plt ()
#1  0x10001984 in __check_main () at watchdog.c:158
#2  0x10010510 in check_main_alive () at watchdog.c:185
#3  watchdog () at watchdog.c:407
#4  init_watchdog () at watchdog.c:484
#5  0x10001d04 in main (argc=1, argv=<optimized out>) at trinity.c:128


It's looping around:

183			while (shm->mainpid != 0) {
(gdb) n
185				ret = __check_main();
(gdb)
186				if (ret == TRUE) {
(gdb)
183			while (shm->mainpid != 0) {
(gdb)
185				ret = __check_main();
(gdb)
186				if (ret == TRUE) {
(gdb)
183			while (shm->mainpid != 0) {
(gdb)
185				ret = __check_main();
(gdb)
186				if (ret == TRUE) {


shm->mainpid is 17833, which agrees with strace, and that process is indeed
no longer running.

We are bailing out of __check_main() before clearing shm->mainpid because we
see that we are already exiting.

        if (ret == -1) {
                /* Are we already exiting ? */
                if (shm->exit_reason != STILL_RUNNING)
                        return FALSE;

                /* No. Check what happened. */
                if (errno == ESRCH) {


161			if (shm->exit_reason != STILL_RUNNING)
(gdb) print shm->exit_reason
$6 = EXIT_FORK_FAILURE

It looks like the only other place shm->mainpid is written is in
trinity.c:main(), which is dead. So we are stuck forever as far as I can tell.


The last thing in trinity.log is:

[main] couldn't create child! (Cannot allocate memory)

From main.c:69:

	output(0, "couldn't create child! (%s)\n", strerror(errn    o));
	shm->exit_reason = EXIT_FORK_FAILURE;
	exit(EXIT_FAILURE);


So we exited directly and didn't let the code in main() clear shm->mainpid.

Not sure what the correct fix is. We could drop the check of shm->exit_reason
in __check_main(), but presumably that is there for a good reason.

cheers

