From: Vince Weaver <vincent.weaver@maine.edu>
Subject: WARN_ONCE in arch/x86/kernel/hw_breakpoint.c
Date: Mon, 20 May 2013 12:19:17 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

Hello

on 3.10-rc1 with the trinity fuzzer patched to exercise the 
perf_event_open() syscall I am triggering this WARN_ONCE:

[   75.864822] ------------[ cut here ]------------
[   75.864830] WARNING: at arch/x86/kernel/hw_breakpoint.c:121 arch_install_hw_breakpoint+0x5b/0xcb()
[   75.864832] Can't find any breakpoint slot
[   75.864833] Modules linked in: dn_rtmsg can_raw nfnetlink can_bcm can xfrm_user xfrm_algo nfc rfkill ax25 scsi_transport_iscsi atm ipt_ULOG x_tables ipx p8023 p8022 irda crc_ccitt appletalk psnap llc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd dns_resolver fscache sunrpc loop fuse snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm evdev nouveau mxm_wmi ttm drm_kms_helper video wmi drm i2c_algo_bit microcode snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd acpi_cpufreq mperf processor thermal_sys psmouse serio_raw pcspkr button soundcore shpchp i2c_nforce2 i2c_core ext4 crc16 jbd2 mbcache sg sd_mod crc_t10dif ata_generic ahci libahci ehci_pci ohci_hcd ehci_hcd libata r8169 mii scsi_mod usbcore usb_common
[   75.864890] CPU: 0 PID: 3136 Comm: trinity-child0 Not tainted 3.10.0-rc1 #1
[   75.864892] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[   75.864894]  0000000000000000 ffffffff8102e205 ffff880119b01c98 ffff880119abac00
[   75.864897]  ffff880119b01ce8 ffff88011fc15b28 0000000ed19e90a3 ffffffff8102e2b0
[   75.864900]  ffffffff814db382 0000000200000018 ffff880119b01cf8 ffff880119b01cb8
[   75.864903] Call Trace:
[   75.864907]  [<ffffffff8102e205>] ? warn_slowpath_common+0x5b/0x70
[   75.864910]  [<ffffffff8102e2b0>] ? warn_slowpath_fmt+0x47/0x49
[   75.864913]  [<ffffffff81055d08>] ? sched_clock_local+0xc/0x6d
[   75.864916]  [<ffffffff81006fff>] ? arch_install_hw_breakpoint+0x5b/0xcb
[   75.864919]  [<ffffffff810ab5a1>] ? event_sched_in+0x68/0x11c
[   75.864921]  [<ffffffff810ab69b>] ? group_sched_in+0x46/0x120
[   75.864923]  [<ffffffff810ab898>] ? ctx_sched_in+0x123/0x141
[   75.864926]  [<ffffffff810abdf1>] ? __perf_install_in_context+0xcb/0xea
[   75.864929]  [<ffffffff810a88b2>] ? perf_swevent_add+0xb8/0xb8
[   75.864932]  [<ffffffff810a88c5>] ? remote_function+0x13/0x3b
[   75.864934]  [<ffffffff8106fd87>] ? smp_call_function_single+0x76/0xf1
[   75.864937]  [<ffffffff810a803a>] ? task_function_call+0x42/0x4c
[   75.864939]  [<ffffffff810abd26>] ? perf_event_sched_in+0x69/0x69
[   75.864942]  [<ffffffff810aa018>] ? perf_install_in_context+0x5b/0x97
[   75.864945]  [<ffffffff810aecf0>] ? SYSC_perf_event_open+0x65f/0x7d4
[   75.864949]  [<ffffffff81369792>] ? system_call_fastpath+0x16/0x1b
[   75.864951] ---[ end trace 250def16d8853b8c ]---

Is this condition really drastic enough to deserve a WARNing?

Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
