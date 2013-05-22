From: Vince Weaver <vincent.weaver@maine.edu>
Subject: OOPS in perf_mmap_close()
Date: Wed, 22 May 2013 15:35:41 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

Hello

I was fuzzing the kernel using my "perf_fuzzer" tool that builds on top of
the trinity fuzzer.  (You can get it as part of of my perf_event_test
suite https://github.com/deater/perf_event_tests )

In any case while letting it run I got the following OOPS on 
Linux 3.10-rc2

[142450.070877] IP: [<ffffffff810a9859>] perf_mmap_close+0x52/0xa8
[142450.070890] PGD 59a8067 PUD 2947067 PMD 0 
[142450.070899] Oops: 0002 [#1] SMP 
[142450.070906] Modules linked in: bluetooth msr cpufreq_stats dn_rtmsg can_raw nfnetlink can_bcm can xfrm_user xfrm_algo nfc rfkill ax25 scsi_transport_iscsi atm ipt_ULOG x_tables ipx p8023 p8022 irda crc_ccitt appletalk psnap llc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd dns_resolver fscache sunrpc loop fuse snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel kvm evdev nouveau mxm_wmi ttm drm_kms_helper microcode drm i2c_algo_bit video snd_hda_intel snd_hda_codec wmi snd_hwdep snd_pcm snd_page_alloc snd_seq snd_seq_device snd_timer snd psmouse serio_raw acpi_cpufreq mperf processor thermal_sys button pcspkr i2c_nforce2 shpchp soundcore i2c_core ext4 crc16 jbd2 mbcache sg sd_mod crc_t10dif ata_generic r8169 mii ahci libahci ehci_pci ohci_hcd ehci_hcd libata scsi_mod usbcore 
 usb_common
[142450.071099] CPU: 0 PID: 2539 Comm: perf_fuzzer Tainted: G             3.10.0-rc2 #2
[142450.071106] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[142450.071113] task: ffff880119e25830 ti: ffff880005aea000 task.ti: ffff880005aea000
[142450.071120] RIP: 0010:[<ffffffff810a9859>]  [<ffffffff810a9859>] perf_mmap_close+0x52/0xa8
[142450.071131] RSP: 0018:ffff880005aebea8  EFLAGS: 00010202[142450.071136] RAX: 0000000000000001 RBX: ffff88000455e800 RCX: ffffffffffffffff
[142450.071143] RDX: ffff880004732ac0 RSI: ffff88000455ea30 RDI: ffff88000455ea30
[142450.071151] RBP: 0000000000000000 R08: 00007f5adc87b000 R09: 00007f5adc87a000
[142450.071157] R10: ffff880119684ce0 R11: 0000000000000206 R12: ffff880118697bc0
[142450.071164] R13: ffff88000455ea30 R14: ffff880119684cc0 R15: ffff880118796368
[142450.071171] FS:  00007f5adc881700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[142450.071178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[142450.071184] CR2: 0000000000000060 CR3: 00000000029f1000 CR4: 00000000000407f0
[142450.071190] DR0: 000000000b73c476 DR1: 000000000a837586 DR2: 00000000481f91c8
[142450.071197] DR3: 000000005519375a DR6: 00000000ffff0ff0 DR7: 000000000051060a
[142450.071203] Stack:
[142450.071206]  ffff880119684cc0 0000000000000000 0000000000000000 00007f5adc87a000
[142450.071218]  00007f5adc87b000 ffffffff810d2ce0 ffff880117183740 ffff880119684cc0
[142450.071229]  ffffffff810d4342 ffff880119684cc0 ffff8801196c3430 ffff880117183748
[142450.071241] Call Trace:
[142450.071248]  [<ffffffff810d2ce0>] ? remove_vma+0x28/0x5f
[142450.071255]  [<ffffffff810d4342>] ? do_munmap+0x2d5/0x306
[142450.071262]  [<ffffffff810d43ab>] ? vm_munmap+0x38/0x4e
[142450.071268]  [<ffffffff810d43db>] ? SyS_munmap+0x1a/0x1f
[142450.071276]  [<ffffffff81369b12>] ? system_call_fastpath+0x16/0x1b
[142450.071281] Code: 4c 89 ee e8 3e 21 fa ff 85 c0 74 6c 4c 8b a3 68 02 00 00 48 8b ab 60 02 00 00 41 8b 44 24 18 c1 e0 0c 48 98 48 c1 e8 0c 48 ff c0 <f0> 48 29 45 60 49 8b 46 40 48 63 93 5c 02 00 00 48 29 90 b8 00 
[142450.071382] RIP  [<ffffffff810a9859>] perf_mmap_close+0x52/0xa8
[142450.071390]  RSP <ffff880005aebea8>
[142450.071394] CR2: 0000000000000060
[142450.073009] ---[ end trace a49b6a0053924d8b ]---

Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
