From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 2/2] Add compat definitions for recent powerpc KVM features
Date: Wed, 19 Jun 2013 18:59:34 +1000
Message-ID: <1371632374-16535-2-git-send-email-michael@ellerman.id.au>
References: <1371632374-16535-1-git-send-email-michael@ellerman.id.au>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1371632374-16535-1-git-send-email-michael@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

---
 include/compat.h |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/compat.h b/include/compat.h
index 75af388..7a456d4 100644
--- a/include/compat.h
+++ b/include/compat.h
@@ -646,6 +646,42 @@ struct kvm_one_reg {
 #define KVM_KVMCLOCK_CTRL         _IO(KVMIO,   0xad)
 #endif
 
+#ifndef KVM_PPC_GET_SMMU_INFO
+#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
+
+struct kvm_ppc_one_page_size {
+	__u32 page_shift;	/* Page shift (or 0) */
+	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
+};
+
+struct kvm_ppc_one_seg_page_size {
+	__u32 page_shift;	/* Base page shift of segment (or 0) */
+	__u32 slb_enc;		/* SLB encoding for BookS */
+	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+struct kvm_ppc_smmu_info {
+	__u64 flags;
+	__u32 slb_size;
+	__u32 pad;
+	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+#define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
+#endif
+
+#ifndef KVM_PPC_ALLOCATE_HTAB
+#define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
+#endif
+
+#ifndef KVM_PPC_GET_HTAB_FD
+struct kvm_get_htab_fd {
+	__u64	flags;
+	__u64	start_index;
+	__u64	reserved[2];
+};
+#define KVM_PPC_GET_HTAB_FD	  _IOW(KVMIO,  0xaa, struct kvm_get_htab_fd)
+#endif
+
 #ifndef EM_ARM
 #define EM_ARM                    40
 #endif
-- 
1.7.10.4
