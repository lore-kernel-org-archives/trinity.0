From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] overwritten assignment in sanitise_setsockopt
Date: Tue, 2 Apr 2013 10:15:48 -0400
Message-ID: <20130402141548.GA1477@redhat.com>
References: <20130402134003.747af8ed@absol.kitzblitz>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130402134003.747af8ed@absol.kitzblitz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicolas Kaiser <nikai@nikai.net>
Cc: trinity@vger.kernel.org

On Tue, Apr 02, 2013 at 01:40:03PM +0200, Nicolas Kaiser wrote:
 > I noticed an assignment that gets immediately overwritten, contradicting
 > a nearby comment.
 > According to the comment, 'optval' should get disabled half of the time.
 > 
 > As at the time of the conditional assignment optval was already set to
 > different nonzero values, it looks to me like the trailing assignment,
 > which was introduced in commit 737e1a71, may be unintended.

Good catch. Applied.

thanks,

	Dave
