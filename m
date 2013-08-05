From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: perf,arm -- oops in validate_event
Date: Mon, 5 Aug 2013 17:17:37 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Mon, 5 Aug 2013, Vince Weaver wrote:

> My perf_fuzzer quickly triggers this oops on my ARM Cortex A9 pandaboard
> running Linux 3.11-rc4.
> 
> Below is the oops, I've attached a simple C test case that triggers the 
> bug.

Also, if it helps, the disassembled code in question.

It looks like in validate_event() we do

        struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
        ...
        return armpmu->get_event_idx(hw_events, event) >= 0;

armpmu is read into r3, and somehow the value at the offset of
armpmu->get_event_idx is either -1 or 0, so when it does a "blx" 
branch to the address at this offset we get the ooops.

  c001bf8c:       e3120010        tst     r2, #16
  c001bf90:       0a000004        beq     c001bfa8 <validate_event+0x48>
  c001bf94:       e5933070        ldr     r3, [r3, #112]  ; 0x70
* c001bf98:       e12fff33        blx     r3
  c001bf9c:       e1e00000        mvn     r0, r0

I'm having trouble tracing the code back past that, and I don't have time
to start adding printk's and recompiling right now.

Vince

> [ 8110.698669] Unable to handle kernel paging request at virtual address fffffffe
> [ 8110.706390] pgd = ecd88000
> [ 8110.708251] [fffffffe] *pgd=ae7f6821, *pte=00000000, *ppte=00000000
> [ 8110.715820] Internal error: Oops: 80000007 [#2] SMP ARM
> [ 8110.716033] Modules linked in: bluetooth snd_soc_omap_hdmi omapdss snd_soc_omap_abe_twl6040 snd_soc_twl6040 snd_soc_omap_hdmi_card snd_soc_omap snd_soc_omap_mcpdm snd_soc_omap_mcbsp snd_soc_core snd_compress regmap_spi snd_pcm snd_page_alloc snd_timer snd soundcore
> [ 8110.743133] CPU: 1 PID: 28431 Comm: perf_fuzzer Tainted: G      D      3.11.0-rc4 #4
> [ 8110.743133] task: edab8100 ti: ece5c000 task.ti: ece5c000
> [ 8110.760681] PC is at 0xfffffffe
> [ 8110.760681] LR is at validate_event+0x3c/0x50
> [ 8110.766906] pc : [<fffffffe>]    lr : [<c001bf9c>]    psr: 20000033
> [ 8110.766906] sp : ece5de40  ip : edfbd960  fp : edfbd800
> [ 8110.775238] r10: 00000000  r9 : 00000000  r8 : ed8c3ec0
> [ 8110.781066] r7 : ed8c3f5c  r6 : edfbd800  r5 : ecaed000  r4 : ece5de4c
> [ 8110.791107] r3 : ffffffff  r2 : 000000d9  r1 : ecaed000  r0 : ece5de50
> [ 8110.791107] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
> [ 8110.803924] Control: 10c5387d  Table: acd8804a  DAC: 00000015
> [ 8110.814239] Process perf_fuzzer (pid: 28431, stack limit = 0xece5c240)
> [ 8110.821197] Stack: (0xece5de40 to 0xece5e000)
> [ 8110.821197] de40: 00000000 c001c280 00000002 00000000 00000001 ece5de4c 00000000 c00bf058
> [ 8110.831085] de60: 00000000 c008626c 00000000 00000000 00000000 edfbd800 ed8c3ec0 edfbd800
> [ 8110.831085] de80: 00000000 c073ffac ece5df20 c00bf160 00000001 00000000 c00bf058 ece5df20
> [ 8110.851959] dea0: 00000000 ed8c3ec0 00000000 00000000 00000000 c0cb0818 edab8100 c00bf420
> [ 8110.860656] dec0: ece5df20 00000000 edab8100 ecaed000 00000000 00000000 00000000 00000000
> [ 8110.862182] dee0: 00000000 ecad5680 edab8100 c00bfe48 00000000 00000000 00000000 c073e7c0
> [ 8110.862182] df00: 00000000 ece5c000 c15036e8 ece5c030 00000005 c06eb5c0 6b139c44 00000000
> [ 8110.879913] df20: 00000004 00000050 8dfff7d3 00000000 00000000 00000000 00000000 00000000
> [ 8110.895507] df40: 00000000 00000000 001d4a0b 00000000 00000000 00000000 00000000 00000000
> [ 8110.901062] df60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [ 8110.911102] df80: 00000000 00000000 00090990 000103a4 0000016c c00128e8 ece5c000 00000000
> [ 8110.921112] dfa0: 000107a0 c0012700 00000000 00090990 00090bd0 00000000 00000000 00000004
> [ 8110.921112] dfc0: 00000000 00090990 000103a4 0000016c 00090bd0 00090bc8 00090998 000107a0
> [ 8110.931060] dfe0: beab7be0 beab7bd0 0000b6c9 b6f016d0 40000010 00090bd0 00000000 00000000
> [ 8110.941009] [<c001bf9c>] (validate_event+0x3c/0x50) from [<c001c280>] (armpmu_event_init+0x16c/0x280)
> [ 8110.953247] [<c001c280>] (armpmu_event_init+0x16c/0x280) from [<c00bf160>] (perf_init_event+0x108/0x180)
> [ 8110.967712] [<c00bf160>] (perf_init_event+0x108/0x180) from [<c00bf420>] (perf_event_alloc+0x248/0x40c)
> [ 8110.971069] [<c00bf420>] (perf_event_alloc+0x248/0x40c) from [<c00bfe48>] (SyS_perf_event_open+0x4f4/0x8fc)
> [ 8110.981048] [<c00bfe48>] (SyS_perf_event_open+0x4f4/0x8fc) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
> [ 8110.998199] Code: bad PC value
> [ 8111.001495] ---[ end trace 0e6c892fae28bee4 ]---
