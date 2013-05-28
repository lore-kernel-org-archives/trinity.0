From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user addresses
Date: Tue, 28 May 2013 10:25:14 +0200
Message-ID: <20130528082514.GA29730@gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
 <20130522.142847.791230763817666795.davem@davemloft.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CJiVpMTe/sf453Z9y2Gnz3G4I3FBpiAwbKi1nRvfnyg=;
        b=iuNGm9TTQMMwue4l2LT3p0dqtSyYlQ14Q2iMao8xiLRZcERT1RRUhAM6bu1IxTWsOc
         2jWwszKViGuxN9UKUI79LLrsVOXqM4M1mYOktGFFgbDm/1VsPGSynq9oHaiFZxkgOgAF
         1rZSIYdecPq/4vC4xXzHgSSUM8NZ4JPOsvmHlJw56TduW9z/ssk4Zw36Q7sew/tdJMA9
         b3AvgShvUrb5FHYwoYhPot+62ONqV5dJsl/hbXKExjZgLawqiJnedhrHto9UFz45TuY3
         sHsqfOZ6dP/GuEWwNuIWp+VBdvDKcOo7AdfQ6sHXtZIFBHvjj42kdLpgPG0KOjiOfwY8
         tcmg==
Content-Disposition: inline
In-Reply-To: <20130522.142847.791230763817666795.davem@davemloft.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, x86@kernel.org, trinity@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> Please don't mix networking and non-networking changes into a patch
> series.

As explained in 0/5 the networking fix justifies the first 4 patches. The 
networking fix is independent of the first 4 patches.

> Submit the networking patch to netdev@vger.kernel.org

He Cc:-ed the patch to netdev@vger.kernel.org. If you agree with it then 
the fix should probably be picked up ASAP.

Thanks,

	Ingo
