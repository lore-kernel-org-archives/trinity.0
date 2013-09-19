From: Dave Jones <davej@redhat.com>
Subject: Re: Reproducible run and binary logs (ideas)
Date: Thu, 19 Sep 2013 12:21:48 -0400
Message-ID: <20130919162148.GA8528@redhat.com>
References: <CAEGbLtsg8_xLx9YvdrZ-gLWR4UqSQ+DT4mzEV9BfGnf-uHxDjQ@mail.gmail.com>
 <20130919150746.GA2416@redhat.com>
 <CAEGbLtvKqXuGNvFCTTkjL5pr0xKeXrWem36cFYrXBrq_5hLVNw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtvKqXuGNvFCTTkjL5pr0xKeXrWem36cFYrXBrq_5hLVNw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Thu, Sep 19, 2013 at 09:03:41AM -0700, Ildar Muslukhov wrote:
 > Ok, lets me just make some tests on that. But what about synching
 > multiple children processes? And what do you make of a binary log,
 > that allows to do that.
 > 
 > Ildar

So while things like synchronising threads are a nice idea, I'm not
really sweating it, because I don't think it's a major factor in
the lack of reproducability right now. There are probably a whole bunch
of other factors that have a higher impact.  Also, it's not as simple
a problem as just starting threads at a certain time, because they
can go out of sync later. Think about what happens if one of the syscalls
we run does a write() of a gigabyte of data. There's no deterministic
time that has to complete, and depending on the filesystem/mount options in use, we could
go away for a while until that write() completes while the filesystem does
tree rebalancing or whatever..  On a subsequent run, that same write() might
return almost instantly because the filesystem doesn't need to do as much
book-keeping. And that's just write(). Other syscalls have similar non-deterministic
runtimes.

It's a tricky problem, and one that I think we're probably better off not trying
to solve completely, because I don't think we'll ever recreate the exact conditions across two runs.
I'm not saying it's all useless to even try and recreate conditions, but that perfection
isn't really attainable, and some of those ideas may be more realistic than others.

Of all the bugs that trinity has found, I can only recall one that
actually had multi-thread interaction (involving ecryptfs fd passing,
which was actually a problem between main process & child, rather than child<->child)

We might be better off just treating the individual trinity child processes
as standalone instances, and concentrating on taking a logfile from each of those,
and working on strategies to extract the useful info from them for re-run them
as a single process, because 99.9% of the time, what the other child processes are
doing is irrelevant to the bug.

It might be worth looking at Vince's perf fuzzer to see what he's done there
for bisecting/generating test cases.

	Dave
