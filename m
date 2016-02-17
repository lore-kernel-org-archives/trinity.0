From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Fix logging logic in output().
Date: Wed, 17 Feb 2016 11:55:18 -0500
Message-ID: <20160217165518.GA6978@codemonkey.org.uk>
References: <1455726039-5525-1-git-send-email-asavkov@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455726039-5525-1-git-send-email-asavkov@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Artem Savkov <asavkov@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, Feb 17, 2016 at 05:20:39PM +0100, Artem Savkov wrote:
 > Commit "preparation for different forms of logging." contained a typo that
 > broke logging to mainlogfile.
 > 
 > Signed-off-by: Artem Savkov <asavkov@redhat.com>
 > ---
 >  log.c | 2 +-
 >  1 file changed, 1 insertion(+), 1 deletion(-)
 > 
 > diff --git a/log.c b/log.c
 > index dbac844..aee5a67 100644
 > --- a/log.c
 > +++ b/log.c
 > @@ -103,7 +103,7 @@ void output(unsigned char level, const char *fmt, ...)
 >  	}
 >  
 >  	/* go on with file logs only if enabled */
 > -	if (logging == LOGGING_FILES)
 > +	if (logging == LOGGING_DISABLED)
 >  		return;


Duh, yeah, that's pretty silly.  This prep work still hasn't materialised
into other forms of logging, but for now this is the obvious fix.

thanks,
	Dave
