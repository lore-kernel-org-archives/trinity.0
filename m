From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 6/6] wired syscall parameters logging function into
 syscall (this should fix stack smash bug detected)
Date: Wed, 9 Oct 2013 12:28:49 -0400
Message-ID: <20131009162849.GC2821@redhat.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
 <1381267615-9826-6-git-send-email-ildarm@google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381267615-9826-6-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Tue, Oct 08, 2013 at 02:26:55PM -0700, Ildar Muslukhov wrote:
 
 > diff --git a/log.c b/log.c
 > index 2a9c140..6340d59 100644
 > --- a/log.c
 > +++ b/log.c
 > @@ -133,6 +133,68 @@ void synclogs(void)
 >  
 >  static void output_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, FILE *fd, bool mono)
 >  {
 > +	if (syscalls[call].entry->num_args >= argnum) {
 > +		if (!name)
 > +			return;
 > +
 > +		if (argnum != 1) {
 > +			CRESETFD
 
oh, you add it in the next patch.. this won't work. Patch series need
to be functional at every step, or the ability to use git-bisect breaks.

	Dave
