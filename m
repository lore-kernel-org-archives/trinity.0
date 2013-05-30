From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
Date: Thu, 30 May 2013 08:32:05 +0200
Message-ID: <20130530063205.GA5310@gmail.com>
References: <20130523152458.GD23650@twins.programming.kicks-ass.net>
 <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net>
 <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net>
 <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
 <20130527064834.GA2781@laptop>
 <0000013eec0006ee-0f8caf7b-cc94-4f54-ae38-0ca6623b7841-000000@email.amazonses.com>
 <20130529075845.GA24506@gmail.com>
 <51A65CC0.3050800@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iwJ+MFfPPG9vfNwZdd/SK8uaVDrqFdYBoD5uqPT2wHY=;
        b=mJtL//vwpuHLJZybrzkSV9lUcG3ZsmuKZRV61JTkvM4tyi1D1854lSunbrZPjMyspp
         czt/o6f2BGJTeGcO+qNgo2aY+cq/l8WHL1a4cg0a0v5XXNNGyknb2i8XZtReb2d0g7nt
         MELJpMfxPYv1mxg2P3u/Idz//1eW2cL4BuDAE401YkDc/L9/BUGe/KkwVKKfXg7MpNcU
         NbAWUrq81OTkGEC/dUMYro8T80I8v1JcdhLrjG4F9Hv0kLM2WV4MRzrELPhvqFceoiY6
         G/Jpe6D+xQHzYK5Bf305139XqxKX4cSdbdnCb7PYcHrMRwerSnyvvAEE5VKSDCrs37jK
         YKuA==
Content-Disposition: inline
In-Reply-To: <51A65CC0.3050800@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, roland@kernel.org, infinipath@qlogic.com, linux-mm@kvack.org, linux-rdma@vger.kernel.org, Or Gerlitz <or.gerlitz@gmail.com>, Hugh Dickins <hughd@google.com>


* KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> Hi
> 
> I'm unhappy you guys uses offensive word so much. Please cool down all 
> you guys. :-/ In fact, _BOTH_ the behavior before and after Cristoph's 
> patch doesn't have cleaner semantics.

Erm, this feature _regressed_ after the patch. All other concerns are 
secondary. What's so difficult to understand about that?

> And PeterZ proposed make new cleaner one rather than revert. No need to 
> hassle.

Sorry, that's not how we deal with regressions upstream...

I've been pretty polite in fact, compared to say Linus - someone should 
put a politically correct summary of:

   https://lkml.org/lkml/2013/2/22/456
   https://lkml.org/lkml/2013/3/26/1113

into Documentation/, people keep forgetting about it.

I'm sorry if being direct and to the point offends you [no, not really], 
this discussion got _way_ off the real track it should be on: that this is 
a _regression_.

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
