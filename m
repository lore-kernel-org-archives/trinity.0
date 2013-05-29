From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
Date: Wed, 29 May 2013 15:53:36 -0400
Message-ID: <51A65CC0.3050800@gmail.com>
References: <20130523104154.GA23650@twins.programming.kicks-ass.net> <0000013ed1b8d0cc-ad2bb878-51bd-430c-8159-629b23ed1b44-000000@email.amazonses.com> <20130523152458.GD23650@twins.programming.kicks-ass.net> <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com> <20130523163901.GG23650@twins.programming.kicks-ass.net> <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com> <20130524140114.GK23650@twins.programming.kicks-ass.net> <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com> <20130527064834.GA2781@laptop> <0000013eec0006ee-0f8caf7b-cc94-4f54-ae38-0ca6623b7841-000000@email.amazonses.com> <20130529075845.GA24506@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=pxSjUU3J4NLjJT9pnIzkmtcjvJQ74F1VpAEgz9E2xTE=;
        b=pdfKPR4aUpGV9LiVAdn5XkI0AefHwJtdpmQ6ZPd7XbsEhbK4FR/Mmy1H9dyy3rGGVy
         tWKCJgJNSVL+vj4dunk0TdYxH5s6pdLtqyhhOEdqU1iVVqEJj5W4BWpm2+9esXPnON+s
         WJINH6IzXxfHRPfhB0ujKrjbxKe1Nk00zYVth9Z6BIa8w+X6S83FIVeqTmghIHPpW4/j
         Ncp5cKyD8ChwvMMyucsd6F+0d5h0lrFHIzlAsiBxkgqM3+keUSXthPFTdTGuGGmogntX
         YpOe6CApv1DIVpELH5jFJsvnEjN3BbN5O9L7jrBSfSMrzRY7l7Y3/zGqiXJK1XqjD5kD
         TKZg==
In-Reply-To: <20130529075845.GA24506@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, roland@kernel.org, infinipath@qlogic.com, linux-mm@kvack.org, linux-rdma@vger.kernel.org, Or Gerlitz <or.gerlitz@gmail.com>, Hugh Dickins <hughd@google.com>, kosaki.motohiro@gmail.com

Hi

I'm unhappy you guys uses offensive word so much. Please cool down all you guys. :-/
In fact, _BOTH_ the behavior before and after Cristoph's patch doesn't have cleaner semantics.
And PeterZ proposed make new cleaner one rather than revert. No need to hassle.

I'm 100% sure -rt people need stronger-mlock api. Please join discussion to make better API.
In my humble opinion is: we should make mlock3(addr, len flags) new syscall (*) and support
-rt requirement directly. And current strange IB RLIMIT_MEMLOCK usage should gradually migrate
it.
(*) or, to enhance mbind() is an option because i expect apps need to pin pages nearby NUMA nodes
in many case.

As your know, current IB pinning implementation doesn't guarantee no minor fault when fork
is used. It's ok for IB. They uses madvise(MADV_NOFORK) too. But I'm not sure *all* of rt
application are satisfied this. We might need to implement copy-on-fork or might not. I'd
like hear other people's opinion.

Also, all developer should know this pinning breaks when memory hot-plug is happen likes
cpu bounding bysched_setaffinity() may break when cpu hot-remove.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
