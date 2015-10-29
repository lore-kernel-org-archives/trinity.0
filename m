From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] remove this param as it not adds any value any more
Date: Thu, 29 Oct 2015 05:13:47 -0400
Message-ID: <20151029091347.GA646@codemonkey.org.uk>
References: <1446108973-10833-1-git-send-email-praveen@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446108973-10833-1-git-send-email-praveen@linux.vnet.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Praveen K. Pandey" <praveen@linux.vnet.ibm.com>
Cc: trinity@vger.kernel.org

On Thu, Oct 29, 2015 at 02:26:13PM +0530, Praveen K. Pandey wrote:
 > Signed-off-by: Praveen K. Pandey <praveen@linux.vnet.ibm.com>
 > ---
 >  Documentation/TODO         | 1 -
 >  children/random-syscalls.c | 8 --------
 >  include/params.h           | 1 -
 >  params.c                   | 9 +--------
 >  4 files changed, 1 insertion(+), 18 deletions(-)

Looks good, applied.

thanks.

	Dave
