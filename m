From: Dave Jones <davej@redhat.com>
Subject: Re: sched_rr_get_interval NULL pointer OOPS
Date: Fri, 24 Jan 2014 16:00:52 -0500
Message-ID: <20140124210052.GB6838@redhat.com>
References: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Jan 24, 2014 at 10:55:56PM +0200, Tommi Rantala wrote:
 > Hello,
 > 
 > Trinity triggered the following bug in two separate qemu virtual
 > machines after fuzzing v3.13-3995-g0dc3fd0 for a day or two. I have
 > not been running Trinity in a while, so no idea if this is a
 > regression or not.
 
Probably been there a while. I noticed on Tuesday that I hadn't annotated
the 'policy' argument to sched_setscheduler().  Now that it's passing sensible
arguments, I'm not surprised there's some fallout if subsequent syscalls
call misc scheduler functions.

	Dave
