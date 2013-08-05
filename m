From: Sasha Levin <sasha.levin@oracle.com>
Subject: percpu: kernel BUG at mm/percpu.c:579!
Date: Mon, 05 Aug 2013 10:49:33 -0400
Message-ID: <51FFBB7D.70608@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
I've stumbled on the following spew:

[  274.820724] ------------[ cut here ]------------
[  274.821320] kernel BUG at mm/percpu.c:579!
[  274.821848] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  274.822467] Modules linked in:
[  274.823240] CPU: 13 PID: 58 Comm: rcuos/13 Tainted: G        W 
3.11.0-rc4-next-20130805-sasha-00002-gf6cc217 #3975
[  274.824464] task: ffff880220cb3000 ti: ffff880220cba000 task.ti: ffff880220cba000
[  274.825442] RIP: 0010:[<ffffffff812417b8>]  [<ffffffff812417b8>] pcpu_free_area+0xd8/0x1e0
[  274.826470] RSP: 0018:ffff880220cbbc58  EFLAGS: 00010002
[  274.827316] RAX: ffff8800c9e3abd4 RBX: 00000000000002f5 RCX: 00000000000002f5
[  274.828162] RDX: 0000000000000004 RSI: 000000000000ede0 RDI: 000000000000ede0
[  274.829270] RBP: ffff880220cbbc78 R08: 0000000000000324 R09: ffff8800c9e3a000
[  274.830102] R10: ffff8800c9e3a000 R11: 0000000000000000 R12: ffff88022049ff80
[  274.830102] R13: 0000000000000bd4 R14: 0000000000000012 R15: ffffffff86612060
[  274.831367] FS:  0000000000000000(0000) GS:ffff880226000000(0000) knlGS:0000000000000000
[  274.831367] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  274.831367] CR2: 0000000001253028 CR3: 0000000214aff000 CR4: 00000000000006e0
[  274.831367] Stack:
[  274.831367]  0000000000000282 000000000000ede0 ffff88022049ff80 000060fdd980ede0
[  274.831367]  ffff880220cbbca8 ffffffff81241c7e ffff880220cbbca8 ffff8800b80f83e0
[  274.831367]  0000000000000000 ffff8800b80f83c0 ffff880220cbbd18 ffffffff81a14ea6
[  274.831367] Call Trace:
[  274.831367]  [<ffffffff81241c7e>] free_percpu+0x9e/0x160
[  274.831367]  [<ffffffff81a14ea6>] percpu_ref_kill_rcu+0xb6/0x1b0
[  274.831367]  [<ffffffff8114e390>] ? wake_up_bit+0x40/0x40
[  274.831367]  [<ffffffff81a14df0>] ? percpu_ref_init+0x50/0x50
[  274.831367]  [<ffffffff811d4169>] rcu_nocb_kthread+0x449/0x520
[  274.831367]  [<ffffffff8114e390>] ? wake_up_bit+0x40/0x40
[  274.831367]  [<ffffffff811d3d20>] ? rcu_adopt_orphan_cbs+0x250/0x250
[  274.831367]  [<ffffffff8114dac7>] kthread+0xe7/0xf0
[  274.831367]  [<ffffffff81197a2a>] ? __lock_release+0x1da/0x1f0
[  274.831367]  [<ffffffff8114d9e0>] ? __init_kthread_worker+0x70/0x70
[  274.831367]  [<ffffffff840a132c>] ret_from_fork+0x7c/0xb0
[  274.831367]  [<ffffffff8114d9e0>] ? __init_kthread_worker+0x70/0x70
[  274.831367] Code: 39 f7 74 0f 0f 0b 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 4d 89 ca 48 63 cb 4c 
8d 2c 8d 00 00 00 00 4b 8d 04 2a 8b 10 85 d2 7e 10 <0f> 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 
f7 da 89 10 49
[  274.850289] RIP  [<ffffffff812417b8>] pcpu_free_area+0xd8/0x1e0
[  274.850289]  RSP <ffff880220cbbc58>
[  274.850289] ---[ end trace 47f7ab405c6aeff4 ]---


Thanks,
Sasha
