From: Dave Jones <davej@redhat.com>
Subject: Re: Reproducible run and binary logs (ideas)
Date: Thu, 19 Sep 2013 11:07:47 -0400
Message-ID: <20130919150746.GA2416@redhat.com>
References: <CAEGbLtsg8_xLx9YvdrZ-gLWR4UqSQ+DT4mzEV9BfGnf-uHxDjQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsg8_xLx9YvdrZ-gLWR4UqSQ+DT4mzEV9BfGnf-uHxDjQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Sep 18, 2013 at 12:48:40PM -0700, Ildar Muslukhov wrote:
 
 > Although, the way it is implemented right now is a bit risky, since
 > the rand functions are called in place, and we cannot guarantee that
 > no other code (like gcc libraries) hasn't made a call to rand()
 > function, thus moving the rand queue forward.

This whole idea seems to hang on this statement, and it bothers me.

Can this even happen ? I'm not sure it can.
And even if it can, surely it's going to happen again when we re-run
with the same seed, so we don't need to compensate for it.

Before going too far down this rabbit hole, I want to be sure we're not
over-engineering for a problem that actually isn't.

	Dave
