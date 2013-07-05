From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCHv2 2/2] trinity.c: log errors if socket calls fail
Date: Fri,  5 Jul 2013 19:15:54 +0300
Message-ID: <1373040954-18797-2-git-send-email-mikko.rapeli@iki.fi>
References: <20130705144449.GA31027@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130705144449.GA31027@redhat.com>
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
index 32717c0..b3829fe 100644
--- a/trinity.c
+++ b/trinity.c
@@ -249,11 +249,16 @@ int main(int argc, char* argv[])
 cleanup_fds:
 
 	for (i = 0; i < nr_sockets; i++) {
+		int r = 0;
 		struct linger ling = { .l_onoff = FALSE, };
 
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
