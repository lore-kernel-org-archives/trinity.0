From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH trinity] net: add generation of semi-random BPF filters
Date: Thu, 16 May 2013 11:54:16 +0200
Message-ID: <1368698056-411-1-git-send-email-dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org

BPF filters are used in networking and in application sand-boxing
and even have a arch-dependant JIT compiler in the kernel, so add
a more detailed semi-random BPF generator.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 Compile-tested only!

 include/net.h         |   3 +
 net/bpf.c             | 205 ++++++++++++++++++++++++++++++++++++++++++++++++++
 syscalls/setsockopt.c |   2 +
 3 files changed, 210 insertions(+)
 create mode 100644 net/bpf.c

diff --git a/include/net.h b/include/net.h
index e14430c..256533c 100644
--- a/include/net.h
+++ b/include/net.h
@@ -35,6 +35,9 @@ void gen_pppox(unsigned long *addr, unsigned long *addrlen);
 /* unix */
 void gen_unixsock(unsigned long *addr, unsigned long *addrlen);
 
+/* bpf */
+void gen_bpf(unsigned long *addr, unsigned long *addrlen);
+
 /* caif */
 void gen_caif(unsigned long *addr, unsigned long *addrlen);
 
diff --git a/net/bpf.c b/net/bpf.c
new file mode 100644
index 0000000..c628ac0
--- /dev/null
+++ b/net/bpf.c
@@ -0,0 +1,205 @@
+#include <linux/filter.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+
+#include "trinity.h"
+
+/**
+ * BPF filters are used in networking such as in pf_packet, but also
+ * in seccomp for application sand-boxing. Additionally, with arch
+ * specific BPF JIT compilers, this might be good to fuzz for errors.
+ *    -- Daniel Borkmann, <borkmann@redhat.com>
+ */
+
+/* Both here likely defined in linux/filter.h already */
+#ifndef SKF_AD_OFF
+# define SKF_AD_OFF	(-0x1000)
+#endif
+
+#ifndef SKF_AD_MAX
+# define SKF_AD_MAX	56
+#endif
+
+#define BPF_CLASS(code) ((code) & 0x07)
+#define	BPF_LD		0x00
+#define	BPF_LDX		0x01
+#define	BPF_ST		0x02
+#define	BPF_STX		0x03
+#define	BPF_ALU		0x04
+#define	BPF_JMP		0x05
+#define	BPF_RET		0x06
+#define	BPF_MISC	0x07
+
+static const uint16_t bpf_class_vars[] = {
+	BPF_LD, BPF_LDX, BPF_ST, BPF_STX, BPF_ALU, BPF_JMP, BPF_RET, BPF_MISC,
+};
+
+#define BPF_SIZE(code)	((code) & 0x18)
+#define	BPF_W		0x00
+#define	BPF_H		0x08
+#define	BPF_B		0x10
+
+static const uint16_t bpf_size_vars[] = {
+	BPF_W, BPF_H, BPF_B,
+};
+
+#define BPF_MODE(code)	((code) & 0xe0)
+#define	BPF_IMM 	0x00
+#define	BPF_ABS		0x20
+#define	BPF_IND		0x40
+#define	BPF_MEM		0x60
+#define	BPF_LEN		0x80
+#define	BPF_MSH		0xa0
+
+static const uint16_t bpf_mode_vars[] = {
+	BPF_IMM, BPF_ABS, BPF_IND, BPF_MEM, BPF_LEN, BPF_MSH,
+};
+
+#define BPF_OP(code)	((code) & 0xf0)
+#define	BPF_ADD		0x00
+#define	BPF_SUB		0x10
+#define	BPF_MUL		0x20
+#define	BPF_DIV		0x30
+#define	BPF_OR		0x40
+#define	BPF_AND		0x50
+#define	BPF_LSH		0x60
+#define	BPF_RSH		0x70
+#define	BPF_NEG		0x80
+#define BPF_MOD		0x90
+#define	BPF_XOR		0xa0
+
+static const uint16_t bpf_alu_op_vars[] = {
+	BPF_ADD, BPF_SUB, BPF_MUL, BPF_DIV, BPF_OR, BPF_AND, BPF_LSH, BPF_RSH,
+	BPF_NEG, BPF_MOD, BPF_XOR,
+};
+
+#define	BPF_JA		0x00
+#define	BPF_JEQ		0x10
+#define	BPF_JGT		0x20
+#define	BPF_JGE		0x30
+#define	BPF_JSET	0x40
+
+static const uint16_t bpf_jmp_op_vars[] = {
+	BPF_JA, BPF_JEQ, BPF_JGT, BPF_JGE, BPF_JSET,
+};
+
+#define BPF_SRC(code)	((code) & 0x08)
+#define	BPF_K		0x00
+#define	BPF_X		0x08
+
+static const uint16_t bpf_src_vars[] = {
+	BPF_K, BPF_X,
+};
+
+#define BPF_RVAL(code)	((code) & 0x18)
+#define	BPF_A		0x10
+
+static const uint16_t bpf_ret_vars[] = {
+	BPF_A, BPF_K, BPF_X,
+};
+
+#define BPF_MISCOP(code) ((code) & 0xf8)
+#define	BPF_TAX		0x00
+#define	BPF_TXA		0x80
+
+static const uint16_t bpf_misc_vars[] = {
+	BPF_TAX, BPF_TXA,
+};
+
+#define bpf_rand(type) \
+	(bpf_##type##_vars[rand() % ARRAY_SIZE(bpf_##type##_vars)])
+
+static uint16_t gen_bpf_code(void)
+{
+	uint16_t ret = bpf_rand(class);
+
+	switch (ret) {
+	case BPF_LD:
+	case BPF_LDX:
+	case BPF_ST:
+	case BPF_STX:
+		ret |= bpf_rand(size) | bpf_rand(mode) | bpf_rand(src);
+		break;
+	case BPF_ALU:
+		ret |= bpf_rand(alu_op) | bpf_rand(src);
+		break;
+	case BPF_JMP:
+		ret |= bpf_rand(jmp_op) | bpf_rand(src);
+		break;
+	case BPF_RET:
+		ret |= bpf_rand(ret);
+		break;
+	case BPF_MISC:
+		ret |= bpf_rand(misc);
+		break;
+	default:
+		ret = (uint16_t) rand();
+		break;
+	}
+
+	/* Also give it a chance to fuzz some crap into it */
+	if (rand() % 10 == 0)
+		ret |= (uint16_t) rand();
+
+	return ret;
+}
+
+void gen_bpf(unsigned long *addr, unsigned long *addrlen)
+{
+	int i;
+	struct sock_fprog *bpf = (void *) addr;
+
+	if (addrlen != NULL) {
+		bpf = malloc(sizeof(struct sock_fprog));
+		if (bpf == NULL)
+			return;
+	}
+
+	bpf->len = rand() % BPF_MAXINSNS;
+
+	bpf->filter = malloc(bpf->len * sizeof(struct sock_filter));
+	if (bpf->filter == NULL) {
+		if (addrlen != NULL)
+			free(bpf);
+		return;
+	}
+
+	for (i = 0; i < bpf->len; i++) {
+		memset(&bpf->filter[i], 0, sizeof(bpf->filter[i]));
+
+		bpf->filter[i].code = gen_bpf_code();
+
+		/* Fill out jump offsets if jmp instruction */
+		if (BPF_CLASS(bpf->filter[i].code) == BPF_JMP) {
+			bpf->filter[i].jt = (uint8_t) rand();
+			bpf->filter[i].jf = (uint8_t) rand();
+		}
+
+		/* Also give it a chance if not BPF_JMP */
+		if (rand() % 10 == 0)
+			bpf->filter[i].jt |= (uint8_t) rand();
+		if (rand() % 10 == 0)
+			bpf->filter[i].jf |= (uint8_t) rand();
+
+		/* Not always fill out k */
+		bpf->filter[i].k = rand() % 2 == 0 ? 0 : (uint32_t) rand();
+
+		/* Also try to jump into BPF extensions by chance */
+		if (BPF_CLASS(bpf->filter[i].code) == BPF_LD ||
+		    BPF_CLASS(bpf->filter[i].code) == BPF_LDX) {
+			if (bpf->filter[i].k > 65000 &&
+			    bpf->filter[i].k < (uint32_t) SKF_AD_OFF) {
+				if (rand() % 2 == 0) {
+					bpf->filter[i].k = (uint32_t) (SKF_AD_OFF +
+							   rand() % SKF_AD_MAX);
+				}
+			}
+		}
+	}
+
+	if (addrlen != NULL) {
+		*addr = (unsigned long) bpf;
+		*addrlen = sizeof(struct sock_fprog);
+	}
+}
diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index 1c18847..43ffb05 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -9,6 +9,7 @@
 #include "compat.h"
 #include "maps.h"
 #include "shm.h"
+#include "net.h"
 #include "config.h"
 #include "syscalls/setsockopt.h"
 
@@ -84,6 +85,7 @@ void sanitise_setsockopt(int childno)
 			shm->a5[childno] = sizeof(struct timeval);
 			break;
 		case SO_ATTACH_FILTER:
+			gen_bpf((unsigned long *) page_rand, NULL);
 			shm->a5[childno] = sizeof(struct sock_fprog);
 			break;
 		default:
-- 
1.7.11.7
