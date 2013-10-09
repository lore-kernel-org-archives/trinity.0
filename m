From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 4/6] wired in output function instead of printf (and some
 missing outputstd)
Date: Wed, 9 Oct 2013 12:23:36 -0400
Message-ID: <20131009162336.GA2821@redhat.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
 <1381267615-9826-4-git-send-email-ildarm@google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381267615-9826-4-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Tue, Oct 08, 2013 at 02:26:53PM -0700, Ildar Muslukhov wrote:
 
 
 >  void set_seed(unsigned int pidslot)
 >  {
 > +	pid_t pid = getpid();
 > +	if ((pid != watchdog_pid) && (pid != initpid) && (pid != mainpid))

As a follow-on patch, I suggest splitting this out into an is_child_pid() helper.

	Dave
