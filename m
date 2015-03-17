From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 7/7] strip down get_len() to a call to rand32()
Date: Tue, 17 Mar 2015 10:38:35 -0400
Message-ID: <20150317143835.GC17556@codemonkey.org.uk>
References: <1426537627-55047-1-git-send-email-tyson.w.smith@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426537627-55047-1-git-send-email-tyson.w.smith@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tyson.w.smith@gmail.com
Cc: trinity@vger.kernel.org, tysmith@motorola.com

On Mon, Mar 16, 2015 at 01:27:07PM -0700, tyson.w.smith@gmail.com wrote:
 > From: Tyson Smith <tyson.w.smith@gmail.com>
 > 
 > The body of get_len() was the same as rand32() so applying it to a value
 > from rand32() didn't offer much value. A switch case could be
 > added that generates other length like values as well. This could include
 > 2^n +/- ~2, page_size +/- 1, MAX_INT... etc.

Makes sense, but we could go a step further, and just remove random-length.c
entirely, and have generate-args.c just do the rand32 call.
(same for the 2-3 syscalls that call it)

	Dave
