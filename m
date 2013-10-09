From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 4/6] wired in output function instead of printf (and some
 missing outputstd)
Date: Wed, 9 Oct 2013 17:40:59 -0400
Message-ID: <20131009214059.GA26164@redhat.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
 <1381267615-9826-4-git-send-email-ildarm@google.com>
 <20131009162336.GA2821@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131009162336.GA2821@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 09, 2013 at 12:23:36PM -0400, Dave Jones wrote:
 > On Tue, Oct 08, 2013 at 02:26:53PM -0700, Ildar Muslukhov wrote:
 >  
 >  
 >  >  void set_seed(unsigned int pidslot)
 >  >  {
 >  > +	pid_t pid = getpid();
 >  > +	if ((pid != watchdog_pid) && (pid != initpid) && (pid != mainpid))
 > 
 > As a follow-on patch, I suggest splitting this out into an is_child_pid() helper.

on second thought, the printing of the seed from the child is a) pointless because
we can infer it from the main seed, and b) really noisy (especially when you run a lot of children).

let's drop this chunk

	Dave
