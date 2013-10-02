From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Wed, 2 Oct 2013 16:57:33 -0400
Message-ID: <20131002205733.GA8531@redhat.com>
References: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
 <20131002151244.GA10872@redhat.com>
 <CAEGbLtv4wtaRuTVDPxpQcg0WWv2jDaa59vpX5MHTWe=gz-zBoQ@mail.gmail.com>
 <20131002164337.GA17276@redhat.com>
 <CAEGbLtuTi3BZffyGLahgGDVp2YhqWMPwY6VLUOBdnfnVzZDeQQ@mail.gmail.com>
 <20131002181537.GA30862@redhat.com>
 <CAEGbLttVfFEc0-LNGPYfFthQwx7j5ME38R8a4uCGa8NNWaxueQ@mail.gmail.com>
 <20131002204830.GA7803@redhat.com>
 <CAEGbLtsSsEVwThAf677d3-DGjUMpSqQNVGmyyzJP5Fidiui8=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsSsEVwThAf677d3-DGjUMpSqQNVGmyyzJP5Fidiui8=g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 02, 2013 at 01:53:15PM -0700, Ildar Muslukhov wrote:
 > Got it. I wonder, what are the settings you running the trinity
 > yourself? Are you fuzzing all calls at the same time, or you limit
 > your self to a set or one function at a time?

depends. if I'm not looking for anything specific, I'll just fire off
scripts/test-multi.sh   Once I've triggered something, I might narrow
it down with more specific parameters (see scripts/find.sh) for eg.

Also sometimes I'll add something like -x perf_event_open or the like
to the scripts to avoid hitting certain bugs until they're fixed.

Sometimes I'll remove the '-l off' if I want to try and pick through the logs
after hitting a bug.


	Dave
