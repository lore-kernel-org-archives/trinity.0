From: Tommi Rantala <tt.rantala@gmail.com>
Subject: /proc/asound/card0/oss_mixer stack corruption
Date: Thu, 21 Aug 2014 20:45:58 +0300
Message-ID: <CA+ydwtr+e0Sr4y+VRu-3JkF0Lbf+KJqjO9LZq6JPOgbHuyfAwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=Y9QgkU+1njzP6Rqhdc6BMuwI4YwcOsn/U7KQlswrHxU=;
        b=0X5LGsJ1sTNqmljbRWtdRKIwbtQcMPcVyzH5QITEh/yuYFUm+jt3ScT37m5wfJ5twK
         9exDp87TGK1g1wQv1iX+QQ0F0a/7Kk+GdnEFR1fPi0iV8x6gcKmWdT1GTBF3RI6r9S9l
         WDDdK7lmtSkgkTHFJqxfUe251Cdnt0zlayTnjXkMg6x6gmIX6JazhC1wwMYF3fDKF75r
         XJlrFo+2qGHXb9eWCW4q3t4GqDkmyCtqWQscDXoBaI/f0QJVGWuDnMHQnhZDqVNKuLtt
         PgOvNPe0OfFH2K1T/1Z2KFAP6UvtzZEmC/HruIV1u4IP4AsHTFoJavKIIHsYwp0Zw4Ap
         zFgA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: trinity@vger.kernel.org, Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org

Hello,

Trinity discovered that writing 128 bytes to
/proc/asound/card0/oss_mixer triggers a stack corruption.

Tommi


# printf %128s > /proc/asound/card0/oss_mixer

ALSA: mixer_oss: invalid OSS volume ''
Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
in: ffffffff81e193ba

CPU: 0 PID: 2778 Comm: bash Not tainted 3.17.0-rc1+ #13
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 ffff880039fd4bf0 ffff880034c87bd8 ffffffff8229824a ffffffff828e2a40
 ffff880034c87c50 ffffffff8229051d ffff880000000010 ffff880034c87c60
 ffff880034c87c00 0000000000000020 ffffffff81e193ba 0000000000000080
Call Trace:
 [<ffffffff8229824a>] dump_stack+0x4d/0x66
 [<ffffffff8229051d>] panic+0xc8/0x201
 [<ffffffff81e193ba>] ? snd_mixer_oss_proc_write+0x24a/0x270
 [<ffffffff8113c716>] __stack_chk_fail+0x16/0x20
 [<ffffffff81e193ba>] snd_mixer_oss_proc_write+0x24a/0x270
 [<ffffffff810a8a27>] ? kvm_clock_read+0x27/0x40
 [<ffffffff81dfb54c>] snd_info_entry_release+0x6c/0x110
 [<ffffffff812e9af6>] close_pdeo+0x136/0x1a0
 [<ffffffff8118bec1>] ? __lock_acquire+0x951/0xb40
 [<ffffffff810a8a27>] ? kvm_clock_read+0x27/0x40
 [<ffffffff812e9b9e>] proc_reg_release+0x3e/0x60
 [<ffffffff8127fa41>] __fput+0x111/0x1e0
 [<ffffffff8127fb59>] ____fput+0x9/0x10
 [<ffffffff8115e3ee>] task_work_run+0x9e/0xd0
 [<ffffffff8106aaa5>] do_notify_resume+0x55/0x70
 [<ffffffff822b12e2>] int_signal+0x12/0x17
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffff9fffffff)
