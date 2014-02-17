From: Tommi Rantala <tt.rantala@gmail.com>
Subject: btrfs "possible irq lock inversion dependency detected"
Date: Mon, 17 Feb 2014 22:09:51 +0200
Message-ID: <20140217200951.GB20312@optiplex>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=TYiaE0D3Q7uDE62XCj2xYBeNAhWqw47GJk3wNM9OUgI=;
        b=QPoqgsdVfDKs7IahB6oggjON7iuqUolEhB1lzjTKRmS/sy/kSzdKI+4O8XajZ75O3T
         1745bYA7wmgh8eOLQBSfVd+RDpklL1MFTgGQktjrns0voRYvaoi1GNTlPzsukpS+/UU5
         aPsB1v9xNVCmf7UfprOkwuENOjC0r/ZE7b3rHdP861MDiK/4bYHTtkbi/cbz79kHqwED
         Yv5gfWc+4S0jXSu+Mty5Vsd/PnZYxt0KkLXn32pMOSw4W+WL+7KJkTX8OnqQkj0MZo/g
         aE/XyxyYE6LkGYgFkCvzi6Jzm0q4QzcqELaZn3Opgj862B3mGhS6FXy0ORs0jU37TJ9H
         rhWg==
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

Saw this while fuzzing the kernel with Trinity.

Tommi


[  396.136048] =========================================================
[  396.136048] [ INFO: possible irq lock inversion dependency detected ]
[  396.136048] 3.14.0-rc3 #1 Not tainted
[  396.136048] ---------------------------------------------------------
[  396.136048] kswapd0/1482 just changed the state of lock:
[  396.136048]  (&delayed_node->mutex){+.+.-.}, at: [<ffffffff8147b83b>] __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[  396.136048]  (&found->groups_sem){+++++.}

and interrupts could create inverse lock ordering between them.

[  396.136048]
[  396.136048] other info that might help us debug this:
[  396.136048]  Possible interrupt unsafe locking scenario:
[  396.136048]
[  396.136048]        CPU0                    CPU1
[  396.136048]        ----                    ----
[  396.136048]   lock(&found->groups_sem);
[  396.136048]                                local_irq_disable();
[  396.136048]                                lock(&delayed_node->mutex);
[  396.136048]                                lock(&found->groups_sem);
[  396.136048]   <Interrupt>
[  396.136048]     lock(&delayed_node->mutex);
[  396.136048]
[  396.136048]  *** DEADLOCK ***
[  396.136048]
[  396.136048] 2 locks held by kswapd0/1482:
[  396.136048]  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8122642a>] shrink_slab+0x3a/0x170
[  396.136048]  #1:  (&type->s_umount_key#25){++++.+}, at: [<ffffffff8127736f>] grab_super_passive+0x4f/0x80
[  396.136048]
[  396.136048] the shortest dependencies between 2nd lock and 1st lock:
[  396.136048]  -> (&found->groups_sem){+++++.} ops: 38935 {
[  396.136048]     HARDIRQ-ON-W at:
[  396.136048]                       [<ffffffff811939de>] __lock_acquire+0x88e/0x1d90
[  396.136048]                       [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                       [<ffffffff8237c62c>] down_write+0x5c/0xc0
[  396.136048]                       [<ffffffff81413f9d>] __link_block_group+0x3d/0xf0
[  396.136048]                       [<ffffffff81418232>] btrfs_read_block_groups+0x392/0x690
[  396.136048]                       [<ffffffff81426ba7>] open_ctree+0x1ad7/0x2140
[  396.136048]                       [<ffffffff813fadbe>] btrfs_mount+0x44e/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff813fb1a1>] btrfs_mount+0x831/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff8129a7f4>] do_mount+0x954/0xb90
[  396.136048]                       [<ffffffff8129ad04>] SyS_mount+0x94/0xe0
[  396.136048]                       [<ffffffff82ff539a>] do_mount_root+0x1a/0x93
[  396.136048]                       [<ffffffff82ff54f8>] mount_block_root+0xe5/0x203
[  396.136048]                       [<ffffffff82ff56f7>] mount_root+0xe1/0xea
[  396.136048]                       [<ffffffff82ff583c>] prepare_namespace+0x13c/0x174
[  396.136048]                       [<ffffffff82ff52a7>] kernel_init_freeable+0x242/0x251
[  396.136048]                       [<ffffffff82355509>] kernel_init+0x9/0xf0
[  396.136048]                       [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]     HARDIRQ-ON-R at:
[  396.136048]                       [<ffffffff81193997>] __lock_acquire+0x847/0x1d90
[  396.136048]                       [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                       [<ffffffff8237c57c>] down_read+0x4c/0xa0
[  396.136048]                       [<ffffffff8142327a>] btrfs_calc_num_tolerated_disk_barrier_failures+0x24a/0x310
[  396.136048]                       [<ffffffff81426bdf>] open_ctree+0x1b0f/0x2140
[  396.136048]                       [<ffffffff813fadbe>] btrfs_mount+0x44e/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff813fb1a1>] btrfs_mount+0x831/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff8129a7f4>] do_mount+0x954/0xb90
[  396.136048]                       [<ffffffff8129ad04>] SyS_mount+0x94/0xe0
[  396.136048]                       [<ffffffff82ff539a>] do_mount_root+0x1a/0x93
[  396.136048]                       [<ffffffff82ff54f8>] mount_block_root+0xe5/0x203
[  396.136048]                       [<ffffffff82ff56f7>] mount_root+0xe1/0xea
[  396.136048]                       [<ffffffff82ff583c>] prepare_namespace+0x13c/0x174
[  396.136048]                       [<ffffffff82ff52a7>] kernel_init_freeable+0x242/0x251
[  396.136048]                       [<ffffffff82355509>] kernel_init+0x9/0xf0
[  396.136048]                       [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]     SOFTIRQ-ON-W at:
[  396.136048]                       [<ffffffff81193a13>] __lock_acquire+0x8c3/0x1d90
[  396.136048]                       [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                       [<ffffffff8237c62c>] down_write+0x5c/0xc0
[  396.136048]                       [<ffffffff81413f9d>] __link_block_group+0x3d/0xf0
[  396.136048]                       [<ffffffff81418232>] btrfs_read_block_groups+0x392/0x690
[  396.136048]                       [<ffffffff81426ba7>] open_ctree+0x1ad7/0x2140
[  396.136048]                       [<ffffffff813fadbe>] btrfs_mount+0x44e/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff813fb1a1>] btrfs_mount+0x831/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff8129a7f4>] do_mount+0x954/0xb90
[  396.136048]                       [<ffffffff8129ad04>] SyS_mount+0x94/0xe0
[  396.136048]                       [<ffffffff82ff539a>] do_mount_root+0x1a/0x93
[  396.136048]                       [<ffffffff82ff54f8>] mount_block_root+0xe5/0x203
[  396.136048]                       [<ffffffff82ff56f7>] mount_root+0xe1/0xea
[  396.136048]                       [<ffffffff82ff583c>] prepare_namespace+0x13c/0x174
[  396.136048]                       [<ffffffff82ff52a7>] kernel_init_freeable+0x242/0x251
[  396.136048]                       [<ffffffff82355509>] kernel_init+0x9/0xf0
[  396.136048]                       [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]     SOFTIRQ-ON-R at:
[  396.136048]                       [<ffffffff81193a13>] __lock_acquire+0x8c3/0x1d90
[  396.136048]                       [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                       [<ffffffff8237c57c>] down_read+0x4c/0xa0
[  396.136048]                       [<ffffffff8142327a>] btrfs_calc_num_tolerated_disk_barrier_failures+0x24a/0x310
[  396.136048]                       [<ffffffff81426bdf>] open_ctree+0x1b0f/0x2140
[  396.136048]                       [<ffffffff813fadbe>] btrfs_mount+0x44e/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff813fb1a1>] btrfs_mount+0x831/0x8e0
[  396.136048]                       [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                       [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                       [<ffffffff8129a7f4>] do_mount+0x954/0xb90
[  396.136048]                       [<ffffffff8129ad04>] SyS_mount+0x94/0xe0
[  396.136048]                       [<ffffffff82ff539a>] do_mount_root+0x1a/0x93
[  396.136048]                       [<ffffffff82ff54f8>] mount_block_root+0xe5/0x203
[  396.136048]                       [<ffffffff82ff56f7>] mount_root+0xe1/0xea
[  396.136048]                       [<ffffffff82ff583c>] prepare_namespace+0x13c/0x174
[  396.136048]                       [<ffffffff82ff52a7>] kernel_init_freeable+0x242/0x251
[  396.136048]                       [<ffffffff82355509>] kernel_init+0x9/0xf0
[  396.136048]                       [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]     RECLAIM_FS-ON-W at:
[  396.136048]                          [<ffffffff811917ee>] mark_held_locks+0x12e/0x150
[  396.136048]                          [<ffffffff8119207d>] lockdep_trace_alloc+0xdd/0xf0
[  396.136048]                          [<ffffffff81268dda>] __kmalloc_track_caller+0x6a/0x2c0
[  396.136048]                          [<ffffffff8154886b>] kvasprintf+0x5b/0x90
[  396.136048]                          [<ffffffff8153b861>] kobject_set_name_vargs+0x21/0x70
[  396.136048]                          [<ffffffff8153c588>] kobject_add+0x88/0xe0
[  396.136048]                          [<ffffffff81413ff4>] __link_block_group+0x94/0xf0
[  396.136048]                          [<ffffffff81418232>] btrfs_read_block_groups+0x392/0x690
[  396.136048]                          [<ffffffff81426ba7>] open_ctree+0x1ad7/0x2140
[  396.136048]                          [<ffffffff813fadbe>] btrfs_mount+0x44e/0x8e0
[  396.136048]                          [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                          [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                          [<ffffffff813fb1a1>] btrfs_mount+0x831/0x8e0
[  396.136048]                          [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                          [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                          [<ffffffff8129a7f4>] do_mount+0x954/0xb90
[  396.136048]                          [<ffffffff8129ad04>] SyS_mount+0x94/0xe0
[  396.136048]                          [<ffffffff82ff539a>] do_mount_root+0x1a/0x93
[  396.136048]                          [<ffffffff82ff54f8>] mount_block_root+0xe5/0x203
[  396.136048]                          [<ffffffff82ff56f7>] mount_root+0xe1/0xea
[  396.136048]                          [<ffffffff82ff583c>] prepare_namespace+0x13c/0x174
[  396.136048]                          [<ffffffff82ff52a7>] kernel_init_freeable+0x242/0x251
[  396.136048]                          [<ffffffff82355509>] kernel_init+0x9/0xf0
[  396.136048]                          [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]     INITIAL USE at:
[  396.136048]                      [<ffffffff81193a97>] __lock_acquire+0x947/0x1d90
[  396.136048]                      [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                      [<ffffffff8237c62c>] down_write+0x5c/0xc0
[  396.136048]                      [<ffffffff81413f9d>] __link_block_group+0x3d/0xf0
[  396.136048]                      [<ffffffff81418232>] btrfs_read_block_groups+0x392/0x690
[  396.136048]                      [<ffffffff81426ba7>] open_ctree+0x1ad7/0x2140
[  396.136048]                      [<ffffffff813fadbe>] btrfs_mount+0x44e/0x8e0
[  396.136048]                      [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                      [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                      [<ffffffff813fb1a1>] btrfs_mount+0x831/0x8e0
[  396.136048]                      [<ffffffff81278a6a>] mount_fs+0x7a/0x1a0
[  396.136048]                      [<ffffffff81298221>] vfs_kern_mount+0x71/0x150
[  396.136048]                      [<ffffffff8129a7f4>] do_mount+0x954/0xb90
[  396.136048]                      [<ffffffff8129ad04>] SyS_mount+0x94/0xe0
[  396.136048]                      [<ffffffff82ff539a>] do_mount_root+0x1a/0x93
[  396.136048]                      [<ffffffff82ff54f8>] mount_block_root+0xe5/0x203
[  396.136048]                      [<ffffffff82ff56f7>] mount_root+0xe1/0xea
[  396.136048]                      [<ffffffff82ff583c>] prepare_namespace+0x13c/0x174
[  396.136048]                      [<ffffffff82ff52a7>] kernel_init_freeable+0x242/0x251
[  396.136048]                      [<ffffffff82355509>] kernel_init+0x9/0xf0
[  396.136048]                      [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]   }
[  396.136048]   ... key      at: [<ffffffff83c6f738>] __key.42521+0x0/0x8
[  396.136048]   ... acquired at:
[  396.136048]    [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]    [<ffffffff8237c57c>] down_read+0x4c/0xa0
[  396.136048]    [<ffffffff814143f2>] find_free_extent+0x3a2/0xf40
[  396.136048]    [<ffffffff8141500a>] btrfs_reserve_extent+0x7a/0x140
[  396.136048]    [<ffffffff814168b1>] btrfs_alloc_free_block+0x191/0x410
[  396.136048]    [<ffffffff81400551>] __btrfs_cow_block+0x121/0x510
[  396.136048]    [<ffffffff81400b29>] btrfs_cow_block+0x149/0x2b0
[  396.136048]    [<ffffffff81404a5b>] btrfs_search_slot+0x38b/0x9a0
[  396.136048]    [<ffffffff8141e5ea>] btrfs_lookup_inode+0x2a/0xa0
[  396.136048]    [<ffffffff8147c7a0>] __btrfs_update_delayed_inode+0x60/0x220
[  396.136048]    [<ffffffff8147cfc9>] btrfs_commit_inode_delayed_inode+0xe9/0x140
[  396.136048]    [<ffffffff81434780>] btrfs_evict_inode+0x380/0x5d0
[  396.136048]    [<ffffffff81291c11>] evict+0xa1/0x170
[  396.136048]    [<ffffffff81292bb7>] iput+0x167/0x180
[  396.136048]    [<ffffffff812856ec>] do_unlinkat+0x14c/0x2c0
[  396.136048]    [<ffffffff812858c1>] SyS_unlink+0x11/0x20
[  396.136048]    [<ffffffff8237f1f9>] system_call_fastpath+0x16/0x1b
[  396.136048]
[  396.136048] -> (&delayed_node->mutex){+.+.-.} ops: 81340 {
[  396.136048]    HARDIRQ-ON-W at:
[  396.136048]                     [<ffffffff811939de>] __lock_acquire+0x88e/0x1d90
[  396.136048]                     [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                     [<ffffffff82379b0a>] mutex_lock_nested+0x6a/0x4a0
[  396.136048]                     [<ffffffff8147db46>] btrfs_delayed_update_inode+0x56/0x7c0
[  396.136048]                     [<ffffffff8142f4b9>] btrfs_update_inode+0x89/0xf0
[  396.136048]                     [<ffffffff8142f8ae>] btrfs_dirty_inode+0x5e/0xd0
[  396.136048]                     [<ffffffff8142f9bb>] btrfs_update_time+0x9b/0xc0
[  396.136048]                     [<ffffffff81290e30>] update_time+0x20/0xc0
[  396.136048]                     [<ffffffff812931f6>] touch_atime+0x106/0x150
[  396.136048]                     [<ffffffff81214697>] generic_file_aio_read+0x5b7/0x700
[  396.136048]                     [<ffffffff81274435>] do_sync_read+0x55/0x80
[  396.136048]                     [<ffffffff81275274>] vfs_read+0xb4/0x190
[  396.136048]                     [<ffffffff81275730>] SyS_read+0x50/0xb0
[  396.136048]                     [<ffffffff8237f1f9>] system_call_fastpath+0x16/0x1b
[  396.136048]    SOFTIRQ-ON-W at:
[  396.136048]                     [<ffffffff81193a13>] __lock_acquire+0x8c3/0x1d90
[  396.136048]                     [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                     [<ffffffff82379b0a>] mutex_lock_nested+0x6a/0x4a0
[  396.136048]                     [<ffffffff8147db46>] btrfs_delayed_update_inode+0x56/0x7c0
[  396.136048]                     [<ffffffff8142f4b9>] btrfs_update_inode+0x89/0xf0
[  396.136048]                     [<ffffffff8142f8ae>] btrfs_dirty_inode+0x5e/0xd0
[  396.136048]                     [<ffffffff8142f9bb>] btrfs_update_time+0x9b/0xc0
[  396.136048]                     [<ffffffff81290e30>] update_time+0x20/0xc0
[  396.136048]                     [<ffffffff812931f6>] touch_atime+0x106/0x150
[  396.136048]                     [<ffffffff81214697>] generic_file_aio_read+0x5b7/0x700
[  396.136048]                     [<ffffffff81274435>] do_sync_read+0x55/0x80
[  396.136048]                     [<ffffffff81275274>] vfs_read+0xb4/0x190
[  396.136048]                     [<ffffffff81275730>] SyS_read+0x50/0xb0
[  396.136048]                     [<ffffffff8237f1f9>] system_call_fastpath+0x16/0x1b
[  396.136048]    IN-RECLAIM_FS-W at:
[  396.136048]                        [<ffffffff81193a63>] __lock_acquire+0x913/0x1d90
[  396.136048]                        [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                        [<ffffffff82379b0a>] mutex_lock_nested+0x6a/0x4a0
[  396.136048]                        [<ffffffff8147b83b>] __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048]                        [<ffffffff8147d03f>] btrfs_remove_delayed_node+0x1f/0x30
[  396.136048]                        [<ffffffff81434968>] btrfs_evict_inode+0x568/0x5d0
[  396.136048]                        [<ffffffff81291c11>] evict+0xa1/0x170
[  396.136048]                        [<ffffffff81291d16>] dispose_list+0x36/0x50
[  396.136048]                        [<ffffffff81291fc7>] prune_icache_sb+0x47/0x60
[  396.136048]                        [<ffffffff81277b11>] super_cache_scan+0xf1/0x160
[  396.136048]                        [<ffffffff812252dd>] shrink_slab_node+0x23d/0x460
[  396.136048]                        [<ffffffff81226472>] shrink_slab+0x82/0x170
[  396.136048]                        [<ffffffff81229c94>] balance_pgdat+0x374/0x5c0
[  396.136048]                        [<ffffffff8122a3d3>] kswapd+0x4f3/0x5d0
[  396.136048]                        [<ffffffff811642f0>] kthread+0xf0/0x100
[  396.136048]                        [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]    INITIAL USE at:
[  396.136048]                    [<ffffffff81193a97>] __lock_acquire+0x947/0x1d90
[  396.136048]                    [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]                    [<ffffffff82379b0a>] mutex_lock_nested+0x6a/0x4a0
[  396.136048]                    [<ffffffff8147db46>] btrfs_delayed_update_inode+0x56/0x7c0
[  396.136048]                    [<ffffffff8142f4b9>] btrfs_update_inode+0x89/0xf0
[  396.136048]                    [<ffffffff8142f8ae>] btrfs_dirty_inode+0x5e/0xd0
[  396.136048]                    [<ffffffff8142f9bb>] btrfs_update_time+0x9b/0xc0
[  396.136048]                    [<ffffffff81290e30>] update_time+0x20/0xc0
[  396.136048]                    [<ffffffff812931f6>] touch_atime+0x106/0x150
[  396.136048]                    [<ffffffff81214697>] generic_file_aio_read+0x5b7/0x700
[  396.136048]                    [<ffffffff81274435>] do_sync_read+0x55/0x80
[  396.136048]                    [<ffffffff81275274>] vfs_read+0xb4/0x190
[  396.136048]                    [<ffffffff81275730>] SyS_read+0x50/0xb0
[  396.136048]                    [<ffffffff8237f1f9>] system_call_fastpath+0x16/0x1b
[  396.136048]  }
[  396.136048]  ... key      at: [<ffffffff83c73688>] __key.37841+0x0/0x8
[  396.136048]  ... acquired at:
[  396.136048]    [<ffffffff81190bf1>] check_usage_forwards+0xf1/0x110
[  396.136048]    [<ffffffff81191588>] mark_lock+0x178/0x2b0
[  396.136048]    [<ffffffff81193a63>] __lock_acquire+0x913/0x1d90
[  396.136048]    [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]    [<ffffffff82379b0a>] mutex_lock_nested+0x6a/0x4a0
[  396.136048]    [<ffffffff8147b83b>] __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048]    [<ffffffff8147d03f>] btrfs_remove_delayed_node+0x1f/0x30
[  396.136048]    [<ffffffff81434968>] btrfs_evict_inode+0x568/0x5d0
[  396.136048]    [<ffffffff81291c11>] evict+0xa1/0x170
[  396.136048]    [<ffffffff81291d16>] dispose_list+0x36/0x50
[  396.136048]    [<ffffffff81291fc7>] prune_icache_sb+0x47/0x60
[  396.136048]    [<ffffffff81277b11>] super_cache_scan+0xf1/0x160
[  396.136048]    [<ffffffff812252dd>] shrink_slab_node+0x23d/0x460
[  396.136048]    [<ffffffff81226472>] shrink_slab+0x82/0x170
[  396.136048]    [<ffffffff81229c94>] balance_pgdat+0x374/0x5c0
[  396.136048]    [<ffffffff8122a3d3>] kswapd+0x4f3/0x5d0
[  396.136048]    [<ffffffff811642f0>] kthread+0xf0/0x100
[  396.136048]    [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]
[  396.136048]
[  396.136048] stack backtrace:
[  396.136048] CPU: 0 PID: 1482 Comm: kswapd0 Not tainted 3.14.0-rc3 #1
[  396.136048] Hardware name: Hewlett-Packard HP Compaq dc7800 Small Form Factor/0AA8h, BIOS 786F1 v01.32 07/21/2011
[  396.136048]  ffffffff836ed420 ffff8800780df778 ffffffff8236448d ffff8800780df7d8
[  396.136048]  ffff8800780df7c0 ffffffff81190aa9 ffff8800780df7d8 ffff8800794bd2a0
[  396.136048]  ffff8800794bd2a0 000000000000000a ffff8800794bca40 ffffffff828ed7b5
[  396.136048] Call Trace:
[  396.136048]  [<ffffffff8236448d>] dump_stack+0x4d/0x66
[  396.136048]  [<ffffffff81190aa9>] print_irq_inversion_bug+0x209/0x260
[  396.136048]  [<ffffffff81190bf1>] check_usage_forwards+0xf1/0x110
[  396.136048]  [<ffffffff8107f036>] ? save_stack_trace+0x26/0x50
[  396.136048]  [<ffffffff81190b00>] ? print_irq_inversion_bug+0x260/0x260
[  396.136048]  [<ffffffff81191588>] mark_lock+0x178/0x2b0
[  396.136048]  [<ffffffff81193a63>] __lock_acquire+0x913/0x1d90
[  396.136048]  [<ffffffff81078822>] ? native_sched_clock+0x82/0xc0
[  396.136048]  [<ffffffff81179f4d>] ? sched_clock_local+0x1d/0x90
[  396.136048]  [<ffffffff8117a248>] ? sched_clock_cpu+0xb8/0xe0
[  396.136048]  [<ffffffff8237dac5>] ? _raw_spin_unlock_irqrestore+0x55/0x80
[  396.136048]  [<ffffffff811969f2>] lock_acquire+0x182/0x210
[  396.136048]  [<ffffffff8147b83b>] ? __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048]  [<ffffffff82379b0a>] mutex_lock_nested+0x6a/0x4a0
[  396.136048]  [<ffffffff8147b83b>] ? __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048]  [<ffffffff8147b83b>] ? __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048]  [<ffffffff814345c9>] ? btrfs_evict_inode+0x1c9/0x5d0
[  396.136048]  [<ffffffff8117a38a>] ? local_clock+0x1a/0x40
[  396.136048]  [<ffffffff8147b83b>] __btrfs_release_delayed_node+0x4b/0x1e0
[  396.136048]  [<ffffffff8147d03f>] btrfs_remove_delayed_node+0x1f/0x30
[  396.136048]  [<ffffffff81434968>] btrfs_evict_inode+0x568/0x5d0
[  396.136048]  [<ffffffff8237da62>] ? _raw_spin_unlock+0x22/0x30
[  396.136048]  [<ffffffff81291c11>] evict+0xa1/0x170
[  396.136048]  [<ffffffff81291d16>] dispose_list+0x36/0x50
[  396.136048]  [<ffffffff81291fc7>] prune_icache_sb+0x47/0x60
[  396.136048]  [<ffffffff81277b11>] super_cache_scan+0xf1/0x160
[  396.136048]  [<ffffffff812252dd>] shrink_slab_node+0x23d/0x460
[  396.136048]  [<ffffffff8122642a>] ? shrink_slab+0x3a/0x170
[  396.136048]  [<ffffffff81226472>] shrink_slab+0x82/0x170
[  396.136048]  [<ffffffff81229c94>] balance_pgdat+0x374/0x5c0
[  396.136048]  [<ffffffff8122a3d3>] kswapd+0x4f3/0x5d0
[  396.136048]  [<ffffffff81187140>] ? __wake_up_common+0x90/0x90
[  396.136048]  [<ffffffff81229ee0>] ? balance_pgdat+0x5c0/0x5c0
[  396.136048]  [<ffffffff811642f0>] kthread+0xf0/0x100
[  396.136048]  [<ffffffff8116dcb1>] ? finish_task_switch+0x81/0x130
[  396.136048]  [<ffffffff81164200>] ? insert_kthread_work+0x90/0x90
[  396.136048]  [<ffffffff8237f14c>] ret_from_fork+0x7c/0xb0
[  396.136048]  [<ffffffff81164200>] ? insert_kthread_work+0x90/0x90
