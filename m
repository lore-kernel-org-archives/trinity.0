From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: drm_mode_create_dumb_ioctl: divide error
Date: Sun, 24 Aug 2014 20:12:01 +0300
Message-ID: <CA+ydwtq7-O4+5jtu_zZEFGM7Nbq7pGqGG=UgZBnDzg58QsgMoA@mail.gmail.com>
References: <CA+ydwtoGKP622R5XSSSvibd_5PtsQxtsijrdD23c-7waQvjC=g@mail.gmail.com>
 <CANq1E4TZPZQSP2wWLG2LJmf1YXyRnv0rtMyKGkjsfSV50RDSnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=mime-version:in-reply-to:references:date:message-id:subject:from:to
 :cc:content-type;
 bh=VYtyYffi+K4AItWmfBTc0T3KBRORZN1kTnwd5jaOm/E=;
 b=BGERdQ5+DrCbWbxb+pC8WQQA3V+0CwLaiqiYuDWaoleZXdg5+CBOaWuhWyBjKg6gal
 qoEjRyd2I/L1Mk6O8jHiOl6IbDENx25Yv7xx/S1ny3ZP3xLAT46hvroU67wvr9ezIg91
 fBbAqwqwrItVJbQEDIlIidwaBNp33/5gDtnTBgjYtFHfXoUglptfFihbSzbiF81VdlGA
 mQe77IBIH7RvuFnGKi4JrXlDY0pBbuFrkt/dZXMoeaqXEC3GkYVjMlQkqIEMGEQDt+RP
 JdbWQlRA41FZ67R2p6YCr0CLORnVoRVQm2tKMCMHgl382LlyXo9N4LkrcjfrWk/4s8Ts
 pLjg==
In-Reply-To: <CANq1E4TZPZQSP2wWLG2LJmf1YXyRnv0rtMyKGkjsfSV50RDSnA@mail.gmail.com>
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
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org, trinity@vger.kernel.org

22.8.2014 13.38 kirjoitti "David Herrmann" <dh.herrmann@gmail.com>:
>
> Hi
>
> On Thu, Aug 21, 2014 at 8:18 PM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> > Hello,
> >
> > Triggered this while fuzzing v3.17-rc1-51-g372b1db with Trinity.
> >
> > Tommi
> >
> >
> > [drm:drm_mode_legacy_fb_format] *ERROR* bad bpp, assuming x8r8g8b8 pixel format
> > divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
> > CPU: 0 PID: 2854 Comm: trinity-c7 Not tainted 3.17.0-rc1+ #14
> > Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > task: ffff88003926cac0 ti: ffff8800356b4000 task.ti: ffff8800356b4000
> > RIP: 0010:[<ffffffff816688e3>]  [<ffffffff816688e3>]
> > drm_mode_create_dumb_ioctl+0x53/0xa0
> > RSP: 0018:ffff8800356b7dc0  EFLAGS: 00010246
> > RAX: 00000000ffffffff RBX: ffff88003545da68 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: ffff8800356b7e18 RDI: ffff88003d5c67b0
> > RBP: ffff8800356b7dc8 R08: 0000000000000000 R09: 00000000ffffffff
> > R10: 00000000ffffffff R11: ffffffff817f6d30 R12: 00000000000000b2
> > R13: fffffffffffffff2 R14: ffff88003d5c67b0 R15: ffff88003545da68
> > FS:  00007f06208fa700(0000) GS:ffff88003fa00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000001903108 CR3: 0000000036efa000 CR4: 00000000000006f0
> > Stack:
> >  ffff8800356b7e18 ffff8800356b7ec8 ffffffff8165ac60 ffff8800356b7df8
> >  ffff8800356b7e18 ffff8800356b7e18 ffffffff824e1440 0000000000d52000
> >  0000000000000020 00000000c02064b2 00000000fffffff2 ffffffffffffffff
> > Call Trace:
> >  [<ffffffff8165ac60>] drm_ioctl+0x3b0/0x640
> >  [<ffffffff814b81b8>] ? avc_has_perm+0x218/0x2f0
> >  [<ffffffff814b7fc0>] ? avc_has_perm+0x20/0x2f0
> >  [<ffffffff81170bb8>] ? sched_clock_cpu+0xa8/0xf0
> >  [<ffffffff812922a0>] do_vfs_ioctl+0x4d0/0x510
> >  [<ffffffff814ba745>] ? selinux_file_ioctl+0xf5/0x100
> >  [<ffffffff8129232e>] SyS_ioctl+0x4e/0x80
> >  [<ffffffff822b10e9>] system_call_fastpath+0x16/0x1b
> > Code: 55 41 b9 ff ff ff ff 41 83 c0 07 44 89 c8 41 c1 e8 03 48 89 e5
> > 53 48 89 d3 31 d2 f7 f1 41 39 c0 77 46 41 0f af c8 31 d2 44 89 c8 <f7>
> > f1 41 39 c2 77 36 41 0f af ca b8 ea ff ff ff 81 c1 ff 0f 00
> > RIP  [<ffffffff816688e3>] drm_mode_create_dumb_ioctl+0x53/0xa0
> >  RSP <ffff8800356b7dc0>
> > ---[ end trace 6919129b71d9bf98 ]---
> > [drm:drm_mode_legacy_fb_format] *ERROR* bad bpp, assuming x8r8g8b8 pixel format
> >
> >
> >
> > (gdb) list *0xffffffff816688e3
> > 0xffffffff816688e3 is in drm_mode_create_dumb_ioctl
> > (drivers/gpu/drm/drm_crtc.c:4703).
> > 4698            /* overflow checks for 32bit size calculations */
> > 4699            cpp = DIV_ROUND_UP(args->bpp, 8);
> > 4700            if (cpp > 0xffffffffU / args->width)
> > 4701                    return -EINVAL;
> > 4702            stride = cpp * args->width;
> > 4703            if (args->height > 0xffffffffU / stride)
> > 4704                    return -EINVAL;
>
> Hm, this doesn't make sense to me. args->bpp/width/height are
> guaranteed to be non-zero and 32bit. Therefore, DIV_ROUND_UP() cannot
> return 0 and "cpp" is thus non-zero. The overflow check makes sure
> "cpp * args->width" cannot overflow, both are non-zero so "stride" is
> non-zero and valid.
>
> I cannot make much sense out of the x86 assembly below, so help welcome.

Hi David,

I put a BUG_ON(stride==0), and it is indeed crashing due to stride being zero.

I tried to get the variables with gdb since I'm running the kernel in
qemu, but for whatever reason the breakpoints do not seem to always
have any effect, IOW the execution blasts right through the
breakpoints.

Finally I did get one instance where the breakpoint would trigger, and
gdb told me this. Does it make sense?

(gdb) bt
#0  drm_mode_create_dumb_ioctl (dev=0xffff88003d634520,
data=0xffff880034837e18, file_priv=0xffff8800361faa40) at
drivers/gpu/drm/drm_crtc.c:4704
#1  0xffffffff8165ad20 in drm_ioctl (filp=<optimized out>,
cmd=<optimized out>, arg=<optimized out>) at
drivers/gpu/drm/drm_ioctl.c:727
#2  0xffffffff812922a0 in vfs_ioctl (arg=<optimized out>,
cmd=<optimized out>, filp=<optimized out>) at fs/ioctl.c:43
#3  do_vfs_ioctl (filp=0xffff88003d634520, fd=36, cmd=<optimized out>,
arg=<optimized out>) at fs/ioctl.c:598
#4  0xffffffff8129232e in SYSC_ioctl (arg=<optimized out>,
cmd=<optimized out>, fd=<optimized out>) at fs/ioctl.c:613
#5  SyS_ioctl (fd=36, cmd=3223348402, arg=9592832) at fs/ioctl.c:604
#6  <signal handler called>
#7  0x00007f69a2b0eb69 in ?? ()
#8  0xdead4ead6b6b0e0e in ?? ()
#9  0x6b6b6b6bffffffff in ?? ()
#10 0xffffffffffffffff in ?? ()
#11 0xffffffff840ba810 in ?? ()
#12 0xffffffff838a9e70 in lock_classes ()
#13 0xffffffff83924540 in lock_classes ()
#14 0xffffffff828ed4ef in kallsyms_token_index ()
#15 0x6b6b6b6b00000000 in ?? ()
#16 0xffffffff81279ec8 in kmemleak_scan () at mm/kmemleak.c:1410
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

(gdb) print *args
value has been optimized out

(gdb) info locals
cpp = 0
stride = 0
size = <optimized out>

(gdb) print /x *(struct drm_mode_create_dumb *)data
$13 = {
  height = 0xffffffff,
  width = 0xffffffff,
  bpp = 0xffffffff,
  flags = 0xffffffff,
  handle = 0xffffffff,
  pitch = 0xffffffff,
  size = 0xffffffffffffffff
}

Tommi
