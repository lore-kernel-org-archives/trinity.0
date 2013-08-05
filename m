From: Sasha Levin <sasha.levin@oracle.com>
Subject: aio: kernel BUG at fs/aio.c:646!
Date: Mon, 05 Aug 2013 09:57:08 -0400
Message-ID: <51FFAF34.20200@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: koverstreet@google.com, axboe@kernel.dk, bcrl@kvack.org, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-aio@kvack.org, trinity@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
I've stumbled on the following spew caused by a new BUG() added in "aio: fix
io_destroy() regression by using call_rcu()".

[ 9646.599640] kernel BUG at fs/aio.c:646!
[ 9646.600119] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 9646.600119] Modules linked in:
[ 9646.600119] CPU: 3 PID: 16833 Comm: trinity-child45 Tainted: G        W 
3.11.0-rc3-next-20130802-sasha-00001-g5e30de1-dirty #3974
[ 9646.600119] task: ffff8800c4da0000 ti: ffff8800c4d9a000 task.ti: ffff8800c4d9a000
[ 9646.600119] RIP: 0010:[<ffffffff812ee8e1>]  [<ffffffff812ee8e1>] kill_ioctx+0xb1/0x100
[ 9646.600119] RSP: 0018:ffff8800c4d9be08  EFLAGS: 00010287
[ 9646.600119] RAX: ffffffffffffd866 RBX: ffff8800c3628b40 RCX: 0000000000000003
[ 9646.600119] RDX: 0000000000014cf4 RSI: 0000000000000000 RDI: 0000000000000282
[ 9646.600119] RBP: ffff8800c4d9be28 R08: 0000000000000000 R09: 0000000000000001
[ 9646.600119] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800ca30c8c0
[ 9646.609819] R13: ffff8800c4c9d438 R14: ffff8800c3628b40 R15: ffff8800ca30c8c0
[ 9646.609819] FS:  0000000000000000(0000) GS:ffff880224c00000(0000) knlGS:0000000000000000
[ 9646.609819] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9646.609819] CR2: 0000000000000001 CR3: 00000000c4d6b000 CR4: 00000000000006e0
[ 9646.609819] Stack:
[ 9646.609819]  ffff8800c4d9be28 0000000000000001 ffff8800c4c9d000 ffff8800c4c9d480
[ 9646.609819]  ffff8800c4d9be78 ffffffff812ef2c0 ffffffff812ef202 0000000000000282
[ 9646.609819]  ffff8800c4c9d040 ffff8800c4c9d000 ffff8800c4da0000 ffff8800c4c9d000
[ 9646.609819] Call Trace:
[ 9646.609819]  [<ffffffff812ef2c0>] exit_aio+0xe0/0x100
[ 9646.609819]  [<ffffffff812ef202>] ? exit_aio+0x22/0x100
[ 9646.609819]  [<ffffffff81120bc1>] mmput+0x41/0xf0
[ 9646.609819]  [<ffffffff81124c2d>] exit_mm+0x18d/0x1a0
[ 9646.609819]  [<ffffffff811a9db5>] ? acct_collect+0x175/0x1b0
[ 9646.609819]  [<ffffffff811253aa>] do_exit+0x24a/0x4d0
[ 9646.609819]  [<ffffffff811256d9>] do_group_exit+0xa9/0xe0
[ 9646.609819]  [<ffffffff81125727>] SyS_exit_group+0x17/0x20
[ 9646.609819]  [<ffffffff8409d82c>] tracesys+0xdd/0xe2
[ 9646.609819] Code: 8d bb 68 02 00 00 be 03 00 00 00 e8 3a bf e6 ff 48 c7 c7 20 e8 0a 86 e8 3e 54 
da 02 48 8b 05 cf 89 19 06 8b 53 4c 48 29 d0 73 0f <0f> 0b 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 48 
89 05 b1 89 19
[ 9646.609819] RIP  [<ffffffff812ee8e1>] kill_ioctx+0xb1/0x100
[ 9646.609819]  RSP <ffff8800c4d9be08>


Thanks,
Sasha
