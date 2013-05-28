From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user
 addresses
Date: Tue, 28 May 2013 01:51:05 -0700 (PDT)
Message-ID: <20130528.015105.1513437101791265718.davem@davemloft.net>
References: <cover.1369177867.git.luto@amacapital.net>
	<20130522.142847.791230763817666795.davem@davemloft.net>
	<20130528082514.GA29730@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130528082514.GA29730@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: mingo@kernel.org
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, x86@kernel.org, trinity@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>
Date: Tue, 28 May 2013 10:25:14 +0200

> 
> * David Miller <davem@davemloft.net> wrote:
> 
>> Please don't mix networking and non-networking changes into a patch
>> series.
> 
> As explained in 0/5 the networking fix justifies the first 4 patches. The 
> networking fix is independent of the first 4 patches.
> 
>> Submit the networking patch to netdev@vger.kernel.org
> 
> He Cc:-ed the patch to netdev@vger.kernel.org. If you agree with it then 
> the fix should probably be picked up ASAP.

He submitted it as part of a series which implies that it belongs together
with the others.

If it does not, he should submit it seperately.

If they belong together, then the entire series should be CC:'d to netdev
so that networking developers can see all of the context and participate
in the patches that the networking "enables".
