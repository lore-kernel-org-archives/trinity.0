From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] hw_breakpoint: cleanups
Date: Thu, 13 Jun 2013 17:24:15 +0200
Message-ID: <CAFTL4hxQ94mq16ZnF1g8h0ug1rMLmKia_wC4yt01Ra4KWkgsSA@mail.gmail.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
	<20130601194526.GA27149@redhat.com>
	<20130613140112.GB16339@somewhere>
	<20130613151546.GA30062@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ulQUHBpgA9DmVsiD6XkynOyOCHam3zIVMllaV6stz8M=;
        b=F1Ke5MGYCtLjXqVjBLR3Otq5kLwQUbj6Fy9xHQNPSE+Wbor1R+f79imskv83+vCHjh
         ySBLCTWDrkyTDNFUZd604REJyZm4GqbJ4Au+E9wCuLaEtfzCZPXm42b1Da2dAKF4PCKX
         GBfbiRYF9fRo4g9bnPOD+S1/ntV8fZyqE20/ykaz/6aGlNHl1x3bn5tYo5bHSVS2a7rw
         YlV1maBjiCF07gvtTjmBPXBLlow0/XZybxG6W2s1rc3aAYHf1pR7PXW3c4lmZ8OWw7sq
         xgTBY+u2rQfqV2KbiPEHUkJnruvBRc2OKFC9TpZ9oDePhl98Bkf/yFiyXUjTulvv+VyU
         X39w==
In-Reply-To: <20130613151546.GA30062@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

2013/6/13 Oleg Nesterov <oleg@redhat.com>:
> On 06/13, Frederic Weisbecker wrote:
>>
>> On Sat, Jun 01, 2013 at 09:45:26PM +0200, Oleg Nesterov wrote:
>> > Hello.
>> >
>> > Cleanups, on top of
>> >
>> >     [PATCH 0/2]: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
>>
>> So this series doesn't have the fix for the warning?
>
> I don't understand the question ;)
>
> The previous series
>
>         [PATCH 1/2] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
>         [PATCH 2/2] hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
>
> tried to fix the bugs which lead to this (correct) warning.
>
> This and the next one try to cleanup the code.

Ah ok, there is two series (/me confused as usual :)
