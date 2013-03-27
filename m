From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix BITS_PER_LONG for ppc32
Date: Wed, 27 Mar 2013 09:46:45 -0400
Message-ID: <20130327134645.GA1738@redhat.com>
References: <1364364380-3075-1-git-send-email-kda@linux-powerpc.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1364364380-3075-1-git-send-email-kda@linux-powerpc.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Denis Kirjanov <kda@linux-powerpc.org>
Cc: trinity@vger.kernel.org, kda@linuxpowerpc.org

On Wed, Mar 27, 2013 at 10:06:20AM +0400, Denis Kirjanov wrote:

 > -#define BITS_PER_LONG		64
 > +#define BITS_PER_LONG		32

oops ;)

Thanks, applied.

	Dave

