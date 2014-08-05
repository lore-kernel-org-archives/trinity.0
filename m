From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] perf_event_open() Linux 3.16 additions
Date: Tue, 5 Aug 2014 00:06:35 -0400 (EDT)
Message-ID: <alpine.DEB.2.11.1408050003190.10700@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1408040012001.630@vincent-weaver-1.umelst.maine.edu> <20140804215518.GA15670@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=bJRQqZ9DHvj7fjcuRTnYRjbxzCJnomlvhh+ZtnVWzqI=;
        b=hZer3Equ8ErfVFbj0Ro1/4OLW8jfScLNjBhtZu3nVe6lziqxN0tymJ3AsZl5ntUFpo
         6+x0JWrA38gjLJ5Kp4YfwY5IJ0aDruup0HYDMi7wZUACOieCouaMReloNW+aZS7zzlLu
         WA3FBqXOoLpyJYKWmAHhEuRB+8hMnSJkrsymM=
In-Reply-To: <20140804215518.GA15670@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Mon, 4 Aug 2014, Dave Jones wrote:

> Luckily I hadn't pushed that out yet. Care to respin it with that fixed,
> and have a quick eyeball to make sure nothing else made it in that shouldn't have ?

yes, sorry about that.  I tend to use the stock kernel perf_event.h but 
trinity's copy has been changed to use "#pragma once" and it catches me 
every time.

I noticed the problem right before sending the patch and I hand-edited out 
the extraneous stuff at the top of the patch but forgot that there would 
be an #endif at the bottom.

Anyway I'll re-send a version that actually passes make clean/compile.

Vince
