From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Enabling masking of unimportant kernel taint falgs.
Date: Thu, 19 Sep 2013 13:20:13 -0400
Message-ID: <20130919172013.GA9385@redhat.com>
References: <alpine.DEB.2.02.1309171706510.10505@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309171706510.10505@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Tue, Sep 17, 2013 at 05:11:05PM -0700, Ildar Muslukhov wrote:
 > 
 > This patch introduces a new parameter to mask unimportant kernel taint 
 > flags.

No objection to the idea of this, but I think the user interface is a bit painful.
Who remembers those bitmasks?  It would be better if it used the names the kernel uses,
so we could do something like

--taint=DIE,BAD_PAGE

Makes the parser a little more complicated, but imo would be much more usable.

thoughts?

	Dave
