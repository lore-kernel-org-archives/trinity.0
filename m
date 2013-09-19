From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: Reproducible run and binary logs (ideas)
Date: Thu, 19 Sep 2013 10:04:13 -0700
Message-ID: <CAEGbLtuzS8tRUhAizuHrmDT2okrhMb8DTP+U1S8U1e5E1U=WCg@mail.gmail.com>
References: <CAEGbLtsg8_xLx9YvdrZ-gLWR4UqSQ+DT4mzEV9BfGnf-uHxDjQ@mail.gmail.com>
	<20130919150746.GA2416@redhat.com>
	<CAEGbLtvKqXuGNvFCTTkjL5pr0xKeXrWem36cFYrXBrq_5hLVNw@mail.gmail.com>
	<20130919162148.GA8528@redhat.com>
	<alpine.DEB.2.10.1309191240250.2666@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=prf+1VCznH+v5Si5NVVjGM5BvnN/kyXrBAENTpaE6Pg=;
        b=DEBogdWJIhDkDRBBmbKZqzsfS02sJcb06wJblOPzZHOa1qwvyRhE5YrwjVPIPmloL0
         fxUvahx3BOUc6qb3yqRoj33VHcW50fu3rrkS9X5LyHFVKbCfOMU1QPkWZj3lQbO+txNr
         WKBAX7l0mw5JYWVF2Axq7bTkTGUoinxwU6IrR8HW+A6BbmUy5SVAyE3TlQ7qqL1YH+xa
         hLmkryDS0ZukvsSQ4qPHXIc4dSCkX+r8cbtC/VoK8IQ5IRa5R+eVhYclWBZZ288PuShj
         3OJeoSKpRy8AtpupadWkUVWUwGkcuUC8nCa5MCq3VpPrYxXahr4Ce6kSjuDwI2f6Rjv9
         jCPQ==
In-Reply-To: <alpine.DEB.2.10.1309191240250.2666@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

Thanks Vince,

Will take a look at it.


On Thu, Sep 19, 2013 at 9:49 AM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> On Thu, 19 Sep 2013, Dave Jones wrote:
>
>> It might be worth looking at Vince's perf fuzzer to see what he's done there
>> for bisecting/generating test cases.
>
> my perf_fuzzer doesn't do anything that complicated.
>
> In its current setup it only has one thread, which occasionally forks off
> a child but it always kills the child before forking off another.
>
> I find the run-to-run reproducibility of traces to be surprisingly
> consistent when given the same random seed.  Even hundreds of thousands
> of syscalls in I can usually hit the same bugs at roughly the same
> syscall count.
>
> I find this suprising because when perf events are involved nothing is
> deterministic; if you are measuring things like cycles with overflow, the
> cycle count is going to depend on what else is going on in the system, and
> if your overflow handler consumes randomness (hard because rand() isn't
> signal-handler safe, but possible with a few hacks) you'd expect things ro
> diverge.
>
> As for bisecting, my major problem is dependent syscalls, something that
> might not be as big an issue on trinity.  The way perf_fuzzer is set up
> you open an fd with perf_event_open(), then lots of other syscalls act on
> the fd.  So if your bisect happens to cut off the open of the fd, then
> all subsequent dependent syscalls fail.  I don't have a good automatic
> solution to that, I've so far been placing the bisect points by hand and
> just having the replayer be robust in cases where invalid dependent
> syscalls appear in the trace.
>
> perf_fuzzer also has a somewhat human-readable log format, which wastes
> disk space but makes it easier to do somewhat manual bisects using a text
> editor.
>
> Vince
>
>
>
>
>
>
