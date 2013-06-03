From: Tommi Rantala <tt.rantala@gmail.com>
Subject: pipe->mutex & sig->cred_guard_mutex - possible circular locking
 dependency detected
Date: Mon, 3 Jun 2013 14:36:23 +0300
Message-ID: <CA+ydwtodJmqFNrFOva2_y_0kYTA5DAnM-uc_iQ7btQW2wqxv9w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=7HXiZJUUwrf6YARfJ6HK2iU8sZ+ZL+mkuSdnDjVwaCU=;
        b=frURuNoIcuLjLbC1ECiMaGAAY0WQBYU8NFrxVschT0lPm11rtkcQ71V3M7oK/ORBVx
         eDl5EMlaNd/hkAoAAtKVJhOvNTzwYSr6ICOXBms5yuc35PXXOdHqsCdB3BNecyNuIgIM
         N/HkatPzYJzy8BxKwct6du9LSsfIgk4dcnAX12qgSj/UkfZvMQ4IptSLjC1fG5eDp2pq
         ZDvDTJ4UKCj/OYAAJCupnJoytxJoRxziChKq+7Ztta+1QQ0XEOfjJ+k3mLz/GSERvKO1
         ShDM79heeu/0S0wXHGttRos87gFv9pdwnMGV7HSb1Jq3TKIwh7iT4nI65cc3KeBpqm09
         A5GQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

Hello,

Hit this while fuzzing v3.10-rc4-0-gd683b96 with trinity.

Tommi

[40303.740229]
[40303.740752] ======================================================
[40303.741014] [ INFO: possible circular locking dependency detected ]
[40303.741014] 3.10.0-rc4 #1 Not tainted
[40303.741014] -------------------------------------------------------
[40303.741014] trinity-child1/23450 is trying to acquire lock:
[40303.741014]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff8123a155>]
fifo_open+0xf5/0x340
[40303.741014]
[40303.741014] but task is already holding lock:
[40303.741014]  (&sig->cred_guard_mutex){+.+.+.}, at:
[<ffffffff812378d1>] prepare_bprm_creds+0x31/0x80
[40303.741014]
[40303.741014] which lock already depends on the new lock.
[40303.741014]
[40303.741014]
[40303.741014] the existing dependency chain (in reverse order) is:
[40303.741014]
-> #1 (&sig->cred_guard_mutex){+.+.+.}:
[40303.741014]        [<ffffffff81177d5a>] lock_acquire+0x19a/0x230
[40303.741014]        [<ffffffff8229e1b2>]
mutex_lock_interruptible_nested+0x72/0x430
[40303.741014]        [<ffffffff8129c042>] proc_pid_attr_write+0xc2/0x160
[40303.741014]        [<ffffffff81230f01>] __kernel_write+0x81/0x150
[40303.741014]        [<ffffffff812604ed>] write_pipe_buf+0x4d/0x80
[40303.741014]        [<ffffffff81261a7c>] splice_from_pipe_feed+0x8c/0x140
[40303.741014]        [<ffffffff81261c95>] __splice_from_pipe+0x45/0x80
[40303.741014]        [<ffffffff81261d1c>] splice_from_pipe+0x4c/0x70
[40303.741014]        [<ffffffff81261d54>] default_file_splice_write+0x14/0x20
[40303.741014]        [<ffffffff81260423>] do_splice_from+0xc3/0x120
[40303.741014]        [<ffffffff81262915>] SyS_splice+0x4b5/0x6b0
[40303.741014]        [<ffffffff822a2e29>] system_call_fastpath+0x16/0x1b
[40303.741014]
-> #0 (&pipe->mutex/1){+.+.+.}:
[40303.741014]        [<ffffffff8117593e>] __lock_acquire+0x135e/0x1bb0
[40303.741014]        [<ffffffff81177d5a>] lock_acquire+0x19a/0x230
[40303.741014]        [<ffffffff8229d632>] mutex_lock_nested+0x72/0x3a0
[40303.741014]        [<ffffffff8123a155>] fifo_open+0xf5/0x340
[40303.741014]        [<ffffffff8122e81c>] do_dentry_open+0x1cc/0x290
[40303.741014]        [<ffffffff8122f78a>] finish_open+0x4a/0x60
[40303.741014]        [<ffffffff8123f012>] do_last+0xb52/0xe40
[40303.741014]        [<ffffffff8123f673>] path_openat+0x373/0x4d0
[40303.741014]        [<ffffffff8123f80c>] do_filp_open+0x3c/0xa0
[40303.741014]        [<ffffffff81236d5e>] open_exec+0x4e/0x130
[40303.741014]        [<ffffffff812387e0>] do_execve_common.isra.22+0x670/0x6e0
[40303.741014]        [<ffffffff81238863>] do_execve+0x13/0x20
[40303.741014]        [<ffffffff81238b4e>] SyS_execve+0x3e/0x60
[40303.741014]        [<ffffffff822a3459>] stub_execve+0x69/0xa0
[40303.741014]
[40303.741014] other info that might help us debug this:
[40303.741014]
[40303.741014]  Possible unsafe locking scenario:
[40303.741014]
[40303.741014]        CPU0                    CPU1
[40303.741014]        ----                    ----
[40303.741014]   lock(&sig->cred_guard_mutex);
[40303.741014]                                lock(&pipe->mutex/1);
[40303.741014]                                lock(&sig->cred_guard_mutex);
[40303.741014]   lock(&pipe->mutex/1);
[40303.741014]
[40303.741014]  *** DEADLOCK ***
[40303.741014]
[40303.741014] 1 lock held by trinity-child1/23450:
[40303.741014]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at:
[<ffffffff812378d1>] prepare_bprm_creds+0x31/0x80
[40303.741014]
[40303.741014] stack backtrace:
[40303.741014] CPU: 0 PID: 23450 Comm: trinity-child1 Not tainted 3.10.0-rc4 #1
[40303.741014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[40303.741014]  ffffffff83504660 ffff8800964ad950 ffffffff8228e109
ffff8800964ad990
[40303.741014]  ffffffff8228744c ffff8800964ada10 ffff8800a3ccaaf0
ffff8800a3ccaab8
[40303.741014]  ffff8800a3cca3e0 000000000013230e 0000000000000000
ffff8800964ada78
[40303.741014] Call Trace:
[40303.741014]  [<ffffffff8228e109>] dump_stack+0x19/0x1b
[40303.741014]  [<ffffffff8228744c>] print_circular_bug+0x1f9/0x208
[40303.741014]  [<ffffffff8117593e>] __lock_acquire+0x135e/0x1bb0
[40303.741014]  [<ffffffff811705d8>] ? graph_unlock+0x98/0xb0
[40303.741014]  [<ffffffff81177d5a>] lock_acquire+0x19a/0x230
[40303.741014]  [<ffffffff8123a155>] ? fifo_open+0xf5/0x340
[40303.741014]  [<ffffffff8229d632>] mutex_lock_nested+0x72/0x3a0
[40303.741014]  [<ffffffff8123a155>] ? fifo_open+0xf5/0x340
[40303.741014]  [<ffffffff81171188>] ? lock_release_holdtime+0x28/0x1a0
[40303.741014]  [<ffffffff8123a155>] ? fifo_open+0xf5/0x340
[40303.741014]  [<ffffffff814deb67>] ? do_raw_spin_unlock+0xa7/0xc0
[40303.741014]  [<ffffffff8123a155>] fifo_open+0xf5/0x340
[40303.741014]  [<ffffffff8122e81c>] do_dentry_open+0x1cc/0x290
[40303.741014]  [<ffffffff8123a060>] ? pipe_release+0x110/0x110
[40303.741014]  [<ffffffff8122f78a>] finish_open+0x4a/0x60
[40303.741014]  [<ffffffff8123f012>] do_last+0xb52/0xe40
[40303.741014]  [<ffffffff81146e3b>] ? lg_local_unlock+0x2b/0x40
[40303.741014]  [<ffffffff81251c24>] ? mntput_no_expire+0x44/0x130
[40303.741014]  [<ffffffff81252625>] ? mntput+0x35/0x40
[40303.741014]  [<ffffffff8123f673>] path_openat+0x373/0x4d0
[40303.741014]  [<ffffffff81173058>] ? trace_hardirqs_off_caller+0x28/0xe0
[40303.741014]  [<ffffffff8123f80c>] do_filp_open+0x3c/0xa0
[40303.741014]  [<ffffffff8115219d>] ? sched_clock_local+0x1d/0x90
[40303.741014]  [<ffffffff8117311d>] ? trace_hardirqs_off+0xd/0x10
[40303.741014]  [<ffffffff8115251a>] ? local_clock+0x4a/0x70
[40303.741014]  [<ffffffff81236d5e>] open_exec+0x4e/0x130
[40303.741014]  [<ffffffff812387e0>] do_execve_common.isra.22+0x670/0x6e0
[40303.741014]  [<ffffffff81238267>] ? do_execve_common.isra.22+0xf7/0x6e0
[40303.741014]  [<ffffffff81238863>] do_execve+0x13/0x20
[40303.741014]  [<ffffffff81238b4e>] SyS_execve+0x3e/0x60
[40303.741014]  [<ffffffff822a3459>] stub_execve+0x69/0xa0
