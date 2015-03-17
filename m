From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 2/7] remove randbits()
Date: Tue, 17 Mar 2015 10:30:46 -0400
Message-ID: <20150317143046.GB17556@codemonkey.org.uk>
References: <1426537541-54831-1-git-send-email-tyson.w.smith@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426537541-54831-1-git-send-email-tyson.w.smith@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tyson.w.smith@gmail.com
Cc: trinity@vger.kernel.org, tysmith@motorola.com

On Mon, Mar 16, 2015 at 01:25:41PM -0700, tyson.w.smith@gmail.com wrote:
 > From: Tyson Smith <tyson.w.smith@gmail.com>
 > 
 > randbits() acts very much like rand() & rand() and does not
 > provide much value in this context. This function would likely
 > be more useful in a random bit mask scenario.

Where are we doing rand() & rand() ?
The changelog implies we're doing this elsewhere, and that this
is duplication, but I'm not seeing it.

	Dave
