From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCHv2 1/2] trinity.c: fix uninitialized variable
Date: Fri,  5 Jul 2013 19:15:53 +0300
Message-ID: <1373040954-18797-1-git-send-email-mikko.rapeli@iki.fi>
References: <20130705144449.GA31027@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130705144449.GA31027@redhat.com>
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
 trinity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/trinity.c b/trinity.c
index 93e7819..32717c0 100644
--- a/trinity.c
+++ b/trinity.c
@@ -249,7 +249,7 @@ int main(int argc, char* argv[])
 cleanup_fds:
 
 	for (i = 0; i < nr_sockets; i++) {
-		struct linger ling;
+		struct linger ling = { .l_onoff = FALSE, };
 
 		ling.l_onoff = FALSE;	/* linger active */
 		setsockopt(shm->socket_fds[i], SOL_SOCKET, SO_LINGER, &ling, sizeof(struct linger));
-- 
1.8.3.1
