From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] remove this param as it not adds any value any more
Date: Mon, 26 Oct 2015 21:09:08 -0400
Message-ID: <20151027010908.GA27540@codemonkey.org.uk>
References: <1445838609-14504-1-git-send-email-praveen@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445838609-14504-1-git-send-email-praveen@linux.vnet.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Praveen K. Pandey" <praveen@linux.vnet.ibm.com>
Cc: trinity@vger.kernel.org

On Mon, Oct 26, 2015 at 11:20:09AM +0530, Praveen K. Pandey wrote:

 >  Documentation/TODO | 2 --
 >  params.c           | 1 -
 >  2 files changed, 3 deletions(-)

This is incomplete.  You also need to remove the 'p' entry
from the paramstr, the 'p' case in the switch, the dopause variable,
and all uses of it.

	Dave
