From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 02/12] configure.sh: use gcc as default compiler
Date: Thu, 17 Oct 2013 09:45:42 +0300
Message-ID: <20131017064542.GF2381@lakka.kapsi.fi>
References: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
 <1381920210-23329-2-git-send-email-mikko.rapeli@iki.fi>
 <1381983830.11189.0.camel@concordia>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381983830.11189.0.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <michael@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Thu, Oct 17, 2013 at 03:23:50PM +1100, Michael Ellerman wrote:
> On Wed, 2013-10-16 at 13:43 +0300, Mikko Rapeli wrote:
> > Cross compilers might not have cc symlink but do have gcc.
> 
> It's trivial to create a symlink from foo-cc to foo-gcc, and any decent
> cross compiler script will do that for you.

True, but Mentor/Codesourcery Lite version that I had to use did not have
this and I did not want to fix it. I'm ok if this one is dropped.

-Mikko
