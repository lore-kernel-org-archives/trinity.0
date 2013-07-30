From: Vince Weaver <vincent.weaver@maine.edu>
Subject: perf : fuzzer-related NMI lockup
Date: Tue, 30 Jul 2013 15:01:27 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307301455010.9146@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

Hello

so my perf_fuzzer has been causing problems again.

After running a while all login shells on the system (even unrelated 
local ones) get killed.  Nothing is logged when this happens and it 
doesn't appear to be OOM related.

In an attempt to find out what was going on I ran the fuzzer with "nohup"
which led to the following NMI lockup which looks perf related.  The
system became unusable after this.

The first WARNING is I think a known issue but I'm including it in the 
dump in case it is related.  It's the NMI lockup that is the problem.

There was possibly some sort of RCU message printed to the screen also 
that didn't make it to the logs but I wasn't able to write it down in 
time.

This is on a recent ivybridge mac-mini running 3.11-rc3

Jul 30 11:08:28 mac-mini kernel: [  651.209212] hrtimer: interrupt took 1152 ns
Jul 30 11:08:50 mac-mini kernel: [  673.441360] perf samples too long (2557 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
Jul 30 11:08:58 mac-mini kernel: [  680.886547] perf samples too long (5003 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
Jul 30 11:08:58 mac-mini kernel: [  681.401917] perf samples too long (10002 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
Jul 30 11:09:21 mac-mini kernel: [  704.536533] ------------[ cut here ]------------
Jul 30 11:09:21 mac-mini kernel: [  704.536550] WARNING: CPU: 0 PID: 10980 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0x46/0xf5()
Jul 30 11:09:21 mac-mini kernel: [  704.536552] Modules linked in: cpufreq_conservative cpufreq_stats cpufreq_powersave cpufreq_userspace nls_utf8 nls_cp437 loop fuse snd_hda_codec_hdmi snd_hda_codec_cirrus b43 x86_pkg_temp_thermal coretemp mac80211 kvm_intel kvm i915 cfg80211 ssb drm_kms_helper rng_core snd_hda_intel drm pcmcia btusb pcmcia_core snd_hda_codec bluetooth ghash_clmulni_intel iTCO_wdt iTCO_vendor_support aesni_intel snd_hwdep snd_pcm snd_page_alloc aes_x86_64 acpi_cpufreq mperf i2c_i801 i2c_algo_bit rfkill lpc_ich i2c_core mfd_core hid_appleir processor bcma video glue_helper snd_seq pcspkr joydev evdev snd_timer snd_seq_device button lrw snd gf128mul ablk_helper soundcore cryptd sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel sdhci_pci sdhci mmc_core ahci libahci mi
 crocode ehci_pci ehci_hcd xhci_hcd usbcore usb_common tg3
Jul 30 11:09:21 mac-mini kernel: [  704.536629] CPU: 0 PID: 10980 Comm: perf_fuzzer Not tainted 3.11.0-rc3 #1
Jul 30 11:09:21 mac-mini kernel: [  704.536630] Hardware name: Apple Inc. Macmini6,1/Mac-031AEE4D24BFF0B1, BIOS MM61.88Z.0106.B03.1211161202 11/16/2012
Jul 30 11:09:21 mac-mini kernel: [  704.536632]  0000000000000000 ffffffff814400f5 0000000000000000 ffffffff81034e46
Jul 30 11:09:21 mac-mini kernel: [  704.536634]  ffffffff81011185 ffff88016a6c3000 ffff88016f20bb50 0000000000000021
Jul 30 11:09:21 mac-mini kernel: [  704.536636]  0000000000000000 ffffffff81011185 ffff88016a6c3000 ffff88016f20bb50
Jul 30 11:09:21 mac-mini kernel: [  704.536638] Call Trace:
Jul 30 11:09:21 mac-mini kernel: [  704.536643]  [<ffffffff814400f5>] ? dump_stack+0x41/0x51
Jul 30 11:09:21 mac-mini kernel: [  704.536647]  [<ffffffff81034e46>] ? warn_slowpath_common+0x74/0x89
Jul 30 11:09:21 mac-mini kernel: [  704.536649]  [<ffffffff81011185>] ? x86_pmu_start+0x46/0xf5
Jul 30 11:09:21 mac-mini kernel: [  704.536651]  [<ffffffff81011185>] ? x86_pmu_start+0x46/0xf5
Jul 30 11:09:21 mac-mini kernel: [  704.536654]  [<ffffffff8101171a>] ? x86_pmu_enable+0x14c/0x22c
Jul 30 11:09:21 mac-mini kernel: [  704.536658]  [<ffffffff810b40e7>] ? perf_event_context_sched_in.isra.71+0x67/0x84
Jul 30 11:09:21 mac-mini kernel: [  704.536660]  [<ffffffff810b4120>] ? __perf_event_task_sched_in+0x1c/0xe9
Jul 30 11:09:21 mac-mini kernel: [  704.536662]  [<ffffffff81058ad7>] ? finish_task_switch+0xa7/0xb0
Jul 30 11:09:21 mac-mini kernel: [  704.536665]  [<ffffffff8144320a>] ? __schedule+0x408/0x50f
Jul 30 11:09:21 mac-mini kernel: [  704.536668]  [<ffffffff81444424>] ? retint_careful+0xd/0x21
Jul 30 11:09:21 mac-mini kernel: [  704.536669] ---[ end trace cae9f4d49d6023c5 ]---
Jul 30 11:14:52 mac-mini kernel: [ 1036.004322] NOHZ: local_softirq_pending 100
Jul 30 11:15:08 mac-mini kernel: [ 1051.876626] NOHZ: local_softirq_pending 100
Jul 30 11:24:33 mac-mini kernel: [ 1617.723924] NOHZ: local_softirq_pending 100
Jul 30 11:26:11 mac-mini kernel: [ 1715.193332] NOHZ: local_softirq_pending 100
Jul 30 11:29:54 mac-mini kernel: [ 1938.659842] NOHZ: local_softirq_pending 100
Jul 30 12:10:38 mac-mini kernel: [ 4385.070048] NOHZ: local_softirq_pending 100
Jul 30 12:10:38 mac-mini kernel: [ 4385.070320] NOHZ: local_softirq_pending 100
Jul 30 12:10:43 mac-mini kernel: [ 4390.392320] NOHZ: local_softirq_pending 100
Jul 30 12:10:43 mac-mini kernel: [ 4390.452130] NOHZ: local_softirq_pending 100
Jul 30 12:10:54 mac-mini kernel: [ 4401.566376] NOHZ: local_softirq_pending 100
Jul 30 13:34:10 mac-mini kernel: [ 9403.552472] ------------[ cut here ]------------
Jul 30 13:34:10 mac-mini kernel: [ 9403.552479] WARNING: CPU: 0 PID: 32684 at kernel/watchdog.c:245 watchdog_overflow_callback+0x92/0x9d()
Jul 30 13:34:10 mac-mini kernel: [ 9403.552480] Watchdog detected hard LOCKUP on cpu 0
Jul 30 13:34:10 mac-mini kernel: [ 9403.552481] Modules linked in: cpuid ntfs dm_mod cpufreq_conservative cpufreq_stats cpufreq_powersave cpufreq_userspace nls_utf8 nls_cp437 loop fuse snd_hda_codec_hdmi snd_hda_codec_cirrus b43 x86_pkg_temp_thermal coretemp mac80211 kvm_intel kvm i915 cfg80211 ssb drm_kms_helper rng_core snd_hda_intel drm pcmcia btusb pcmcia_core snd_hda_codec bluetooth ghash_clmulni_intel iTCO_wdt iTCO_vendor_support aesni_intel snd_hwdep snd_pcm snd_page_alloc aes_x86_64 acpi_cpufreq mperf i2c_i801 i2c_algo_bit rfkill lpc_ich i2c_core mfd_core hid_appleir processor bcma video glue_helper snd_seq pcspkr joydev evdev snd_timer snd_seq_device button lrw snd gf128mul ablk_helper soundcore cryptd sg sd_mod crc_t10dif hid_generic usbhid hid crc32c_intel sdhci_pci sdhci mmc_co
 re ahci libahci microcode ehci_pci ehci_hcd xhci_hcd usbcore usb_common tg3
Jul 30 13:34:10 mac-mini kernel: [ 9403.552519] CPU: 0 PID: 32684 Comm: perf_fuzzer Tainted: G        W    3.11.0-rc3 #1
Jul 30 13:34:10 mac-mini kernel: [ 9403.552520] Hardware name: Apple Inc. Macmini6,1/Mac-031AEE4D24BFF0B1, BIOS MM61.88Z.0106.B03.1211161202 11/16/2012
Jul 30 13:34:10 mac-mini kernel: [ 9403.552521]  0000000000000000 ffffffff814400f5 ffff88016f206cc0 ffffffff81034e46
Jul 30 13:34:10 mac-mini kernel: [ 9403.552523]  ffffffff810920c3 ffff88016a6c3000 ffff88016f206d10 ffff88016f206da0
Jul 30 13:34:10 mac-mini kernel: [ 9403.552525]  ffff88016f206ef8 ffffffff81034ea2 ffffffff8172f4f3 ffff880100000020
Jul 30 13:34:10 mac-mini kernel: [ 9403.552527] Call Trace:
Jul 30 13:34:10 mac-mini kernel: [ 9403.552528]  <NMI>  [<ffffffff814400f5>] ? dump_stack+0x41/0x51
Jul 30 13:34:10 mac-mini kernel: [ 9403.552534]  [<ffffffff81034e46>] ? warn_slowpath_common+0x74/0x89
Jul 30 13:34:10 mac-mini kernel: [ 9403.552536]  [<ffffffff810920c3>] ? watchdog_overflow_callback+0x92/0x9d
Jul 30 13:34:10 mac-mini kernel: [ 9403.552538]  [<ffffffff81034ea2>] ? warn_slowpath_fmt+0x47/0x49
Jul 30 13:34:10 mac-mini kernel: [ 9403.552541]  [<ffffffff810b4fbb>] ? perf_prepare_sample+0x162/0x270
Jul 30 13:34:10 mac-mini kernel: [ 9403.552543]  [<ffffffff810920c3>] ? watchdog_overflow_callback+0x92/0x9d
Jul 30 13:34:10 mac-mini kernel: [ 9403.552545]  [<ffffffff810b525a>] ? __perf_event_overflow+0x191/0x213
Jul 30 13:34:10 mac-mini kernel: [ 9403.552547]  [<ffffffff810b3514>] ? perf_event_update_userpage+0x12/0xc8
Jul 30 13:34:10 mac-mini kernel: [ 9403.552550]  [<ffffffff810163f4>] ? intel_pmu_handle_irq+0x273/0x2d6
Jul 30 13:34:10 mac-mini kernel: [ 9403.552553]  [<ffffffff814491e0>] ? ret_from_fork+0xb0/0xb0
Jul 30 13:34:10 mac-mini kernel: [ 9403.552555]  [<ffffffff8144576b>] ? perf_event_nmi_handler+0x20/0x37
Jul 30 13:34:10 mac-mini kernel: [ 9403.552556]  [<ffffffff81445032>] ? nmi_handle.isra.3+0x5d/0x12b
Jul 30 13:34:10 mac-mini kernel: [ 9403.552558]  [<ffffffff814457b3>] ? perf_ibs_nmi_handler+0x31/0x31
Jul 30 13:34:10 mac-mini kernel: [ 9403.552560]  [<ffffffff810b0040>] ? irq_work_cpu_notify+0x34/0x42
Jul 30 13:34:10 mac-mini kernel: [ 9403.552562]  [<ffffffff8144519d>] ? do_nmi+0x9d/0x2ae
Jul 30 13:34:10 mac-mini kernel: [ 9403.552563]  [<ffffffff814448b7>] ? end_repeat_nmi+0x1e/0x2e
Jul 30 13:34:10 mac-mini kernel: [ 9403.552565]  [<ffffffff810b0040>] ? irq_work_cpu_notify+0x34/0x42
Jul 30 13:34:10 mac-mini kernel: [ 9403.552568]  [<ffffffff8144a7a0>] ? irq_work_interrupt+0x70/0x70
Jul 30 13:34:10 mac-mini kernel: [ 9403.552570]  [<ffffffff8144a7a0>] ? irq_work_interrupt+0x70/0x70
Jul 30 13:34:10 mac-mini kernel: [ 9403.552571]  [<ffffffff8144a7a0>] ? irq_work_interrupt+0x70/0x70
Jul 30 13:34:10 mac-mini kernel: [ 9403.552572]  <<EOE>>  [<ffffffff81025eb7>] ? native_apic_mem_read+0x8/0x9
Jul 30 13:34:10 mac-mini kernel: [ 9403.552577]  [<ffffffff81022c95>] ? native_apic_wait_icr_idle+0xa/0x14
Jul 30 13:34:10 mac-mini kernel: [ 9403.552579]  [<ffffffff810b00be>] ? irq_work_queue+0x70/0x72
Jul 30 13:34:10 mac-mini kernel: [ 9403.552581]  [<ffffffff810b733f>] ? perf_output_put_handle+0x61/0x62
Jul 30 13:34:10 mac-mini kernel: [ 9403.552583]  [<ffffffff810b7658>] ? perf_output_end+0x5/0x6
Jul 30 13:34:10 mac-mini kernel: [ 9403.552585]  [<ffffffff810b48eb>] ? perf_event_mmap_output+0x9d/0xb2
Jul 30 13:34:10 mac-mini kernel: [ 9403.552588]  [<ffffffff810b036a>] ? perf_event_comm_match+0xc/0xc
Jul 30 13:34:10 mac-mini kernel: [ 9403.552589]  [<ffffffff810b484e>] ? perf_event_comm_output+0xa5/0xa5
Jul 30 13:34:10 mac-mini kernel: [ 9403.552591]  [<ffffffff810b0ea6>] ? perf_event_aux_ctx+0x5a/0x77
Jul 30 13:34:10 mac-mini kernel: [ 9403.552593]  [<ffffffff810b036a>] ? perf_event_comm_match+0xc/0xc
Jul 30 13:34:10 mac-mini kernel: [ 9403.552595]  [<ffffffff810b484e>] ? perf_event_comm_output+0xa5/0xa5
Jul 30 13:34:10 mac-mini kernel: [ 9403.552596]  [<ffffffff810b0f4a>] ? perf_event_aux+0x87/0xb6
Jul 30 13:34:10 mac-mini kernel: [ 9403.552598]  [<ffffffff810b576b>] ? perf_event_mmap+0x1e8/0x210
Jul 30 13:34:10 mac-mini kernel: [ 9403.552601]  [<ffffffff810dcb15>] ? mmap_region+0x32e/0x478
Jul 30 13:34:10 mac-mini kernel: [ 9403.552603]  [<ffffffff810dcf0a>] ? do_mmap_pgoff+0x2ab/0x320
Jul 30 13:34:10 mac-mini kernel: [ 9403.552605]  [<ffffffff810ce2da>] ? vm_mmap_pgoff+0x77/0xab
Jul 30 13:34:10 mac-mini kernel: [ 9403.552607]  [<ffffffff810db9dc>] ? SyS_mmap_pgoff+0x181/0x1cf
Jul 30 13:34:10 mac-mini kernel: [ 9403.552609]  [<ffffffff81449256>] ? system_call_fastpath+0x1a/0x1f
Jul 30 13:34:10 mac-mini kernel: [ 9403.552610] ---[ end trace cae9f4d49d6023c6 ]---
Jul 30 13:34:59 mac-mini kernel: [ 9452.298373] sending NMI to all CPUs:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298376] NMI backtrace for cpu 0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298379] CPU: 0 PID: 32684 Comm: perf_fuzzer Tainted: G        W    3.11.0-rc3 #1
Jul 30 13:34:59 mac-mini kernel: [ 9452.298381] Hardware name: Apple Inc. Macmini6,1/Mac-031AEE4D24BFF0B1, BIOS MM61.88Z.0106.B03.1211161202 11/16/2012
Jul 30 13:34:59 mac-mini kernel: [ 9452.298382] task: ffff880169506790 ti: ffff88014cfe2000 task.ti: ffff88014cfe2000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298384] RIP: 0010:[<ffffffff8144a7a0>]  [<ffffffff8144a7a0>] irq_work_interrupt+0x70/0x70
Jul 30 13:34:59 mac-mini kernel: [ 9452.298397] RSP: 0018:ffff88014cfe3bc8  EFLAGS: 00000002
Jul 30 13:34:59 mac-mini kernel: [ 9452.298399] RAX: 00000000000410f6 RBX: ffff880168bbe2b0 RCX: 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298400] RDX: 00000000000400f6 RSI: ffff880168bbe2b8 RDI: 0000000000000300
Jul 30 13:34:59 mac-mini kernel: [ 9452.298402] RBP: ffff880168bbe000 R08: ffff88014cfe3c28 R09: ffff880081991000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298403] R10: 00000000000024ba R11: ffff88016f215f50 R12: ffff88014cfe3da0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298405] R13: ffff880169506790 R14: ffffffff810b0040 R15: ffff880169506790
Jul 30 13:34:59 mac-mini kernel: [ 9452.298407] FS:  00007ff9a65ed700(0000) GS:ffff88016f200000(0000) knlGS:0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298409] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 30 13:34:59 mac-mini kernel: [ 9452.298411] CR2: 00000000295acc68 CR3: 00000001690c3000 CR4: 00000000001407f0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298412] DR0: 0000004000ffeffe DR1: 0000000001000100 DR2: 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298414] DR3: 0000004000ffeffe DR6: 00000000ffff0ff0 DR7: 000000000f71062a
Jul 30 13:34:59 mac-mini kernel: [ 9452.298415] Stack:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298416]  ffffffff81025eb7 0000000000000010 0000000000000202 ffff88014cfe3bf8
Jul 30 13:34:59 mac-mini kernel: [ 9452.298419]  0000000000000018 ffff88014cfe3c58 ffffffff81022c95 ffffffff810b00be
Jul 30 13:34:59 mac-mini kernel: [ 9452.298422]  ffff88014cfe3d88 ffffffff810b733f ffffffff810b7658 ffffffff810b48eb
Jul 30 13:34:59 mac-mini kernel: [ 9452.298425] Call Trace:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298429]  [<ffffffff81025eb7>] ? native_apic_mem_read+0x8/0x9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298432]  [<ffffffff81022c95>] ? native_apic_wait_icr_idle+0xa/0x14
Jul 30 13:34:59 mac-mini kernel: [ 9452.298436]  [<ffffffff810b00be>] ? irq_work_queue+0x70/0x72
Jul 30 13:34:59 mac-mini kernel: [ 9452.298439]  [<ffffffff810b733f>] ? perf_output_put_handle+0x61/0x62
Jul 30 13:34:59 mac-mini kernel: [ 9452.298442]  [<ffffffff810b7658>] ? perf_output_end+0x5/0x6
Jul 30 13:34:59 mac-mini kernel: [ 9452.298445]  [<ffffffff810b48eb>] ? perf_event_mmap_output+0x9d/0xb2
Jul 30 13:34:59 mac-mini kernel: [ 9452.298448]  [<ffffffff810b036a>] ? perf_event_comm_match+0xc/0xc
Jul 30 13:34:59 mac-mini kernel: [ 9452.298451]  [<ffffffff810b484e>] ? perf_event_comm_output+0xa5/0xa5
Jul 30 13:34:59 mac-mini kernel: [ 9452.298454]  [<ffffffff810b0ea6>] ? perf_event_aux_ctx+0x5a/0x77
Jul 30 13:34:59 mac-mini kernel: [ 9452.298457]  [<ffffffff810b036a>] ? perf_event_comm_match+0xc/0xc
Jul 30 13:34:59 mac-mini kernel: [ 9452.298459]  [<ffffffff810b484e>] ? perf_event_comm_output+0xa5/0xa5
Jul 30 13:34:59 mac-mini kernel: [ 9452.298462]  [<ffffffff810b0f4a>] ? perf_event_aux+0x87/0xb6
Jul 30 13:34:59 mac-mini kernel: [ 9452.298465]  [<ffffffff810b576b>] ? perf_event_mmap+0x1e8/0x210
Jul 30 13:34:59 mac-mini kernel: [ 9452.298468]  [<ffffffff810dcb15>] ? mmap_region+0x32e/0x478
Jul 30 13:34:59 mac-mini kernel: [ 9452.298471]  [<ffffffff810dcf0a>] ? do_mmap_pgoff+0x2ab/0x320
Jul 30 13:34:59 mac-mini kernel: [ 9452.298474]  [<ffffffff810ce2da>] ? vm_mmap_pgoff+0x77/0xab
Jul 30 13:34:59 mac-mini kernel: [ 9452.298477]  [<ffffffff810db9dc>] ? SyS_mmap_pgoff+0x181/0x1cf
Jul 30 13:34:59 mac-mini kernel: [ 9452.298480]  [<ffffffff81449256>] ? system_call_fastpath+0x1a/0x1f
Jul 30 13:34:59 mac-mini kernel: [ 9452.298481] Code: e0 f7 46 68 03 00 00 00 74 03 0f 01 f8 65 ff 04 25 10 b9 00 00 65 48 0f 44 24 25 18 b9 00 00 56 e8 4f ad bb ff e9 0b 9c ff ff 90 <66> 66 90 68 09 ff ff ff 48 83 ec 58 fc 48 89 7c 24 50 48 89 74 
Jul 30 13:34:59 mac-mini kernel: [ 9452.298508] NMI backtrace for cpu 2
Jul 30 13:34:59 mac-mini kernel: [ 9452.298511] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.11.0-rc3 #1
Jul 30 13:34:59 mac-mini kernel: [ 9452.298513] Hardware name: Apple Inc. Macmini6,1/Mac-031AEE4D24BFF0B1, BIOS MM61.88Z.0106.B03.1211161202 11/16/2012
Jul 30 13:34:59 mac-mini kernel: [ 9452.298514] task: ffff88016a6e9180 ti: ffff88016a712000 task.ti: ffff88016a712000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298516] RIP: 0010:[<ffffffff8126da32>]  [<ffffffff8126da32>] __delay+0x9/0x9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298520] RSP: 0018:ffff88016f283e48  EFLAGS: 00000046
Jul 30 13:34:59 mac-mini kernel: [ 9452.298521] RAX: 0000000000000000 RBX: 0000000000002710 RCX: 0000000000000040
Jul 30 13:34:59 mac-mini kernel: [ 9452.298523] RDX: 0000000000000001 RSI: 0000000000000200 RDI: 0000000000418958
Jul 30 13:34:59 mac-mini kernel: [ 9452.298524] RBP: ffff88016f28db90 R08: 0000000000000002 R09: 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298526] R10: 0000000000000000 R11: 000125e800000018 R12: ffffffff8183ab40
Jul 30 13:34:59 mac-mini kernel: [ 9452.298527] R13: 0000000000000001 R14: ffff88016a712000 R15: ffffffff8183ac00
Jul 30 13:34:59 mac-mini kernel: [ 9452.298529] FS:  0000000000000000(0000) GS:ffff88016f280000(0000) knlGS:0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298531] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 30 13:34:59 mac-mini kernel: [ 9452.298533] CR2: 00000000018c3008 CR3: 000000000180c000 CR4: 00000000001407e0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298534] Stack:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298535]  ffffffff81023b84 ffffffff8183ab40 ffffffff8109a491 00000000000004d5
Jul 30 13:34:59 mac-mini kernel: [ 9452.298538]  0000000000000002 000000006a6e9180 ffff88016a6e9180 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298540]  0000000000000002 ffff88016f28d2d0 ffff88016f283f60 ffffffff81073170
Jul 30 13:34:59 mac-mini kernel: [ 9452.298543] Call Trace:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298544]  <IRQ> 
Jul 30 13:34:59 mac-mini kernel: [ 9452.298545]  [<ffffffff81023b84>] ? arch_trigger_all_cpu_backtrace+0x77/0x7e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298552]  [<ffffffff8109a491>] ? rcu_check_callbacks+0x3eb/0x4b4
Jul 30 13:34:59 mac-mini kernel: [ 9452.298555]  [<ffffffff81073170>] ? tick_sched_do_timer+0x25/0x25
Jul 30 13:34:59 mac-mini kernel: [ 9452.298559]  [<ffffffff81041604>] ? update_process_times+0x31/0x5c
Jul 30 13:34:59 mac-mini kernel: [ 9452.298561]  [<ffffffff8107308b>] ? tick_sched_handle+0x3e/0x4a
Jul 30 13:34:59 mac-mini kernel: [ 9452.298563]  [<ffffffff810731a0>] ? tick_sched_timer+0x30/0x4c
Jul 30 13:34:59 mac-mini kernel: [ 9452.298567]  [<ffffffff8105257e>] ? __run_hrtimer+0x89/0x139
Jul 30 13:34:59 mac-mini kernel: [ 9452.298571]  [<ffffffff81052ca3>] ? hrtimer_interrupt+0xdd/0x1be
Jul 30 13:34:59 mac-mini kernel: [ 9452.298574]  [<ffffffff81022f13>] ? smp_trace_apic_timer_interrupt+0x34/0x93
Jul 30 13:34:59 mac-mini kernel: [ 9452.298577]  [<ffffffff81449fba>] ? trace_apic_timer_interrupt+0x6a/0x70
Jul 30 13:34:59 mac-mini kernel: [ 9452.298578]  <EOI> 
Jul 30 13:34:59 mac-mini kernel: [ 9452.298579]  [<ffffffff81071a0a>] ? clockevents_program_event+0x98/0xb4
Jul 30 13:34:59 mac-mini kernel: [ 9452.298586]  [<ffffffff813550ae>] ? cpuidle_enter_state+0x4d/0x9e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298589]  [<ffffffff813551d8>] ? cpuidle_idle_call+0xd9/0x12e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298593]  [<ffffffff81008e75>] ? arch_cpu_idle+0x5/0x14
Jul 30 13:34:59 mac-mini kernel: [ 9452.298597]  [<ffffffff8106b718>] ? cpu_startup_entry+0xff/0x14f
Jul 30 13:34:59 mac-mini kernel: [ 9452.298600]  [<ffffffff81021997>] ? start_secondary+0x1d5/0x1d9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298601] Code: 1d eb 06 66 0f 1f 44 00 00 eb 0e 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 ff c8 75 fb 48 ff c8 c3 48 8b 05 b8 fb 5f 00 ff e0 <65> 48 8b 14 25 20 26 01 00 48 6b d2 3e 48 8d 04 bd 00 00 00 00 
Jul 30 13:34:59 mac-mini kernel: [ 9452.298629] NMI backtrace for cpu 1
Jul 30 13:34:59 mac-mini kernel: [ 9452.298632] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.11.0-rc3 #1
Jul 30 13:34:59 mac-mini kernel: [ 9452.298634] Hardware name: Apple Inc. Macmini6,1/Mac-031AEE4D24BFF0B1, BIOS MM61.88Z.0106.B03.1211161202 11/16/2012
Jul 30 13:34:59 mac-mini kernel: [ 9452.298636] task: ffff88016a6e9890 ti: ffff88016a70e000 task.ti: ffff88016a70e000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298638] RIP: 0010:[<ffffffff812a45f7>]  [<ffffffff812a45f7>] intel_idle+0x98/0xb9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298643] RSP: 0018:ffff88016a70fe80  EFLAGS: 00000046
Jul 30 13:34:59 mac-mini kernel: [ 9452.298644] RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
Jul 30 13:34:59 mac-mini kernel: [ 9452.298646] RDX: 0000000000000000 RSI: ffffffff818709b0 RDI: 0000000000000001
Jul 30 13:34:59 mac-mini kernel: [ 9452.298648] RBP: 0000000000000005 R08: 0000000000003e6d R09: 0000000000003e6a
Jul 30 13:34:59 mac-mini kernel: [ 9452.298649] R10: 0000000000000057 R11: 7fffffffffffffff R12: 0000000000000030
Jul 30 13:34:59 mac-mini kernel: [ 9452.298651] R13: 0000000000000004 R14: 00000000000001b8 R15: 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298653] FS:  0000000000000000(0000) GS:ffff88016f240000(0000) knlGS:0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298655] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 30 13:34:59 mac-mini kernel: [ 9452.298656] CR2: 00000000018c5068 CR3: 000000000180c000 CR4: 00000000001407e0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298658] Stack:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298659]  000000016f259200 ffff88016f259200 ffff88016a70fed8 ffffffff81870b80
Jul 30 13:34:59 mac-mini kernel: [ 9452.298662]  000008964541405e ffffffff8135509f 000000056f259200 ffffffff818709b0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298665]  ffff88016f259200 ffffffff818709b0 0000000000000005 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298667] Call Trace:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298671]  [<ffffffff8135509f>] ? cpuidle_enter_state+0x3e/0x9e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298675]  [<ffffffff813551d8>] ? cpuidle_idle_call+0xd9/0x12e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298678]  [<ffffffff81008e75>] ? arch_cpu_idle+0x5/0x14
Jul 30 13:34:59 mac-mini kernel: [ 9452.298682]  [<ffffffff8106b718>] ? cpu_startup_entry+0xff/0x14f
Jul 30 13:34:59 mac-mini kernel: [ 9452.298685]  [<ffffffff81021997>] ? start_secondary+0x1d5/0x1d9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298686] Code: 48 8b 04 25 20 b9 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 5f ff ff ff 85 c0 75 0b b9 01 00 00 00 4c 89 e0 0f 01 c9 <85> 1d a3 c3 5c 00 75 0f 48 8d 74 24 04 bf 05 00 00 00 e8 48 d1 
Jul 30 13:34:59 mac-mini kernel: [ 9452.298712] NMI backtrace for cpu 3
Jul 30 13:34:59 mac-mini kernel: [ 9452.298715] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.11.0-rc3 #1
Jul 30 13:34:59 mac-mini kernel: [ 9452.298716] Hardware name: Apple Inc. Macmini6,1/Mac-031AEE4D24BFF0B1, BIOS MM61.88Z.0106.B03.1211161202 11/16/2012
Jul 30 13:34:59 mac-mini kernel: [ 9452.298717] task: ffff88016a6eb750 ti: ffff88016a714000 task.ti: ffff88016a714000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298718] RIP: 0010:[<ffffffff812a45f7>]  [<ffffffff812a45f7>] intel_idle+0x98/0xb9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298721] RSP: 0018:ffff88016a715e80  EFLAGS: 00000046
Jul 30 13:34:59 mac-mini kernel: [ 9452.298722] RAX: 0000000000000030 RBX: 0000000000000010 RCX: 0000000000000001
Jul 30 13:34:59 mac-mini kernel: [ 9452.298722] RDX: 0000000000000000 RSI: ffffffff818709b0 RDI: 0000000000000003
Jul 30 13:34:59 mac-mini kernel: [ 9452.298723] RBP: 0000000000000005 R08: 0000000000000f8c R09: 0000000000000f95
Jul 30 13:34:59 mac-mini kernel: [ 9452.298724] R10: 0000000000000057 R11: 7fffffffffffffff R12: 0000000000000030
Jul 30 13:34:59 mac-mini kernel: [ 9452.298725] R13: 0000000000000004 R14: 00000000000001b8 R15: 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298727] FS:  0000000000000000(0000) GS:ffff88016f2c0000(0000) knlGS:0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298728] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 30 13:34:59 mac-mini kernel: [ 9452.298729] CR2: 00007fc9b8003298 CR3: 000000000180c000 CR4: 00000000001407e0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298730] Stack:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298730]  000000036f2d9200 ffff88016f2d9200 ffff88016a715ed8 ffffffff81870b80
Jul 30 13:34:59 mac-mini kernel: [ 9452.298732]  00000896454141a6 ffffffff8135509f 000000056f2d9200 ffffffff818709b0
Jul 30 13:34:59 mac-mini kernel: [ 9452.298734]  ffff88016f2d9200 ffffffff818709b0 0000000000000005 0000000000000000
Jul 30 13:34:59 mac-mini kernel: [ 9452.298736] Call Trace:
Jul 30 13:34:59 mac-mini kernel: [ 9452.298738]  [<ffffffff8135509f>] ? cpuidle_enter_state+0x3e/0x9e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298740]  [<ffffffff813551d8>] ? cpuidle_idle_call+0xd9/0x12e
Jul 30 13:34:59 mac-mini kernel: [ 9452.298742]  [<ffffffff81008e75>] ? arch_cpu_idle+0x5/0x14
Jul 30 13:34:59 mac-mini kernel: [ 9452.298744]  [<ffffffff8106b718>] ? cpu_startup_entry+0xff/0x14f
Jul 30 13:34:59 mac-mini kernel: [ 9452.298746]  [<ffffffff81021997>] ? start_secondary+0x1d5/0x1d9
Jul 30 13:34:59 mac-mini kernel: [ 9452.298747] Code: 48 8b 04 25 20 b9 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 0f ae f0 e8 5f ff ff ff 85 c0 75 0b b9 01 00 00 00 4c 89 e0 0f 01 c9 <85> 1d a3 c3 5c 00 75 0f 48 8d 74 24 04 bf 05 00 00 00 e8 48 d1 

