From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH trinity] net: bpf: increase the chance that the semi-random bpf is run
Date: Thu, 16 May 2013 16:10:25 +0200
Message-ID: <1368713425-1532-1-git-send-email-dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org

The kernel filter code expects us to have a return instruction and
that won't be changed in the kernel code. So increase the chance that
we can also get past the filter precheck and run this fuzzed filter
code.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 Just a minor addon to the previous patch.

 net/bpf.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/bpf.c b/net/bpf.c
index c628ac0..88f4697 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -110,10 +110,20 @@ static const uint16_t bpf_misc_vars[] = {
 #define bpf_rand(type) \
 	(bpf_##type##_vars[rand() % ARRAY_SIZE(bpf_##type##_vars)])
 
-static uint16_t gen_bpf_code(void)
+static uint16_t gen_bpf_code(bool last_instr)
 {
 	uint16_t ret = bpf_rand(class);
 
+	if (last_instr) {
+		/* The kernel filter precheck code already tests if
+		 * there's a return instruction as the last one, so
+		 * increase the chance to be accepted and that we
+		 * actually run the generated fuzz filter code.
+		 */
+		if (rand() % 2 == 0)
+			ret = BPF_RET;
+	}
+
 	switch (ret) {
 	case BPF_LD:
 	case BPF_LDX:
@@ -168,7 +178,7 @@ void gen_bpf(unsigned long *addr, unsigned long *addrlen)
 	for (i = 0; i < bpf->len; i++) {
 		memset(&bpf->filter[i], 0, sizeof(bpf->filter[i]));
 
-		bpf->filter[i].code = gen_bpf_code();
+		bpf->filter[i].code = gen_bpf_code(i == bpf->len - 1);
 
 		/* Fill out jump offsets if jmp instruction */
 		if (BPF_CLASS(bpf->filter[i].code) == BPF_JMP) {
-- 
1.7.11.7
