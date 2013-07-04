From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 1/6] trinity.c: fix uninitialized variable
Date: Thu,  4 Jul 2013 22:55:39 +0300
Message-ID: <1372967744-29353-2-git-send-email-mikko.rapeli@iki.fi>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Coverity says:

CID 1042350 (#1 of 1): Uninitialized scalar variable (UNINIT)
23. uninit_use_in_call: Using uninitialized value "ling": field "ling"."l_linger" is uninitialized when calling "setsockopt(int, int, int, void const *, socklen_t)".

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 trinity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/trinity.c b/trinity.c
index 93e7819..3f80020 100644
--- a/trinity.c
+++ b/trinity.c
@@ -250,6 +250,7 @@ cleanup_fds:
 
 	for (i = 0; i < nr_sockets; i++) {
 		struct linger ling;
+		memset(&ling, 0, sizeof(ling));
 
 		ling.l_onoff = FALSE;	/* linger active */
 		setsockopt(shm->socket_fds[i], SOL_SOCKET, SO_LINGER, &ling, sizeof(struct linger));
-- 
1.8.3.1
