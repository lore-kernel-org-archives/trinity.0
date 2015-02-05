From: Vinson Lee <vlee@twopensource.com>
Subject: [PATCH] kvm: Add ifdef around IA64 ioctls.
Date: Wed,  4 Feb 2015 17:06:42 -0800
Message-ID: <1423098402-25569-1-git-send-email-vlee@twopensource.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

=46ix build error.

  CC	ioctls/kvm.o
In file included from ioctls/kvm.c:8:0:
ioctls/kvm.c:115:8: error: =E2=80=98KVM_IA64_VCPU_GET_STACK=E2=80=99 un=
declared here (not in a function)
  IOCTL(KVM_IA64_VCPU_GET_STACK),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:116:8: error: =E2=80=98KVM_IA64_VCPU_SET_STACK=E2=80=99 un=
declared here (not in a function)
  IOCTL(KVM_IA64_VCPU_SET_STACK),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }

IA64 ioctls were removed in Linux 3.19.

commit 6b397158d07f885154b871a15f879d25b3de7579
Author: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
Date:   Thu Nov 20 14:43:18 2014 +0100

    kvm: remove IA64 ioctls

    KVM ia64 is no longer present so new applications shouldn't use the=
m.
    The main problem is that they most likely didn't work even before,
    because of a conflict in the #defines:

      #define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_g=
uest_debug)
      #define KVM_IA64_VCPU_SET_STACK   _IOW(KVMIO,  0x9b, void *)

    The argument to KVM_SET_GUEST_DEBUG is:

      struct kvm_guest_debug {
        __u32 control;
        __u32 pad;
        struct kvm_guest_debug_arch arch;
      };

      struct kvm_guest_debug_arch {
      };

    meaning that sizeof(struct kvm_guest_debug) =3D=3D sizeof(void *) =3D=
=3D 8
    and KVM_SET_GUEST_DEBUG =3D=3D KVM_IA64_VCPU_SET_STACK.

    KVM_SET_GUEST_DEBUG is handled in virt/kvm/kvm_main.c before even c=
alling
    kvm_arch_vcpu_ioctl (which would have handled KVM_IA64_VCPU_SET_STA=
CK),
    so KVM_IA64_VCPU_SET_STACK would just return -EINVAL.

    Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 ioctls/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ioctls/kvm.c b/ioctls/kvm.c
index ddd7e29..df64356 100644
--- a/ioctls/kvm.c
+++ b/ioctls/kvm.c
@@ -112,8 +112,10 @@ static const struct ioctl kvm_ioctls[] =3D {
 	IOCTL(KVM_SET_GUEST_DEBUG),
 	IOCTL(KVM_X86_SETUP_MCE),
 	IOCTL(KVM_X86_GET_MCE_CAP_SUPPORTED),
+#if defined(KVM_IA64_VCPU_GET_STACK)
 	IOCTL(KVM_IA64_VCPU_GET_STACK),
 	IOCTL(KVM_IA64_VCPU_SET_STACK),
+#endif
 	IOCTL(KVM_ENABLE_CAP),
 	IOCTL(KVM_DIRTY_TLB),
 	IOCTL(KVM_GET_ONE_REG),
--=20
2.2.2
