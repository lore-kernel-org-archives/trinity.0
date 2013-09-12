From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Date: Thu, 12 Sep 2013 18:57:33 +0200
Message-ID: <20130912165733.GA23698@gmail.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5eOZ4UdfJ7v3OknmqXko1PyCkGpanxbxNBshJ/8X46c=;
        b=HQh8sGVTq4k4aZLmIMDSZMGsugvjpayTJWMiWcbNLPRnt0RMi+12nf5gCd+Jz4mOc2
         gMZ/loRV/qpELm7cIkARB5NScDHzsVjf1pasFUeV/Jzb09y20AAz8Hh+9CWSlscDIy+8
         do1nhkEkzrOuCx8CzVRU0gwPAwkFMPwISyT9TqR25/IaP6Tz+1xpxN2S3gQxe9o0rv47
         ocH91vN+zsomCNZJCo7qmsoHwnkoMTUYkBPU5CMd4DnMcnsJngiIP5BOwIe767J2qpw+
         AYVAsYJAsixgfh8Luu6MsTbJ4CsikwUvmAYq31rwvMiD65C9txPcurwWBWYvmRrm/0ox
         7JOw==
Content-Disposition: inline
In-Reply-To: <20130723225150.GT6123@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>, acme@infradead.org, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org, trinity@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> > 
> > I hate having to justify why breaking the ABI is unacceptable.
> 
> Well it's a testing ABI, so we can do changes to it.
> 
> I hope you're not suggesting that perf cannot be extended anymore.

It obviously should remain extensible, limiting it to 'config' is rather 
stupid. If a parser sees something it cannot parse it should ignore that 
event.

Your feature to export 'precise' requirements on events looks useful to 
me. We could implement it not by special casing it implicitly but by 
saying that if ../format/precise contains something like:

   attr:240-241

then that's a natural extension of the config:X-Y format and should be 
interpreted to mean mean 2 bits in the perf attr field. I.e. we could go 
beyond the config bitfield.

Basically the whole perf_event_attr can be thought of as a 'giant 
bitfield', in which we can specify values to export an enumerated list of 
events from the kernel to tooling.

(Using attr:X-Y the config and config1 variants can be expressed as well, 
as the config fields are inside the attr structure.)

The positions within the perf_attr are an ABI, so this would work pretty 
well.

Thanks,

	Ingo
