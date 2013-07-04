From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 2/6] trinity.c: log errors if socket calls fail
Date: Thu,  4 Jul 2013 22:55:40 +0300
Message-ID: <1372967744-29353-3-git-send-email-mikko.rapeli@iki.fi>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Maybe that's all that needs to be done at this point.

Coverity CID 1042335 (#1 of 1): Unchecked return value from library
(CHECKED_RETURN)

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 trinity.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/trinity.c b/trinity.c
index 3f80020..de61dcb 100644
--- a/trinity.c
+++ b/trinity.c
@@ -249,12 +249,17 @@ int main(int argc, char* argv[])
 cleanup_fds:
 
 	for (i = 0; i < nr_sockets; i++) {
+		int r = 0;
 		struct linger ling;
 		memset(&ling, 0, sizeof(ling));
 
 		ling.l_onoff = FALSE;	/* linger active */
-		setsockopt(shm->socket_fds[i], SOL_SOCKET, SO_LINGER, &ling, sizeof(struct linger));
-		shutdown(shm->socket_fds[i], SHUT_RDWR);
+		r = setsockopt(shm->socket_fds[i], SOL_SOCKET, SO_LINGER, &ling, sizeof(struct linger));
+		if (r)
+			perror("setsockopt");
+		r = shutdown(shm->socket_fds[i], SHUT_RDWR);
+		if (r)
+			perror("shutdown");
 		close(shm->socket_fds[i]);
 	}
 
-- 
1.8.3.1
