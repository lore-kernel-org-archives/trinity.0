From: Vince Weaver <vincent.weaver@maine.edu>
Subject: WARNING in arch/x86/kernel/cpu/perf_event.c
Date: Thu, 23 May 2013 10:29:07 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305231023240.17701@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

Hello,

so now that I got past the OOPS in perf_mmap_close() I re-ran
the fuzzer and quickly encountered the following WARNing.

It happens here:

static void x86_pmu_start(struct perf_event *event, int flags)
{
        struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
        int idx = event->hw.idx;

        if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
                return;


Is it worth trying to come up with a reproducible case for this one?

I never know how seriously to take WARN_ON_ONCE dumps.

Vince


[ 1067.776086] ------------[ cut here ]------------
[ 1067.776109] WARNING: at arch/x86/kernel/cpu/perf_event.c:1054 x86_pmu_start+0x4a/0xff()
[ 1067.776113] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd dns_resolver fscache sunrpc loop fuse snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm evdev nouveau microcode mxm_wmi ttm drm_kms_helper drm i2c_algo_bit video wmi snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd psmouse acpi_cpufreq mperf serio_raw processor thermal_sys button i2c_nforce2 pcspkr soundcore i2c_core shpchp ext4 crc16 jbd2 mbcache sg sd_mod crc_t10dif ata_generic ahci libahci r8169 mii ohci_hcd ehci_pci ehci_hcd libata scsi_mod usbcore usb_common
[ 1067.776241] CPU: 0 PID: 3032 Comm: perf_fuzzer Not tainted 3.10.0-rc2 #3
[ 1067.776246] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[ 1067.776251]  0000000000000000 ffffffff8102e205 0000000000000000 ffff88011a1bf400
[ 1067.776261]  ffff88011fc0b9a0 0000000000000021 0000000000000000 ffffffff8100d870
[ 1067.776269]  ffff88011a1bf400 ffff88011fc0b9a0 ffff88011fc0b9a0 ffffffff8100de65
[ 1067.776278] Call Trace:
[ 1067.776291]  [<ffffffff8102e205>] ? warn_slowpath_common+0x5b/0x70
[ 1067.776300]  [<ffffffff8100d870>] ? x86_pmu_start+0x4a/0xff
[ 1067.776308]  [<ffffffff8100de65>] ? x86_pmu_enable+0x1aa/0x257
[ 1067.776318]  [<ffffffff810ac160>] ? perf_event_context_sched_in+0x6f/0x90
[ 1067.776326]  [<ffffffff810ac19e>] ? __perf_event_task_sched_in+0x1d/0x118
[ 1067.776335]  [<ffffffff81051a2d>] ? finish_task_switch+0x9d/0xa6
[ 1067.776346]  [<ffffffff81363f13>] ? __schedule+0x492/0x51b
[ 1067.776355]  [<ffffffff81362f47>] ? console_conditional_schedule+0xf/0xf
[ 1067.776362]  [<ffffffff81362f73>] ? schedule_timeout+0x2c/0x11c
[ 1067.776372]  [<ffffffff810a9aad>] ? list_del_event+0x9d/0xac
[ 1067.776381]  [<ffffffff810aa5d9>] ? __perf_remove_from_context+0x71/0x7a
[ 1067.776389]  [<ffffffff810a898e>] ? perf_swevent_add+0xb8/0xb8
[ 1067.776397]  [<ffffffff810a89a1>] ? remote_function+0x13/0x3b
[ 1067.776405]  [<ffffffff8136408a>] ? __wait_for_common+0x9d/0x118
[ 1067.776413]  [<ffffffff810544d9>] ? try_to_wake_up+0x192/0x192
[ 1067.776424]  [<ffffffff810918ac>] ? __call_rcu.constprop.51+0x1c1/0x1c1
[ 1067.776434]  [<ffffffff81047668>] ? wait_rcu_gp+0x3e/0x44
[ 1067.776442]  [<ffffffff8104766e>] ? wait_rcu_gp+0x44/0x44
[ 1067.776451]  [<ffffffff810aed42>] ? SYSC_perf_event_open+0x6e9/0x7d4
[ 1067.776462]  [<ffffffff81369b92>] ? system_call_fastpath+0x16/0x1b
[ 1067.776467] ---[ end trace 01e912b9e47ce3eb ]---
