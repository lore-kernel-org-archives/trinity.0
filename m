From: Tommi Rantala <tt.rantala@gmail.com>
Subject: kernel BUG at security/keys/keyring.c:1003!
Date: Thu, 27 Feb 2014 21:05:09 +0200
Message-ID: <CA+ydwtqyfZE0Fe0LkpkyJeFFBHhyXm1kUUGJtPkwuBLJ-LS4fw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=epRfjDH57XHUxf2GgewTKoQh2sny24AvLhRBEY5U3Bw=;
        b=P5NH6AYy+fsr7hBXI/ne5CbLq1nSX+3BQk+a63hyWgoJDNX766xzQj1pF3QT8NPL4a
         8Mh/qbw3WPbbpBtHgjAXPvKDfetC4yS0MTvltqrVuQYWyDOPYHicf3HFQTOqoehpX4Om
         PXMjvgsI2wI3cCghSVowE3YfzRVYraUMh4prGBAAfpHQBzP0dZ83gRqYdsP0jpy+CMCE
         gPTV4zDn1M+awI49K8gPA73uU9VkHF7ShL9vyFhgDVx10Ytuzvx4ln04lSpLu/CUL0TO
         hE4U8m7DTKi9/f0cQREChBUqKnXy5hNiIWxjPwqQNtdSiH9fn2sXwl96zO2KCjH+vBa/
         q33A==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

Hello,

Hit the following BUG while fuzzing 3.14.0-rc3 with trinity.

Tommi

[708836.755392] ------------[ cut here ]------------
[708836.756044] kernel BUG at /build/linux/security/keys/keyring.c:1003!
[708836.756044] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[708836.756044] CPU: 0 PID: 5594 Comm: trinity-c26 Not tainted 3.14.0-rc3 #1
[708836.756044] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[708836.756044] task: ffff880036a3ca40 ti: ffff880003e6e000 task.ti:
ffff880003e6e000
[708836.756044] RIP: 0010:[<ffffffff814ac7be>]  [<ffffffff814ac7be>]
keyring_detect_cycle_iterator+0xe/0x20
[708836.756044] RSP: 0000:ffff880003e6fdb0  EFLAGS: 00010206
[708836.756044] RAX: ffff880056025b82 RBX: 000000000000003a RCX:
0000000000000003
[708836.756044] RDX: 0000000000000003 RSI: ffff880003e6fe98 RDI:
ffff880056025b80
[708836.756044] RBP: ffff880003e6fdb0 R08: 0000000000000064 R09:
0000000000000000
[708836.756044] R10: ffff880036a3ca40 R11: 0000000000000000 R12:
ffff880003e6fe98
[708836.756044] R13: 0000000000000000 R14: ffff880003e6fe98 R15:
ffff88006c950780
[708836.756044] FS:  00007f88ae6bd700(0000) GS:ffff8800bf600000(0000)
knlGS:0000000000000000
[708836.756044] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[708836.756044] CR2: 0000000000000004 CR3: 000000003ba4d000 CR4:
00000000000006f0
[708836.756044] DR0: 0000000000899000 DR1: 000000000115a000 DR2:
0000000001b66000
[708836.756044] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000600
[708836.756044] Stack:
[708836.756044]  ffff880003e6fe80 ffffffff814ac9e2 ffffffff81078869
ffff880003e6fdf0
[708836.756044]  ffffffff81179f4d ffff8800bf7d5a40 00000000001d5a40
0000000000000000
[708836.756044]  ffff88006c950780 0000000000000000 0000000000000002
0000000000000001
[708836.756044] Call Trace:
[708836.756044]  [<ffffffff814ac9e2>] search_nested_keyrings+0xf2/0x340
[708836.756044]  [<ffffffff81078869>] ? sched_clock+0x9/0x10
[708836.756044]  [<ffffffff81179f4d>] ? sched_clock_local+0x1d/0x90
[708836.756044]  [<ffffffff814ad246>] ? __key_link_check_live_key+0x26/0x160
[708836.756044]  [<ffffffff814ad303>] __key_link_check_live_key+0xe3/0x160
[708836.756044]  [<ffffffff814ad246>] ? __key_link_check_live_key+0x26/0x160
[708836.756044]  [<ffffffff814ac7b0>] ? keyring_instantiate+0xf0/0xf0
[708836.756044]  [<ffffffff814ad4ac>] key_link+0x5c/0xb0
[708836.756044]  [<ffffffff814adfee>] keyctl_keyring_link+0x7e/0xb0
[708836.756044]  [<ffffffff814af508>] SyS_keyctl+0x98/0x1a0
[708836.756044]  [<ffffffff82381209>] ia32_do_call+0x13/0x13
[708836.756044] Code: c0 eb 12 66 2e 0f 1f 84 00 00 00 00 00 31 c0 66
0f 1f 44 00 00 5b 41 5c 5d f3 c3 66 90 48 83 e7 fc 48 39 7e 28 55 48
89 e5 74 02 <0f> 0b b8 01 00 00 00 48 c7 46 48 dd ff ff ff 5d c3 90 55
48 89
[708836.756044] RIP  [<ffffffff814ac7be>] keyring_detect_cycle_iterator+0xe/0x20
[708836.756044]  RSP <ffff880003e6fdb0>
[708836.855231] ---[ end trace e2b699c76aca5cff ]---
