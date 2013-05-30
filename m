From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [RFC][PATCH] mm: Fix RLIMIT_MEMLOCK
Date: Thu, 30 May 2013 16:42:15 -0400
Message-ID: <CAHGf_=qkJWEhwKRY4gu0wL4OLU1PhOW3=n6JNmAocSK-T0PhmA@mail.gmail.com>
References: <20130523152458.GD23650@twins.programming.kicks-ass.net>
 <0000013ed2297ba8-467d474a-7068-45b3-9fa3-82641e6aa363-000000@email.amazonses.com>
 <20130523163901.GG23650@twins.programming.kicks-ass.net> <0000013ed28b638a-066d7dc7-b590-49f8-9423-badb9537b8b6-000000@email.amazonses.com>
 <20130524140114.GK23650@twins.programming.kicks-ass.net> <0000013ed732b615-748f574f-ccb8-4de7-bbe4-d85d1cbf0c9d-000000@email.amazonses.com>
 <20130527064834.GA2781@laptop> <0000013eec0006ee-0f8caf7b-cc94-4f54-ae38-0ca6623b7841-000000@email.amazonses.com>
 <20130529075845.GA24506@gmail.com> <51A65CC0.3050800@gmail.com> <20130530063205.GA5310@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=imroOsZv0DLf/aQcJ8WcgbqBeBqzy202deAzlFGvfsQ=;
        b=y5sfZp2bQDDIp4Z/XT8QNzYP3z5XXaDdZ7cxE2Tw0AhKJfVr4cN58Unurj1AFU81FL
         R4VClANK6xCgEt8LTMe55r/9nQYpuv8pDeGDSlqxJarGnTzD3na6mmFV3S9H7N3OFhkP
         JJ7P21hl2f6GMwZo11y1dwJMOZtUQstBVbpw2NRA5uzRYYjlNktU/Wi/0hWWvbAVZMKv
         3FViwSlkf4T9ZOExKHXJtZLZVCG5Fd+KboJeed+vW45uWwA2bAGtMgQ5IXB2mv0TTODA
         PEVyJsPIGwBxvvtpsPnkE/QESnQdAjY7Y4CGD22kC4/26leTPTxF2gpaTsLH76ISwQVD
         6hFQ==
In-Reply-To: <20130530063205.GA5310@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Vince Weaver <vincent.weaver@maine.edu>, LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roland Dreier <roland@kernel.org>, infinipath@qlogic.com, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-rdma@vger.kernel.org, Or Gerlitz <or.gerlitz@gmail.com>, Hugh Dickins <hughd@google.com>

>> I'm unhappy you guys uses offensive word so much. Please cool down all
>> you guys. :-/ In fact, _BOTH_ the behavior before and after Cristoph's
>> patch doesn't have cleaner semantics.
>
> Erm, this feature _regressed_ after the patch. All other concerns are
> secondary. What's so difficult to understand about that?

Because it is not new commit at all. Christoph's patch was introduced
10 releases before.

$ git describe bc3e53f682
v3.1-7235-gbc3e53f

If we just revert it, we may get another and opposite regression
report. I'm worried
about it. Moreover, I don't think discussion better fix is too difficult for us.
