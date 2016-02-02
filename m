From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] net/protocols.c: fix build on old machines
Date: Tue, 2 Feb 2016 11:30:11 -0500
Message-ID: <20160202163011.GA15535@codemonkey.org.uk>
References: <1454415921-13454-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454415921-13454-1-git-send-email-jslaby@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: trinity@vger.kernel.org

On Tue, Feb 02, 2016 at 01:25:21PM +0100, Jiri Slaby wrote:
 > * include compat.h for PF_* constants
 > * use PF_NFC only if it can fit into the list
 > * use PF_ALG only if USE_IF_ALG is defined

I committed a slightly different fix for the PF_NFC problem
that avoids the #if

Let me know if this doesn't work.

thanks,
	Dave
