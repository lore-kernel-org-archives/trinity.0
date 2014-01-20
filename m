From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] modify_ldt: initialize scratch
Date: Mon, 20 Jan 2014 16:39:24 -0500
Message-ID: <20140120213924.GB11834@redhat.com>
References: <1390248935-22801-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1390248935-22801-1-git-send-email-jslaby@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: trinity@vger.kernel.org, jirislaby@gmail.com

On Mon, Jan 20, 2014 at 09:15:35PM +0100, Jiri Slaby wrote:
 > From: Jiri Slaby <jirislaby@gmail.com>
 > 
 > We store a pointer in the scratch area, but only conditionally. Hence
 > there can be an uninitialized value which causes problems in the
 > tear-down path:

duh, good catch. Applied.

	Dave
