From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/5] x86: oops on uaccess faults outside of user addresses
Date: Wed, 22 May 2013 14:07:39 -0700
Message-ID: <cover.1369177867.git.luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>

Currently, __get_user can't trigger an OOPS -- any exception will be
caught and return -EFAULT.  This means that, if an access_ok check is
missing somewhere, then an attacker can freely use it to probe for valid
kernel mappings.

This series annotates all of the exception fixups as "catch anything" or
"catch valid uaccess faults", and skips the fixup (and hence oopses) if
an instruction of the latter type faults for any reason other than a
page fault to a user address.

I know of only one bug of this type; it's fixed in patch 5.

Perhaps surprisingly, this seems to survive Trinity fairly well.

Andy Lutomirski (5):
  x86: Split "utter crap" pnpbios fixup out of fixup_exception
  x86: Clean up extable entry format (and free up a bit)
  x86: Annotate _ASM_EXTABLE users to distinguish uaccess from
    everything else
  x86: Don't fixup uaccess faults to kernel or non-canonical addresses
  net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

 arch/x86/ia32/ia32entry.S             |   4 +-
 arch/x86/include/asm/asm.h            |  75 ++++++++----
 arch/x86/include/asm/fpu-internal.h   |   6 +-
 arch/x86/include/asm/futex.h          |   8 +-
 arch/x86/include/asm/kvm_host.h       |   2 +-
 arch/x86/include/asm/msr.h            |   4 +-
 arch/x86/include/asm/segment.h        |   2 +-
 arch/x86/include/asm/special_insns.h  |   2 +-
 arch/x86/include/asm/traps.h          |   6 +
 arch/x86/include/asm/uaccess.h        |  10 +-
 arch/x86/include/asm/word-at-a-time.h |   2 +-
 arch/x86/include/asm/xsave.h          |   6 +-
 arch/x86/kernel/entry_32.S            |  26 ++---
 arch/x86/kernel/entry_64.S            |   6 +-
 arch/x86/kernel/ftrace.c              |   4 +-
 arch/x86/kernel/kprobes/core.c        |   4 +-
 arch/x86/kernel/test_nx.c             |   2 +-
 arch/x86/kernel/test_rodata.c         |   2 +-
 arch/x86/kernel/traps.c               |  12 +-
 arch/x86/kvm/emulate.c                |   4 +-
 arch/x86/lib/checksum_32.S            |   4 +-
 arch/x86/lib/copy_user_64.S           |  50 ++++----
 arch/x86/lib/copy_user_nocache_64.S   |  44 +++----
 arch/x86/lib/csum-copy_64.S           |   6 +-
 arch/x86/lib/getuser.S                |  12 +-
 arch/x86/lib/mmx_32.c                 |  12 +-
 arch/x86/lib/msr-reg.S                |   4 +-
 arch/x86/lib/putuser.S                |  10 +-
 arch/x86/lib/usercopy_32.c            | 212 +++++++++++++++++-----------------
 arch/x86/lib/usercopy_64.c            |   4 +-
 arch/x86/mm/extable.c                 |  41 +++----
 arch/x86/mm/fault.c                   |  36 ++++--
 arch/x86/mm/init_32.c                 |   2 +-
 arch/x86/um/checksum_32.S             |   4 +-
 arch/x86/xen/xen-asm_32.S             |   2 +-
 net/socket.c                          |  33 +++++-
 36 files changed, 375 insertions(+), 288 deletions(-)

-- 
1.8.1.4
