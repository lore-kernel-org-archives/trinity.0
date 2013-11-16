From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] net/bpf.c: Remove AUDIT_ARCH_H8300.
Date: Fri, 15 Nov 2013 17:20:59 -0800
Message-ID: <1384564859-22889-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

AUDIT_ARCH_H8300 was removed from include/uapi/linux/audit.h in Linux
3.13 commit 6f6f467eaaa0ac4fb77714d0172d65c781dabb8c.

commit 6f6f467eaaa0ac4fb77714d0172d65c781dabb8c
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Fri Aug 30 06:12:40 2013 -0700

    Drop remaining references to H8/300 architecture

    With the architecture gone, any references to it are no longer need=
ed.

    Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>

This patch fixes this build error.

  CC	net/bpf.o
net/bpf.c:135:18: error: =E2=80=98AUDIT_ARCH_H8300=E2=80=99 undeclared =
here (not in a function)
  AUDIT_ARCH_FRV, AUDIT_ARCH_H8300, AUDIT_ARCH_I386, AUDIT_ARCH_IA64,
                  ^

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 net/bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpf.c b/net/bpf.c
index fc94125..198f8e1 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -132,7 +132,7 @@ static const uint32_t bpf_seccomp_ret_k_vars[] =3D =
{
=20
 static const uint32_t bpf_seccomp_jmp_arch_vars[] =3D {
 	AUDIT_ARCH_ALPHA, AUDIT_ARCH_ARM, AUDIT_ARCH_ARMEB, AUDIT_ARCH_CRIS,
-	AUDIT_ARCH_FRV, AUDIT_ARCH_H8300, AUDIT_ARCH_I386, AUDIT_ARCH_IA64,
+	AUDIT_ARCH_FRV, AUDIT_ARCH_I386, AUDIT_ARCH_IA64,
 	AUDIT_ARCH_M32R, AUDIT_ARCH_M68K, AUDIT_ARCH_MIPS, AUDIT_ARCH_MIPSEL,
 	AUDIT_ARCH_MIPS64, AUDIT_ARCH_MIPSEL64, AUDIT_ARCH_PARISC,
 	AUDIT_ARCH_PARISC64, AUDIT_ARCH_PPC, AUDIT_ARCH_PPC64, AUDIT_ARCH_S39=
0,
--=20
1.8.4.2
