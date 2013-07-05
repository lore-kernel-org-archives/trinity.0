From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/6] trinity.c: fix uninitialized variable
Date: Fri, 5 Jul 2013 10:44:49 -0400
Message-ID: <20130705144449.GA31027@redhat.com>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
 <1372967744-29353-2-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1372967744-29353-2-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: trinity@vger.kernel.org

On Thu, Jul 04, 2013 at 10:55:39PM +0300, Mikko Rapeli wrote:
 > Coverity says:
 > 
 > CID 1042350 (#1 of 1): Uninitialized scalar variable (UNINIT)
 > 23. uninit_use_in_call: Using uninitialized value "ling": field "ling"."l_linger" is uninitialized when calling "setsockopt(int, int, int, void const *, socklen_t)".
 > 
 > Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
 > ---
 >  trinity.c | 1 +
 >  1 file changed, 1 insertion(+)
 > 
 > diff --git a/trinity.c b/trinity.c
 > index 93e7819..3f80020 100644
 > --- a/trinity.c
 > +++ b/trinity.c
 > @@ -250,6 +250,7 @@ cleanup_fds:
 >  
 >  	for (i = 0; i < nr_sockets; i++) {
 >  		struct linger ling;
 > +		memset(&ling, 0, sizeof(ling));
 >  
 >  		ling.l_onoff = FALSE;	/* linger active */
 >  		setsockopt(shm->socket_fds[i], SOL_SOCKET, SO_LINGER, &ling, sizeof(struct linger));

Let's just do this as 

	struct linger ling = { .l_onoff = FALSE, };

That should have the same effect.

This should be a harmless bug anyway, because l_linger only matters when we're turning
linger on afaik.

	Dave
