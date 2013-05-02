From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] setsockopt: sanitize PF_PACKET SOL_PACKET options for
 zero-copy rings
Date: Thu, 2 May 2013 09:54:10 -0400
Message-ID: <20130502135410.GA2831@redhat.com>
References: <cover.1367420720.git.dborkman@redhat.com>
 <3f833e7246a223dc545e3f9d06b75ebeca723e6f.1367420720.git.dborkman@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3f833e7246a223dc545e3f9d06b75ebeca723e6f.1367420720.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, May 01, 2013 at 05:10:15PM +0200, Daniel Borkmann wrote:
 > In SOL_PACKET, we can sanitize the setsockopt() syscall a bit in the
 > following ways:
 > 
 > i) PACKET_VERSION is always checked in the kernel and it is quite
 >    likely to return -EINVAL here, very unlikely to crash this option.
 >    However, if we pass the correct values to it (TPACKET_V1, TPACKET_V2,
 >    TPACKET_V3), we can jump into this version specific code on other
 >    syscalls on that socket.
 > 
 > ii) PACKET_{R,T}X_RING never gets a structure of size int, so it might
 >     always return -EINVAL here. Depending on the TPACKET version, it
 >     can either be tpacket_req or tpacket_req3. Make it more likely to
 >     have size tpacket_req though.
 > 
 > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

thanks, applied and pushed out.

	Dave
