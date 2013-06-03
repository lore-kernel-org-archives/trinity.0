From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH 1/4] net: bpf: let clang shut up
Date: Mon,  3 Jun 2013 21:07:41 +0200
Message-ID: <d194171fa5860d6faa2c888cb1c8aaed49407712.1370285968.git.dborkman@redhat.com>
References: <cover.1370285968.git.dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <cover.1370285968.git.dborkman@redhat.com>
In-Reply-To: <cover.1370285968.git.dborkman@redhat.com>
References: <cover.1370285968.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, davej@redhat.com, dborkman@redhat.com

Let clang warning shut up and initialize the allocated area
with zeroes.

  CC	net/bpf.o
net/bpf.c:297:16: warning: The left expression of the compound assignment
       is an uninitialized value. The computed value will also be garbage
                curr[1].code |= (uint16_t) rand();
                ~~~~~~~~~~~~ ^
net/bpf.c:299:16: warning: The left expression of the compound assignment
       is an uninitialized value. The computed value will also be garbage
                curr[2].code |= (uint16_t) rand();
                ~~~~~~~~~~~~ ^

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 net/bpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bpf.c b/net/bpf.c
index cc748de..bda72e1 100644
--- a/net/bpf.c
+++ b/net/bpf.c
@@ -338,11 +338,15 @@ void gen_seccomp_bpf(unsigned long *addr, unsigned long *addrlen)
 		return;
 	}
 
+	memset(bpf->filter, 0, bpf->len * sizeof(struct sock_filter));
+
 	seccomp_state = seccomp_choose(seccomp_markov_init);
+
 	for (curr = bpf->filter; avail > 3; ) {
 		used = gen_seccomp_bpf_code(curr);
 		curr  += used;
 		avail -= used;
+
 		seccomp_state = seccomp_choose(seccomp_markov[seccomp_state]);
 	}
 
-- 
1.7.11.7
