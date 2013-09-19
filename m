From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Thu, 19 Sep 2013 17:35:33 -0400
Message-ID: <20130919213533.GA6963@redhat.com>
References: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Thu, Sep 19, 2013 at 02:24:24PM -0700, Ildar Muslukhov wrote:
 > 
 > This patch fixes missing 6th param for 32bit syscalls in i386 and x86_64 
 > archs.
 > 
 > Note: I have to remove static from syscall32, because gcc messes up with 
 > inline asm becuase of that.
 > 
 > Signed-off-by: Ildar Muslukhov <ildarm@google.com>
 
thanks, applied and pushed out.
That might have been one of the oldest TODO's in the source code :-)

	Dave
