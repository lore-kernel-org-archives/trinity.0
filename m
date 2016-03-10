From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] compat.h: add SHM_NORESERVE flag
Date: Thu, 10 Mar 2016 18:21:36 -0500
Message-ID: <20160310232136.GA483@codemonkey.org.uk>
References: <1457650615-5679-1-git-send-email-adrien+dev@schischi.me>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457650615-5679-1-git-send-email-adrien+dev@schischi.me>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: trinity@vger.kernel.org

On Thu, Mar 10, 2016 at 02:56:55PM -0800, Adrien Schildknecht wrote:
 > Debian jessie MIPS build fix.
 > sysv-shm.c:22:3: error: 'SHM_NORESERVE' undeclared (first use in this function)
 >    SHM_NORESERVE,
 > 
 > https://sourceware.org/bugzilla/show_bug.cgi?id=17930

Applied (also the other diff) and pushed.

thanks Adrien,

	Dave
