From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: f2fs get_dnode_of_data oops
Date: Tue, 9 Sep 2014 21:24:18 +0300
Message-ID: <CA+ydwtpPcG0vDhVrT6eAsgXtdEJg=_SbK6Bry2c5OYqe+Y+H_g@mail.gmail.com>
References: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
	<CA+ydwtrtyb5wQXCmyBigqufVz10UkKS76hVOY8mKc4FOyYmECw@mail.gmail.com>
	<20140908042056.GA13863@jaegeuk-mac02.hsd1.ca.comcast.net>
	<CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
	<20140909044157.GA24581@jaegeuk-mac02.hsd1.ca.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20140909044157.GA24581@jaegeuk-mac02.hsd1.ca.comcast.net>
List-Id: <trinity.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net

2014-09-09 7:41 GMT+03:00 Jaegeuk Kim <jaegeuk@kernel.org>:
> Hi Tommi,
>
> This patch should resolve this bug.
> Thanks a lot. :)
>
> From ee24677b9917583f50f16b6f59771439f91b890c Mon Sep 17 00:00:00 2001
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> Date: Mon, 8 Sep 2014 10:59:43 -0700
> Subject: [PATCH] f2fs: fix negative value for lseek offset
>

Thanks, with this patch applied, I could not reproduce the lseek oops,
but now I hit the following:


[  720.673788] ------------[ cut here ]------------
[  720.674011] kernel BUG at fs/f2fs/node.c:1229!
[  720.674011] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  720.674011] CPU: 0 PID: 5298 Comm: trinity-c15 Not tainted 3.17.0-rc4+ #38
[  720.674011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  720.674011] task: ffff88002c468000 ti: ffff88002c470000 task.ti:
ffff88002c470000
[  720.674011] RIP: 0010:[<ffffffff81776681>]  [<ffffffff81776681>]
f2fs_write_node_page+0x171/0x290
[  720.674011] RSP: 0018:ffff88002c473cb0  EFLAGS: 00010206
[  720.674011] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffea00006173c0
[  720.674011] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffea00006173c0
[  720.674011] RBP: ffff88002c473cf8 R08: 0000000000000000 R09: 0000000000000000
[  720.674011] R10: 0000000000000001 R11: ffff8800185cf000 R12: ffffea00006173c0
[  720.674011] R13: ffff8800399d4520 R14: ffff88002c473e68 R15: ffff8800185cf000
[  720.674011] FS:  00007fb4b61d4700(0000) GS:ffff88003fa00000(0000)
knlGS:0000000000000000
[  720.674011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  720.674011] CR2: 0000000000000008 CR3: 000000002c450000 CR4: 00000000000006f0
[  720.674011] DR0: 0000000001ee3000 DR1: 00000000019d3000 DR2: 0000000000000000
[  720.674011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  720.674011] Stack:
[  720.674011]  ffffffff81189e75 0000041100000001 ffff880037cb10a8
ffff88002c473cd8
[  720.674011]  ffff880000000000 0000160000000000 ffff88002c473d58
0000000000000000
[  720.674011]  0000000000000001 ffff88002c473df0 ffffffff81778745
0000000000000000
[  720.674011] Call Trace:
[  720.674011]  [<ffffffff81189e75>] ? trace_hardirqs_on_caller+0x185/0x220
[  720.674011]  [<ffffffff81778745>] sync_node_pages+0x415/0x5f0
[  720.674011]  [<ffffffff812b2790>] ? SyS_tee+0x390/0x390
[  720.674011]  [<ffffffff8176f52d>] write_checkpoint+0x21d/0xeb0
[  720.674011]  [<ffffffff81189ce0>] ? mark_held_locks+0x90/0xa0
[  720.674011]  [<ffffffff82597685>] ? mutex_lock_nested+0x435/0x4b0
[  720.674011]  [<ffffffff81189e75>] ? trace_hardirqs_on_caller+0x185/0x220
[  720.674011]  [<ffffffff812b2790>] ? SyS_tee+0x390/0x390
[  720.674011]  [<ffffffff81769680>] f2fs_sync_fs+0x100/0x180
[  720.674011]  [<ffffffff812b27ab>] sync_fs_one_sb+0x1b/0x20
[  720.674011]  [<ffffffff8128198f>] iterate_supers+0x7f/0xe0
[  720.674011]  [<ffffffff812b2a00>] sys_sync+0x50/0x90
[  720.674011]  [<ffffffff8259cae9>] system_call_fastpath+0x16/0x1b
[  720.674011] Code: 63 00 00 48 b8 00 00 00 00 00 16 00 00 4c 01 e0
48 c1 f8 06 48 c1 e0 0c 49 01 c7 41 8b 9f e8 0f 00 00 89 d8 49 39 44
24 10 74 07 <0f> 0b 0f 1f 44 00 00 48 8d 55 c8 89 de 4c 89 ef e8 3a fb
ff ff
[  720.674011] RIP  [<ffffffff81776681>] f2fs_write_node_page+0x171/0x290
[  720.674011]  RSP <ffff88002c473cb0>
[  720.674011] ------------[ cut here ]------------
[  720.674011] kernel BUG at arch/x86/mm/pageattr.c:216!
[  720.674011] invalid opcode: 0000 [#2] SMP DEBUG_PAGEALLOC
[  720.674011] CPU: 0 PID: 5298 Comm: trinity-c15 Not tainted 3.17.0-rc4+ #38
[  720.674011] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  720.674011] task: ffff88002c468000 ti: ffff88002c470000 task.ti:
ffff88002c470000
[  720.674011] RIP: 0010:[<ffffffff810b0fe0>]  [<ffffffff810b0fe0>]
change_page_attr_set_clr+0x250/0x430
[  720.674011] RSP: 0018:ffff88002c4730b8  EFLAGS: 00010046
[  720.674011] RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000010
[  720.674011] RDX: 0000000000004600 RSI: 0000000000000000 RDI: 0000000080000000
[  720.674011] RBP: ffff88002c473148 R08: 0000000000000001 R09: ffff880000000000
[  720.674011] R10: ffff880034780738 R11: ffff88000e526610 R12: 0000000000000000
[  720.674011] R13: 0000000000000010 R14: 0000000000000004 R15: 0000000000000005
[  720.674011] FS:  00007fb4b61d4700(0000) GS:ffff88003fa00000(0000)
knlGS:0000000000000000
[  720.674011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  720.674011] CR2: 0000000000000008 CR3: 000000002c450000 CR4: 00000000000006f0
[  720.674011] DR0: 0000000001ee3000 DR1: 00000000019d3000 DR2: 0000000000000000
[  720.674011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  720.674011] Stack:
[  720.674011]  0000000000000000 0000000000000000 0000000000000000
ffffffff00000200
[  720.674011]  ffff880000000001 0000000000000000 0000000000000000
0000000000000010
[  720.674011]  0000000000000000 0000000500000001 0000000000005d4d
0000020000000000
[  720.674011] Call Trace:
[  720.674011]  [<ffffffff810b1396>] _set_pages_array+0x86/0x130
[  720.674011]  [<ffffffff810b1a3e>] set_pages_array_wc+0xe/0x10
[  720.674011]  [<ffffffff81965487>] ttm_set_pages_caching+0x47/0x70
[  720.674011]  [<ffffffff819655f3>] ttm_alloc_new_pages.isra.4+0xf3/0x190
[  720.674011]  [<ffffffff81965ff5>] ttm_pool_populate+0x1b5/0x490
[  720.674011]  [<ffffffff81ae0c59>] cirrus_ttm_tt_populate+0x9/0x10
[  720.674011]  [<ffffffff81961a03>] ttm_bo_move_memcpy+0x183/0x640
[  720.674011]  [<ffffffff81ae0ba3>] cirrus_bo_move+0x13/0x20
[  720.674011]  [<ffffffff8195f081>] ttm_bo_handle_move_mem+0x251/0x590
[  720.674011]  [<ffffffff8196029c>] ? ttm_bo_mem_space+0xbc/0x310
[  720.674011]  [<ffffffff8196093d>] ttm_bo_validate+0x1bd/0x2c0
[  720.674011]  [<ffffffff81ae128c>] cirrus_bo_push_sysram+0x8c/0xd0
[  720.674011]  [<ffffffff81adf609>]
cirrus_crtc_do_set_base.isra.7.constprop.9+0x89/0x3e0
[  720.674011]  [<ffffffff81adfde1>] cirrus_crtc_mode_set+0x481/0x4b0
[  720.674011]  [<ffffffff819326f9>] drm_crtc_helper_set_mode+0x299/0x530
[  720.674011]  [<ffffffff819330ab>] drm_crtc_helper_set_config+0x71b/0xa60
[  720.674011]  [<ffffffff8194d82d>] drm_mode_set_config_internal+0x3d/0x100
[  720.674011]  [<ffffffff8193b3c3>] drm_fb_helper_pan_display+0x93/0xe0
[  720.674011]  [<ffffffff81884034>] fb_pan_display+0x104/0x170
[  720.674011]  [<ffffffff818807fb>] bit_update_start+0x1b/0x50
[  720.674011]  [<ffffffff8187f1ba>] fbcon_switch+0x50a/0x530
[  720.674011]  [<ffffffff8190e979>] redraw_screen+0x129/0x250
[  720.674011]  [<ffffffff81884566>] ? fb_blank+0x66/0xa0
[  720.674011]  [<ffffffff8187d75f>] fbcon_blank+0x20f/0x2d0
[  720.674011]  [<ffffffff8259bbbd>] ? _raw_spin_lock_irqsave+0x7d/0x90
[  720.674011]  [<ffffffff81189f3f>] ? trace_hardirqs_off_caller+0x1f/0xd0
[  720.674011]  [<ffffffff8118a25d>] ? trace_hardirqs_off+0xd/0x10
[  720.674011]  [<ffffffff8259bd3b>] ? _raw_spin_unlock_irqrestore+0x3b/0x60
[  720.674011]  [<ffffffff811a7951>] ? mod_timer+0x221/0x2a0
[  720.674011]  [<ffffffff819109a8>] do_unblank_screen+0x108/0x1e0
[  720.674011]  [<ffffffff81910a8b>] unblank_screen+0xb/0x10
[  720.674011]  [<ffffffff81834399>] bust_spinlocks+0x19/0x30
[  720.674011]  [<ffffffff8106e307>] oops_end+0x37/0x150
[  720.674011]  [<ffffffff8106e565>] die+0x55/0x60
[  720.674011]  [<ffffffff8106acc3>] do_trap+0x63/0x150
[  720.674011]  [<ffffffff8106ae83>] do_error_trap+0xd3/0xf0
[  720.674011]  [<ffffffff81776681>] ? f2fs_write_node_page+0x171/0x290
[  720.674011]  [<ffffffff81832fbd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  720.674011]  [<ffffffff8106b24b>] do_invalid_op+0x1b/0x20
[  720.674011]  [<ffffffff8259e53e>] invalid_op+0x1e/0x30
[  720.674011]  [<ffffffff81776681>] ? f2fs_write_node_page+0x171/0x290
[  720.674011]  [<ffffffff81189e75>] ? trace_hardirqs_on_caller+0x185/0x220
[  720.674011]  [<ffffffff81778745>] sync_node_pages+0x415/0x5f0
[  720.674011]  [<ffffffff812b2790>] ? SyS_tee+0x390/0x390
[  720.674011]  [<ffffffff8176f52d>] write_checkpoint+0x21d/0xeb0
[  720.674011]  [<ffffffff81189ce0>] ? mark_held_locks+0x90/0xa0
[  720.674011]  [<ffffffff82597685>] ? mutex_lock_nested+0x435/0x4b0
[  720.674011]  [<ffffffff81189e75>] ? trace_hardirqs_on_caller+0x185/0x220
[  720.674011]  [<ffffffff812b2790>] ? SyS_tee+0x390/0x390
[  720.674011]  [<ffffffff81769680>] f2fs_sync_fs+0x100/0x180
[  720.674011]  [<ffffffff812b27ab>] sync_fs_one_sb+0x1b/0x20
[  720.674011]  [<ffffffff8128198f>] iterate_supers+0x7f/0xe0
[  720.674011]  [<ffffffff812b2a00>] sys_sync+0x50/0x90
[  720.674011]  [<ffffffff8259cae9>] system_call_fastpath+0x16/0x1b
[  720.674011] Code: e6 06 0f 84 f3 00 00 00 85 c9 41 0f 95 c4 81 7d
88 ff 03 00 00 0f 9f c0 41 21 c4 41 0f b6 f4 9c 58 0f 1f 44 00 00 f6
c4 02 75 08 <0f> 0b 66 0f 1f 44 00 00 ba 01 00 00 00 48 c7 c7 d0 f2 0a
81 89
[  720.674011] RIP  [<ffffffff810b0fe0>] change_page_attr_set_clr+0x250/0x430
[  720.674011]  RSP <ffff88002c4730b8>
[  720.674011] ---[ end trace 7dd145ad962d6c6d ]---

------------------------------------------------------------------------------
Want excitement?
Manually upgrade your production database.
When you want reliability, choose Perforce.
Perforce version control. Predictably reliable.
http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
