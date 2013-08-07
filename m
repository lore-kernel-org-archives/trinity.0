From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: perf,arm -- another (different) fuzzer oops
Date: Wed, 07 Aug 2013 16:18:08 -0700
Message-ID: <5202D5B0.9020107@codeaurora.org>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130807223129.GA17118@mudshark.cambridge.arm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On 08/07/13 15:31, Will Deacon wrote:
> On Wed, Aug 07, 2013 at 09:14:55PM +0100, Vince Weaver wrote:
>
>> [  388.509063] Unable to handle kernel paging request at virtual address 73fd14cc
>> [  388.509063] pgd = eca6c000
>> [  388.519805] [73fd14cc] *pgd=00000000
>> [  388.523651] Internal error: Oops: 5 [#1] SMP ARM
>> [  388.528594] Modules linked in: snd_soc_omap_hdmi omapdss snd_soc_omap_abe_twl6040 snd_soc_twl6040 snd_soc_omap snd_soc_omap_hdmi_card snd_soc_omap_mcpdm snd_soc_omap_mcbsp snd_soc_core snd_compress regmap_spi snd_pcm snd_page_alloc snd_timer snd soundcore
>> [  388.551757] CPU: 1 PID: 2790 Comm: perf_fuzzer Not tainted 3.11.0-rc4 #6
>> [  388.559906] task: eddcab80 ti: ed892000 task.ti: ed892000
>> [  388.565643] PC is at armpmu_map_event+0x20/0x88
>> [  388.570495] LR is at armpmu_event_init+0x38/0x280
>> [  388.574981] pc : [<c001c3e4>]    lr : [<c001c17c>]    psr: 60000013
>> [  388.574981] sp : ed893e40  ip : ecececec  fp : edfaec00
>> [  388.581878] r10: 00000000  r9 : 00000000  r8 : ed8c3ac0
>> [  388.593292] r7 : ed8c3b5c  r6 : edfaec00  r5 : 00000000  r4 : 00000000
>> [  388.593292] r3 : 000000ff  r2 : c0496144  r1 : c049611c  r0 : edfaec00
>> [  388.607177] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> [  388.614776] Control: 10c5387d  Table: aca6c04a  DAC: 00000015
>> [  388.614776] Process perf_fuzzer (pid: 2790, stack limit = 0xed892240)
>> [  388.621826] Stack: (0xed893e40 to 0xed894000)
>> [  388.632385] 3e40: 00000800 c001c17c 00000002 c008a748 00000001 00000000 00000000 c00bf078
>> [  388.634796] 3e60: 00000000 edfaee50 00000000 00000000 00000000 edfaec00 ed8c3ac0 edfaec00
>> [  388.634796] 3e80: 00000000 c073ffac ed893f20 c00bf180 00000001 00000000 c00bf078 ed893f20
>> [  388.652435] 3ea0: 00000000 ed8c3ac0 00000000 00000000 00000000 c0cb0818 eddcab80 c00bf440
>> [  388.667205] 3ec0: ed893f20 00000000 eddcab80 eca76800 00000000 eca76800 00000000 00000000
>> [  388.668487] 3ee0: 00000000 ec984c80 eddcab80 c00bfe68 00000000 00000000 00000000 00000080
>> [  388.684631] 3f00: 00000000 ed892000 00000000 ed892030 00000004 ecc7e3c8 ecc7e3c8 00000000
>> [  388.693328] 3f20: 00000000 00000048 ecececec 00000000 00000000 00000000 00000000 00000000
>> [  388.701843] 3f40: 00000000 00000000 00297810 00000000 00000000 00000000 00000000 00000000
>> [  388.701843] 3f60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>> [  388.719451] 3f80: 00000002 00000002 000103a4 00000002 0000016c c00128e8 ed892000 00000000
>> [  388.724212] 3fa0: 00090998 c0012700 00000002 000103a4 00090ab8 00000000 00000000 0000000f
>> [  388.731842] 3fc0: 00000002 000103a4 00000002 0000016c 00090ab0 00090ab8 000107a0 00090998
>> [  388.745574] 3fe0: bed92be0 bed92bd0 0000b785 b6e8f6d0 40000010 00090ab8 00000000 00000000
>> [  388.751831] [<c001c3e4>] (armpmu_map_event+0x20/0x88) from [<c001c17c>] (armpmu_event_init+0x38/0x280)
>> [  388.764221] [<c001c17c>] (armpmu_event_init+0x38/0x280) from [<c00bf180>] (perf_init_event+0x108/0x180)
>> [  388.764221] [<c00bf180>] (perf_init_event+0x108/0x180) from [<c00bf440>] (perf_event_alloc+0x248/0x40c)
>> [  388.764221] [<c00bf440>] (perf_event_alloc+0x248/0x40c) from [<c00bfe68>] (SyS_perf_event_open+0x4f4/0x8fc)
>> [  388.791839] [<c00bfe68>] (SyS_perf_event_open+0x4f4/0x8fc) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
>> [  388.804718] Code: 0a000005 e3540004 0a000016 e3540000 (0791010c) 
>> [  388.811248] ---[ end trace 89ea407225495d97 ]---
>>

$ ./scripts/decodecode < oops 
[ 388.804718] Code: 0a000005 e3540004 0a000016 e3540000 (0791010c)
All code
========
   0:   0a000005        beq     0x1c
   4:   e3540004        cmp     r4, #4
   8:   0a000016        beq     0x68
   c:   e3540000        cmp     r4, #0
  10:*  0791010c        ldreq   r0, [r1, ip, lsl #2]            <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0:   0791010c        ldreq   r0, [r1, ip, lsl #2]



Is config some really big value? It looks like config (or more
specifically event->attr.config) is ecececec which is larger than 9
(PERF_COUNT_HW_MAX). I'm fairly certain r4 is event->attr.type
(PERF_TYPE_HARDWARE) and so we're out of bounds on that array access in
armpmu_map_hw_event(). Does the below patch fix that?

---8<----

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index d9f5cd4..21f7790 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -53,7 +53,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
 static int
 armpmu_map_hw_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
 {
-       int mapping = (*event_map)[config];
+       int mapping;
+
+       if (config >= PERF_COUNT_HW_MAX)
+               return -ENOENT;
+
+       mapping = (*event_map)[config];
        return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
 }
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
