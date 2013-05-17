From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Add KVM symbols for older kernels.
Date: Thu, 16 May 2013 18:35:40 -0700
Message-ID: <1368754540-28999-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors on 3.4 and older.

  CC	ioctls/kvm.o
ioctls/kvm.c:21:2: error: =E2=80=98KVM_S390_UCAS_MAP=E2=80=99 undeclare=
d here (not in a function)
ioctls/kvm.c:22:2: error: =E2=80=98KVM_S390_UCAS_UNMAP=E2=80=99 undecla=
red here (not in a function)
ioctls/kvm.c:23:2: error: =E2=80=98KVM_S390_VCPU_FAULT=E2=80=99 undecla=
red here (not in a function)
ioctls/kvm.c:55:2: error: =E2=80=98KVM_ASSIGN_SET_INTX_MASK=E2=80=99 un=
declared here (not in a function)
ioctls/kvm.c:56:2: error: =E2=80=98KVM_SIGNAL_MSI=E2=80=99 undeclared h=
ere (not in a function)
ioctls/kvm.c:114:2: error: =E2=80=98KVM_DIRTY_TLB=E2=80=99 undeclared h=
ere (not in a function)
ioctls/kvm.c:115:2: error: =E2=80=98KVM_GET_ONE_REG=E2=80=99 undeclared=
 here (not in a function)
ioctls/kvm.c:116:2: error: =E2=80=98KVM_SET_ONE_REG=E2=80=99 undeclared=
 here (not in a function)
ioctls/kvm.c:117:2: error: =E2=80=98KVM_KVMCLOCK_CTRL=E2=80=99 undeclar=
ed here (not in a function)
make: *** [ioctls/kvm.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 include/compat.h |   56 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
 1 file changed, 56 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 10457ad..b98f714 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -513,4 +513,60 @@ struct kvm_reg_list {
 #define KVM_GET_REG_LIST          _IOWR(KVMIO, 0xb0, struct kvm_reg_li=
st)
 #endif
=20
+#ifndef KVM_S390_UCAS_MAP
+struct kvm_s390_ucas_mapping {
+        __u64 user_addr;
+        __u64 vcpu_addr;
+        __u64 length;
+};
+#define KVM_S390_UCAS_MAP         _IOW(KVMIO, 0x50, struct kvm_s390_uc=
as_mapping)
+#endif
+
+#ifndef KVM_S390_UCAS_UNMAP
+#define KVM_S390_UCAS_UNMAP       _IOW(KVMIO, 0x51, struct kvm_s390_uc=
as_mapping)
+#endif
+
+#ifndef KVM_S390_VCPU_FAULT
+#define KVM_S390_VCPU_FAULT       _IOW(KVMIO, 0x52, unsigned long)
+#endif
+
+#ifndef KVM_ASSIGN_SET_INTX_MASK
+#define KVM_ASSIGN_SET_INTX_MASK  _IOW(KVMIO,  0xa4, struct kvm_assign=
ed_pci_dev)
+#endif
+
+#ifndef KVM_SIGNAL_MSI
+struct kvm_msi {
+        __u32 address_lo;
+        __u32 address_hi;
+        __u32 data;
+        __u32 flags;
+        __u8  pad[16];
+};
+#define KVM_SIGNAL_MSI            _IOW(KVMIO,  0xa5, struct kvm_msi)
+#endif
+
+#ifndef KVM_DIRTY_TLB
+struct kvm_dirty_tlb {
+        __u64 bitmap;
+        __u32 num_dirty;
+};
+#define KVM_DIRTY_TLB             _IOW(KVMIO,  0xaa, struct kvm_dirty_=
tlb)
+#endif
+
+#ifndef KVM_GET_ONE_REG
+struct kvm_one_reg {
+        __u64 id;
+        __u64 addr;
+};
+#define KVM_GET_ONE_REG           _IOW(KVMIO,  0xab, struct kvm_one_re=
g)
+#endif
+
+#ifndef KVM_SET_ONE_REG
+#define KVM_SET_ONE_REG           _IOW(KVMIO,  0xac, struct kvm_one_re=
g)
+#endif
+
+#ifndef KVM_KVMCLOCK_CTRL
+#define KVM_KVMCLOCK_CTRL         _IO(KVMIO,   0xad)
+#endif
+
 #endif	/* _TRINITY_COMPAT_H */
--=20
1.7.9.5
