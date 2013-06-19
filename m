From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Sanitise F_SETSIG argument to avoid SIGINT
Date: Wed, 19 Jun 2013 11:11:02 -0400
Message-ID: <20130619151102.GA21770@redhat.com>
References: <1371632578-24654-1-git-send-email-michael@ellerman.id.au>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371632578-24654-1-git-send-email-michael@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <michael@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Wed, Jun 19, 2013 at 07:02:58PM +1000, Michael Ellerman wrote:
 > It's possible to send ourselves a SIGINT using F_SETSIG. This is then
 > interpreted as a Ctrl-c from the user and trinity quits.
 > 
 > Avoid SIGINT, instead use 0, which switches back to the default
 > behaviour of sending SIGIO.

excellent, thanks for tracking that down. 

this and the other two patches applied and pushed out.

	Dave
