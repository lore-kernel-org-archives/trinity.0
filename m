From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Add MCL_ONFAULT to mlockall calls
Date: Wed, 20 Jan 2016 15:14:29 -0500
Message-ID: <20160120201429.GA29763@codemonkey.org.uk>
References: <1453319472-8660-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453319472-8660-1-git-send-email-emunson@akamai.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric B Munson <emunson@akamai.com>
Cc: trinity@vger.kernel.org

On Wed, Jan 20, 2016 at 02:51:12PM -0500, Eric B Munson wrote:
 > The new mlock2 system call was added, but it looks like the MCL_ONFAULT
 > flag was missed.  This is now a valid flag to pass to mlockall(), but it
 > must be used in conjunction with either MCL_CURRENT or MCL_FUTURE (or
 > both).  Also rework the way that the flags value for mlockall() is
 > caclulated.  It is valid to pass any combination of the MCL_* flags
 > except for MCL_ONFAULT alone.
 > 
 > Signed-off-by: Eric B Munson <emunson@akamai.com>
 > Cc: Dave Jones <davej@codemonkey.org.uk>

thanks, applied and pushed.

	Dave
