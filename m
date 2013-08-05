From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: percpu: kernel BUG at mm/percpu.c:579!
Date: Mon, 05 Aug 2013 17:13:08 -0400
Message-ID: <52001564.1010800@oracle.com>
References: <51FFBB7D.70608@oracle.com> <20130805145736.GB19631@mtj.dyndns.org> <20130805191517.GA9198@kmo-pixel>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130805191517.GA9198@kmo-pixel>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

On 08/05/2013 03:15 PM, Kent Overstreet wrote:
>>  From percpu_ref release path.  Kent?
>  From the backtrace I have no idea if this was from the aio code using it
> or the cgroup code - Sasha, any idea?
>
> AIO is probably more likely, I'm going to look to see if I can find
> anything...

I honestly don't know. It ran under trinity so I'm not sure what the exact
scenario is.

I can't seem to hit it again easily so far, it seems that many people merged their
work in the -next tree recently so I'm seeing multiple unrelated failures all over
the place, which makes reproducing this one harder.


Thanks,
Sasha

