From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 02/12] configure.sh: use gcc as default compiler
Date: Thu, 17 Oct 2013 15:23:50 +1100
Message-ID: <1381983830.11189.0.camel@concordia>
References: <1381920210-23329-1-git-send-email-mikko.rapeli@iki.fi>
	 <1381920210-23329-2-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1381920210-23329-2-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: trinity@vger.kernel.org

On Wed, 2013-10-16 at 13:43 +0300, Mikko Rapeli wrote:
> Cross compilers might not have cc symlink but do have gcc.

It's trivial to create a symlink from foo-cc to foo-gcc, and any decent
cross compiler script will do that for you.

cheers

