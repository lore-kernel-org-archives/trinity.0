From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Patch : enable  tool as make -p take an arg for seconds
Date: Tue, 4 Aug 2015 19:44:33 -0400
Message-ID: <20150804234433.GA20116@codemonkey.org.uk>
References: <1438159549-4119-1-git-send-email-praveen@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438159549-4119-1-git-send-email-praveen@linux.vnet.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Praveen Pandey <praveen@linux.vnet.ibm.com>
Cc: trinity@vger.kernel.org, sachinp@in.ibm.com

On Wed, Jul 29, 2015 at 02:15:49PM +0530, Praveen Pandey wrote:

 > diff --git a/Documentation/TODO b/Documentation/TODO
 > index 73ea04a..108ee9c 100644
 > --- a/Documentation/TODO
 > +++ b/Documentation/TODO
 > @@ -228,7 +228,7 @@
 >    - if we find a blocking fd, check if it's a socket, and shutdown() it.
 >      (tricky: we need to do the shutdown in the main process, and then tell other children)
 >  
 > -* make -p take an arg for seconds
 > +* make -p take an arg for seconds --- DONE

I'm not sure this feature actually adds any value any more.
I don't recall what I was thinking back when I added that TODO item,
but it probably came from a time long before Trinity had multiple child processes.

Unless anyone has a compelling reason for this, I'd say just drop it.

	Dave
