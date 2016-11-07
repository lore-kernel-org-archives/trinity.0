From: Jan Stancek <jstancek@redhat.com>
Subject: [PATCH] fix build when USE_BPF is not defined
Date: Mon,  7 Nov 2016 12:58:34 +0100
Message-ID: <dc2c60882d0fe97a0c956dd856d74aa3347a3e5f.1478519712.git.jstancek@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org, davej@codemonkey.org.uk
Cc: jstancek@redhat.com

net/bpf.o: In function `bpf_gen_filter': bpf.c:852: undefined reference to `get_rand_bpf_fd'

Signed-off-by: Jan Stancek <jstancek@redhat.com>
---
 net/bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bpf.c b/net/bpf.c
index 4fe941733016..bb07a777abe9 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -8,6 +8,7 @@
 #include <string.h>
 
 #include "bpf.h"
+#include "config.h"
 #include "debug.h"
 #include "log.h"
 #include "net.h"
@@ -849,8 +850,10 @@ void bpf_gen_filter(unsigned long **addr, unsigned long *addrlen)
 		switch (rnd() % 3) {
 		case 0:	bpf->filter[i].k = (uint32_t) rand32();
 			break;
+#ifdef USE_BPF
 		case 1:	bpf->filter[i].k = (uint32_t) get_rand_bpf_fd();
 			break;
+#endif
 		case 2:	break;
 		}
 
-- 
1.8.3.1
