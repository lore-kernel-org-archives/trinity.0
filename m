From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] convert syscall time tracking to CLOCK_MONOTONIC
Date: Wed, 30 Dec 2015 09:42:15 +0200
Message-ID: <20151230074215.GA12375@node.shutemov.name>
References: <1451432172-70916-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20151230005658.GA29719@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hjBki2vNrziZHFX3mSZC7dmIuy/A2khRVI6TyFKA1b4=;
        b=detPv8itDg61XedMAuxpdxnyyLlW+P/nZutcIX7adFVntWb83cJ1NuxcfRguT7Czkw
         Ng5wGcIPzAhaw8MiBTiUBrcnUr/DAZst60sLlSTqU6m9JCZnVzMP8NqB+fedHlxJCZ9S
         eCSAmeDhUe/QtDCvAFTMj6dWqpjrkSxOGtKpPeZmpWfX1TRozEaVF6DbpcDMg6Hy7LoO
         2mWGQnSMivJdQbNTvyLn5SAdn9Wp73FaXnwZoeM3Mx42Nha2VXdpRnsu1JZ7EoCi9AYk
         Tc0ab6xxtg43Gk52yogwovwfo+mF98oGytVjo+IJIqY+Pb33Z9VTLBjZUe22CBRgz1SD
         m6gQ==
Content-Disposition: inline
In-Reply-To: <20151230005658.GA29719@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, trinity@vger.kernel.org

On Tue, Dec 29, 2015 at 07:56:58PM -0500, Dave Jones wrote:
> On Wed, Dec 30, 2015 at 02:36:12AM +0300, Kirill A. Shutemov wrote:
>  > Commit e8646038d918 ("add some extra sanity checks inside the child
>  > process") made trinity near unusable for me: the rec->tv sanity check
>  > fails rather quickly after first syscall capable of changing wall time.
> 
> interesting. I wonder why I didn't notice that.

--dropprivs?

-- 
 Kirill A. Shutemov
