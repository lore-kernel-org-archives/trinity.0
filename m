From: Michael Ellerman <mpe@ellerman.id.au>
Subject: BUG at mm/memory.c:1489!
Date: Wed, 28 May 2014 18:32:02 +1000
Message-ID: <1401265922.3355.4.camel@concordia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org

Hey folks,

Anyone seen this before? Trinity hit it just now:

Linux Blade312-5 3.15.0-rc7 #306 SMP Wed May 28 17:51:18 EST 2014 ppc64

[watchdog] 27853 iterations. [F:22642 S:5174 HI:1276]
------------[ cut here ]------------
kernel BUG at /home/michael/mmk-build/flow/mm/memory.c:1489!
cpu 0xc: Vector: 700 (Program Check) at [c000000384eaf960]
    pc: c0000000001ad6f0: .follow_page_mask+0x90/0x650
    lr: c0000000001ad6d8: .follow_page_mask+0x78/0x650
    sp: c000000384eafbe0
   msr: 8000000000029032
  current = 0xc0000003c27e1bc0
  paca    = 0xc000000001dc3000   softe: 0        irq_happened: 0x01
    pid   = 20800, comm = trinity-c12
kernel BUG at /home/michael/mmk-build/flow/mm/memory.c:1489!
enter ? for help
[c000000384eafcc0] c0000000001e5514 .SyS_move_pages+0x524/0x7d0
[c000000384eafe30] c00000000000a1d8 syscall_exit+0x0/0x98
--- Exception: c01 (System Call) at 00003fff795f30a8
SP (3ffff958f290) is in userspace


I've left it in the debugger, can dig into it a bit more tomorrow if anyone has
any clues.

cheers


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
