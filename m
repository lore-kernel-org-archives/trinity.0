From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Logs cleanup
Date: Mon, 7 Oct 2013 22:43:15 -0400
Message-ID: <20131008024315.GA31588@redhat.com>
References: <alpine.DEB.2.02.1310071817130.27197@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310071817130.27197@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Mon, Oct 07, 2013 at 06:26:18PM -0700, Ildar Muslukhov wrote:
 > 
 > This patch removes almost all printf and wires them into output functions, 
 > defined in log.c. As a result this patch also fixes bugs with "stack smash 
 > detected" and emission of ANSI control symbols even if -m (monochrome 
 > mode) is specified.
 > 
 > I gave it a run for couple of hours with differnt parameters, seems to be 
 > working, but worth additional testing, since it touches many files.
 > 
 > Signed-off-by: Ildar Muslukhov <ildarm@google.com>
 
Just like last time, this needs chopping into lots of smaller patches.
It's unreviewable when you make many changes in one diff like this.

Your workflow should be using git commit often, for the smallest possible change,
and then when you're done, post a series of patches generated with 'git format-diff origin..'
 
	Dave
