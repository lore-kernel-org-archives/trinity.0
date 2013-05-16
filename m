From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH trinity] net: add generation of semi-random BPF filters
Date: Thu, 16 May 2013 09:55:47 -0400
Message-ID: <20130516135547.GA7393@redhat.com>
References: <1368698056-411-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368698056-411-1-git-send-email-dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org

On Thu, May 16, 2013 at 11:54:16AM +0200, Daniel Borkmann wrote:
 > BPF filters are used in networking and in application sand-boxing
 > and even have a arch-dependant JIT compiler in the kernel, so add
 > a more detailed semi-random BPF generator.
 > 
 > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
 > ---
 >  Compile-tested only!

Very nice.

merged and pushed.

thanks,

	Dave
