From: Borislav Petkov <bp@alien8.de>
Subject: Re: perf : fuzzer-related NMI lockup
Date: Tue, 30 Jul 2013 21:38:38 +0200
Message-ID: <20130730193838.GC23299@pd.tnic>
References: <alpine.DEB.2.10.1307301455010.9146@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alien8.de; s=alien8;
	t=1375213119; bh=nJiavjYw5qXpRUzPc0mjs6UiU85/Mpkb8bhgAnqHN4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To; b=S11/59iWQMbvFLyVe/NAGu/p/9M18flQHaO4DP
	6ni7AKx/wGXoc1ta6RAZtsYIybgtwLOvDffzDHGkDrSax11l2GWU829JDS05boWWt4f
	5fld4/qFRqOPQ3toapnEiZAycSiVOYRc9sqxs2HTvp+N4y6TylPdXBqVs172yi5n/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alien8.de; s=alien8;
	t=1375213119; bh=nJiavjYw5qXpRUzPc0mjs6UiU85/Mpkb8bhgAnqHN4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To; b=S11/59iWQMbvFLyVe/NAGu/p/9M18flQHaO4DP
	6ni7AKx/wGXoc1ta6RAZtsYIybgtwLOvDffzDHGkDrSax11l2GWU829JDS05boWWt4f
	5fld4/qFRqOPQ3toapnEiZAycSiVOYRc9sqxs2HTvp+N4y6TylPdXBqVs172yi5n/I=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307301455010.9146@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Tue, Jul 30, 2013 at 03:01:27PM -0400, Vince Weaver wrote:
> Hello
> 
> so my perf_fuzzer has been causing problems again.
> 
> After running a while all login shells on the system (even unrelated 
> local ones) get killed.  Nothing is logged when this happens and it 
> doesn't appear to be OOM related.
> 
> In an attempt to find out what was going on I ran the fuzzer with "nohup"
> which led to the following NMI lockup which looks perf related.  The
> system became unusable after this.
> 
> The first WARNING is I think a known issue but I'm including it in the 
> dump in case it is related.  It's the NMI lockup that is the problem.
> 
> There was possibly some sort of RCU message printed to the screen also 
> that didn't make it to the logs but I wasn't able to write it down in 
> time.
> 
> This is on a recent ivybridge mac-mini running 3.11-rc3
> 
> Jul 30 11:08:28 mac-mini kernel: [  651.209212] hrtimer: interrupt took 1152 ns
> Jul 30 11:08:50 mac-mini kernel: [  673.441360] perf samples too long (2557 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> Jul 30 11:08:58 mac-mini kernel: [  680.886547] perf samples too long (5003 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
> Jul 30 11:08:58 mac-mini kernel: [  681.401917] perf samples too long (10002 > 10000), lowering kernel.perf_event_max_sample_rate to 12500

Interesting, saw a similar thing today while running

perf top --stdio -a

[47314.677201] perf samples too long (2505 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[47314.686347] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 9.148 msecs
[47315.946675] perf samples too long (5009 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[47315.955825] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 9.154 msecs
[47391.116117] Uhhuh. NMI received for unknown reason 21 on CPU 0.
[47391.122034] Do you have a strange power saving mode enabled?
[47391.127731] Dazed and confused, but trying to continue
[53627.692616] Uhhuh. NMI received for unknown reason 31 on CPU 0.
[53627.698547] Do you have a strange power saving mode enabled?
[53627.704202] Dazed and confused, but trying to continue
[64212.289657] usb 1-1.2: USB disconnect, device number 4

along with strange "forgotten" NMIs firing later. Machine is still
running normally after that though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
