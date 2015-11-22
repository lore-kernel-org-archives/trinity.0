From: Tommi Rantala <tt.rantala@gmail.com>
Subject: nouveau: iowrite32 oops & warning at drivers/gpu/drm/nouveau/nouveau_fence.c:198
Date: Sun, 22 Nov 2015 22:30:34 +0200
Message-ID: <CA+ydwtq3CT5iswJbWCBGN9_KqKANbaoeZdzvjm1fe9aiE=VQ-g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=z9Fi9jDNWean1rlKpglWoAHgZdFzwq11NKjWyNQlk2g=;
        b=C5xQcvHu/ZtERQoHtk33w+Whq6wPKxvG2tOahg5bMzVTe9EBE7lvf+PajSS4knXCfy
         uNnl8dyz9rWGpOktKU8gW/1xlfVZGuS+L0CbgnJLkLQQRIzCguVeiFDCvC8vBkiv+htE
         2d61EsiEjAQZ8g7xhAmNyKswyku+zb0AFcsaBNTZERiXjIcP3GgKzUVy0mxcP1I5Kd81
         jdtzCgR66iQFjR+Fbw7nYQBgpPEFj+Y0OtRdAxruMtmnOHU9ZkKliGoESWgWrMIPTGON
         ShhFnW4TTQeGpOPInG77gwE+tS22JlqcNFkgzLHSb8ZQYNC0N6g+3zLTmZCy0tM9wkHc
         IAZQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nouveau@lists.freedesktop.org, bskeggs@redhat.com
Cc: DRI Development <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hello,

I'm seeing this warning and oops when trying to fuzz linus
v4.4-rc1-290-g3ad5d7e with trinity.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 4308 at
drivers/gpu/drm/nouveau/nouveau_fence.c:198
nouveau_fence_context_new+0x22e/0x270()
CPU: 1 PID: 4308 Comm: trinity-c19 Tainted: G    B           4.4.0-rc1+ #1
Hardware name: Dell Inc. OptiPlex 990/0D6H9T, BIOS A06 07/25/2011
0000000000000009 ffff8800ac4bf8b0 ffffffff818a802e 0000000000000000
ffff8800ac4bf8f0 ffffffff8111bc75 ffffffff820170be ffff8800ac9c1050
ffff88015b0e8cc0 ffff8800ca703070 ffff88016f432130 ffff8800afb675f0
Call Trace:
[<ffffffff818a802e>] dump_stack+0x4b/0x6d
[<ffffffff8111bc75>] warn_slowpath_common+0x95/0xd0
[<ffffffff820170be>] ? nouveau_fence_context_new+0x22e/0x270
[<ffffffff8111be45>] warn_slowpath_null+0x15/0x20
[<ffffffff820170be>] nouveau_fence_context_new+0x22e/0x270
[<ffffffff82016e90>] ? nouveau_fence_context_free+0x20/0x20
[<ffffffff8130a06e>] ? kasan_kmalloc+0x5e/0x70
[<ffffffff81306803>] ? kmem_cache_alloc_trace+0x123/0x290
[<ffffffff8201a263>] ? nv84_fence_context_new+0x73/0x2d0
[<ffffffff8201a28d>] nv84_fence_context_new+0x9d/0x2d0
[<ffffffff8201b351>] nvc0_fence_context_new+0x11/0x70
[<ffffffff820155f1>] nouveau_channel_new+0x7e1/0xca0
[<ffffffff8130fc6c>] ? create_object+0x28c/0x4d0
[<ffffffff82014e10>] ? nouveau_channel_prep+0x4b0/0x4b0
[<ffffffff8130fde6>] ? create_object+0x406/0x4d0
[<ffffffff8130f9e0>] ? kmemleak_disable+0x70/0x70
[<ffffffff82012d57>] ? nouveau_abi16_get+0x37/0x80
[<ffffffff8118dfc6>] ? trace_hardirqs_on_caller+0x16/0x280
[<ffffffff81309e36>] ? kasan_unpoison_shadow+0x36/0x50
[<ffffffff81309e36>] ? kasan_unpoison_shadow+0x36/0x50
[<ffffffff81306803>] ? kmem_cache_alloc_trace+0x123/0x290
[<ffffffff8201333c>] ? nouveau_abi16_ioctl_channel_alloc+0xec/0x4d0
[<ffffffff820133fe>] nouveau_abi16_ioctl_channel_alloc+0x1ae/0x4d0
[<ffffffff82013250>] ? nouveau_abi16_ioctl_setparam+0x10/0x10
[<ffffffff81a85ccb>] drm_ioctl+0x20b/0x6b0
[<ffffffff811bfc66>] ? debug_lockdep_rcu_enabled+0x26/0x40
[<ffffffff81a85ac0>] ? drm_ioctl_permit+0x120/0x120
[<ffffffff8118e23d>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff81fe9f99>] nouveau_drm_ioctl+0x99/0x110
[<ffffffff813342be>] do_vfs_ioctl+0x4ae/0x800
[<ffffffff8180a3d9>] ? selinux_file_ioctl+0x1f9/0x2d0
[<ffffffff81333e10>] ? ioctl_preallocate+0x140/0x140
[<ffffffff8180a1e0>] ? selinux_parse_skb.constprop.42+0x7c0/0x7c0
[<ffffffff811dbdcb>] ? do_setitimer+0x28b/0x420
[<ffffffff811dbfe5>] ? alarm_setitimer+0x85/0xe0
[<ffffffff811dbf60>] ? do_setitimer+0x420/0x420
[<ffffffff81334684>] SyS_ioctl+0x74/0x80
[<ffffffff82f34ed7>] entry_SYSCALL_64_fastpath+0x12/0x6f
---[ end trace 780046761495600a ]---



BUG: unable to handle kernel paging request at ffffc90001880000
IP: [<ffffffff818d20be>] iowrite32+0x2e/0x40
PGD 174f36067 PUD 174f37067 PMD 16a13b067 PTE 0
Oops: 0002 [#1] SMP KASAN
CPU: 3 PID: 4638 Comm: trinity-c19 Tainted: G    B   W       4.4.0-rc1+ #1
Hardware name: Dell Inc. OptiPlex 990/0D6H9T, BIOS A06 07/25/2011
task: ffff8800ab8e1a00 ti: ffff8800ab6c0000 task.ti: ffff8800ab6c0000
RIP: 0010:[<ffffffff818d20be>]  [<ffffffff818d20be>] iowrite32+0x2e/0x40
RSP: 0018:ffff8800ab6c75f8  EFLAGS: 00010292
RAX: ffffed001940c2b8 RBX: ffffc90001880000 RCX: ffff8800ca0615c7
RDX: 0000000000000000 RSI: ffffc90001880000 RDI: 0000000000000000
RBP: ffff8800ab6c7618 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffed001443979e R12: ffff8800ca061590
R13: 0000000000000000 R14: ffff880152553390 R15: ffffffff833e0220
FS:  00007f48be30a700(0000) GS:ffff880175800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90001880000 CR3: 00000000ab455000 CR4: 00000000000406e0
Stack:
ffffffff81f58f8b 0000000000080004 ffff8800ca061590 ffff880169d3a4c0
ffff8800ab6c76b8 ffffffff81fa3b68 0000000000000000 00000141c1800000
ffffffff00000001 ffff880000006000 ffffffff00001000 ffff8800ab6c7820
Call Trace:
[<ffffffff81f58f8b>] ? nvkm_instobj_wr32+0x2b/0x40
[<ffffffff81fa3b68>] gf100_fifo_gpfifo_new+0x528/0xa50
[<ffffffff81f94b58>] nvkm_fifo_class_new+0x58/0x70
[<ffffffff81f94b00>] ? nvkm_fifo_uevent_ctor+0x50/0x50
[<ffffffff81f7bdf3>] nvkm_udevice_child_new+0x63/0x80
[<ffffffff81ed1aea>] nvkm_ioctl_new+0x2aa/0x5e0
[<ffffffff8130fa6c>] ? create_object+0x8c/0x4d0
[<ffffffff810b584a>] ? save_stack_address+0x6a/0x70
[<ffffffff81ed1840>] ? nvkm_ioctl_del+0x110/0x110
[<ffffffff81f7bd90>] ? nvkm_udevice_map+0x90/0x90
[<ffffffff8130fde6>] ? create_object+0x406/0x4d0
[<ffffffff81ed282b>] nvkm_ioctl+0x1fb/0x510
[<ffffffff8118dfc6>] ? trace_hardirqs_on_caller+0x16/0x280
[<ffffffff81fedce0>] ? nvkm_client_map+0x10/0x10
[<ffffffff81fedced>] nvkm_client_ioctl+0xd/0x10
[<ffffffff81eccf6d>] nvif_object_ioctl+0xad/0xe0
[<ffffffff81ecdb40>] nvif_object_init+0x160/0x1e0
[<ffffffff82014f9d>] nouveau_channel_new+0x18d/0xca0
[<ffffffff8130fc6c>] ? create_object+0x28c/0x4d0
[<ffffffff82014e10>] ? nouveau_channel_prep+0x4b0/0x4b0
[<ffffffff8130fde6>] ? create_object+0x406/0x4d0
[<ffffffff8130f9e0>] ? kmemleak_disable+0x70/0x70
[<ffffffff82012d57>] ? nouveau_abi16_get+0x37/0x80
[<ffffffff8118dfc6>] ? trace_hardirqs_on_caller+0x16/0x280
[<ffffffff81309e36>] ? kasan_unpoison_shadow+0x36/0x50
[<ffffffff81309e36>] ? kasan_unpoison_shadow+0x36/0x50
[<ffffffff81306803>] ? kmem_cache_alloc_trace+0x123/0x290
[<ffffffff8201333c>] ? nouveau_abi16_ioctl_channel_alloc+0xec/0x4d0
[<ffffffff820133fe>] nouveau_abi16_ioctl_channel_alloc+0x1ae/0x4d0
[<ffffffff82013250>] ? nouveau_abi16_ioctl_setparam+0x10/0x10
[<ffffffff81a85ccb>] drm_ioctl+0x20b/0x6b0
[<ffffffff811bfc66>] ? debug_lockdep_rcu_enabled+0x26/0x40
[<ffffffff81a85ac0>] ? drm_ioctl_permit+0x120/0x120
[<ffffffff8118e23d>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff81fe9f99>] nouveau_drm_ioctl+0x99/0x110
[<ffffffff813342be>] do_vfs_ioctl+0x4ae/0x800
[<ffffffff8180a3d9>] ? selinux_file_ioctl+0x1f9/0x2d0
 [<ffffffff81333e10>] ? ioctl_preallocate+0x140/0x140
[<ffffffff8180a1e0>] ? selinux_parse_skb.constprop.42+0x7c0/0x7c0
[<ffffffff811dbdcb>] ? do_setitimer+0x28b/0x420
[<ffffffff811dbfe5>] ? alarm_setitimer+0x85/0xe0
[<ffffffff811dbf60>] ? do_setitimer+0x420/0x420
[<ffffffff81334684>] SyS_ioctl+0x74/0x80
[<ffffffff82f34ed7>] entry_SYSCALL_64_fastpath+0x12/0x6f
Code: ff ff 03 00 77 25 48 81 fe 00 00 01 00 76 07 0f b7 d6 89 f8 ef
c3 55 48 89 f7 48 c7 c6 e0 39 1e 83 48 89 e5 e8 84 fd ff ff 5d c3 <89>
3e c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 81 fe
RIP  [<ffffffff818d20be>] iowrite32+0x2e/0x40
RSP <ffff8800ab6c75f8>
CR2: ffffc90001880000
---[ end trace 7800467614956062 ]---


Some nouveau messages from the boot, if this helps:

nouveau 0000:01:00.0: NVIDIA GF119 (0d90a0a1)
nouveau 0000:01:00.0: bios: version 75.19.55.00.02
nouveau 0000:01:00.0: fb: 1024 MiB DDR3
[TTM] Zone  kernel: Available graphics memory: 2590256 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
nouveau 0000:01:00.0: DRM: VRAM: 1024 MiB
nouveau 0000:01:00.0: DRM: GART: 1048576 MiB
nouveau 0000:01:00.0: DRM: TMDS table version 2.0
nouveau 0000:01:00.0: DRM: DCB version 4.0
nouveau 0000:01:00.0: DRM: DCB outp 00: 02000300 00000000
nouveau 0000:01:00.0: DRM: DCB outp 01: 01000302 00020030
nouveau 0000:01:00.0: DRM: DCB outp 02: 02011362 00020010
nouveau 0000:01:00.0: DRM: DCB outp 03: 04022310 00000000
nouveau 0000:01:00.0: DRM: DCB conn 00: 00001030
nouveau 0000:01:00.0: DRM: DCB conn 01: 00002161
nouveau 0000:01:00.0: DRM: DCB conn 02: 00000200
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
nouveau 0000:01:00.0: DRM: MM: using COPY0 for buffer copies
nouveau 0000:01:00.0: No connectors reported connected with modes
[drm] Cannot find any crtc or sizes - going 1024x768
nouveau 0000:01:00.0: DRM: allocated 1024x768 fb: 0x60000, bo ffff880169d36e40
fbcon: nouveaufb (fb0) is primary device
Console: switching to colour frame buffer device 128x48
nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[drm] Initialized nouveau 1.3.1 20120801 for 0000:01:00.0 on minor 0
