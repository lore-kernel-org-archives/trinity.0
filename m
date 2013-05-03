From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] setsockopt: add missing SCTP socket layer options
Date: Fri, 3 May 2013 10:45:43 -0400
Message-ID: <20130503144543.GA1283@redhat.com>
References: <cover.1367580990.git.dborkman@redhat.com>
 <54c8ad29a01a2fb0976484e512c42f4e87320a6a.1367580990.git.dborkman@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54c8ad29a01a2fb0976484e512c42f4e87320a6a.1367580990.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org

On Fri, May 03, 2013 at 01:38:26PM +0200, Daniel Borkmann wrote:
 > There are a couple of missing socket options for SCTP, so simply
 > add them to the list.

Well spotted. Added and pushed out.

thanks,

	Dave
