From: Tommi Rantala <tt.rantala@gmail.com>
Subject: drm_ioctl & WARNING at arch/x86/mm/ioremap.c:98
Date: Wed, 27 Aug 2014 21:31:25 +0300
Message-ID: <CA+ydwtoj-4cBeZZYomWf9ZeSxrwvDYbNpxbVQMA7tkUF5XM_9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=mime-version:date:message-id:subject:from:to:cc:content-type;
 bh=A7VLQ79FYRMhi2Yn6huYEDddOzmRw/4mFzNjNijUrpI=;
 b=KSHeE+epA8O6PX9aySjE6iXGo1uMHWLdxEGRST3fm+SxkyGnc98lslvdexsIBBW5jy
 R17oVXrAxyiwWL6kuQ7Fty1+/Dp/WGgQEL/sZg6E/msc06uKXeaSs1f+fLo6eO5wgjrn
 VHmBwvyQpeqr2QvlviPZ/UpPTRWuSHv9CJ1HJzGEHhSJUo2pUKr1LNNohyevqeAlmlik
 G4EYn0KwBrxF1Fr4EdMMeKti/DJTD2DiSBxXglPQ7GzlywVTfiphU7EhutmRrGnURvR2
 iX4o2R+EJbLX23+iJD4HrdX7OmFjRuQW7daCiSAaaFK5pCzxoZCe7O041zDSERPXjaHK
 57og==
List-Id: <trinity.vger.kernel.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: dri-devel@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hello,

Got this warning while fuzzing v3.17-rc2-40-gff0c57a with Trinity. Was
running as root in qemu.

Tommi


ioremap: invalid physical address 4000000000004000
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2887 at arch/x86/mm/ioremap.c:98
__ioremap_caller+0x7a/0x2e0()
CPU: 0 PID: 2887 Comm: trinity-c6 Not tainted 3.17.0-rc2+ #29
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 0000000000000009 ffff880036ee7c90 ffffffff8238ba09 0000000000000000
 ffff880036ee7cc8 ffffffff8113c603 0000000000000000 4000000000004000
 4000000000008000 ffffffff81747c7d 0000000000000010 ffff880036ee7cd8
Call Trace:
 [<ffffffff8238ba09>] dump_stack+0x4d/0x66
 [<ffffffff8113c603>] warn_slowpath_common+0x73/0x90
 [<ffffffff81747c7d>] ? drm_addmap_core+0x1dd/0x600
 [<ffffffff8113c6f5>] warn_slowpath_null+0x15/0x20
 [<ffffffff810aebaa>] __ioremap_caller+0x7a/0x2e0
 [<ffffffff8237ec03>] ? kmemleak_alloc+0x23/0x50
 [<ffffffff8126ced9>] ? kmem_cache_alloc_trace+0x119/0x290
 [<ffffffff81747adb>] ? drm_addmap_core+0x3b/0x600
 [<ffffffff810aee62>] ioremap_nocache+0x12/0x20
 [<ffffffff81747c7d>] drm_addmap_core+0x1dd/0x600
 [<ffffffff817486c5>] drm_addmap_ioctl+0x45/0x70
 [<ffffffff8174d6fe>] drm_ioctl+0x3fe/0x640
 [<ffffffff81748680>] ? drm_addmap+0x30/0x30
 [<ffffffff815aa790>] ? avc_has_perm+0x20/0x2f0
 [<ffffffff81170bb8>] ? sched_clock_cpu+0xa8/0xf0
 [<ffffffff812922f0>] do_vfs_ioctl+0x4d0/0x510
 [<ffffffff815acf15>] ? selinux_file_ioctl+0xf5/0x100
 [<ffffffff8129237e>] SyS_ioctl+0x4e/0x80
 [<ffffffff823a47a9>] system_call_fastpath+0x16/0x1b
---[ end trace c988df0287baa491 ]---
