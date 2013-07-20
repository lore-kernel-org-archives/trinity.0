From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] improve randomness in rand64()
Date: Fri, 19 Jul 2013 20:30:02 -0400
Message-ID: <20130720003002.GA31116@redhat.com>
References: <alpine.DEB.2.02.1307191432480.14274@exit8.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307191432480.14274@exit8.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Honig <ahonig@google.com>
Cc: trinity@vger.kernel.org

On Fri, Jul 19, 2013 at 02:39:15PM -0700, Andy Honig wrote:
 > Commit 6112813df53ce6762f5c8de1d4382d67f9f2f769 introduced
 > code to occasionally invert the valuerand64().  However the code 
 > mistakenly zeroed the value instead by xoring it with itself.

Well that's just embaressing.

thanks, applied.

	Dave
