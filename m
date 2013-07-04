From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 5/6] sockets.c: don't leak cachefile on return paths
Date: Thu,  4 Jul 2013 22:55:43 +0300
Message-ID: <1372967744-29353-6-git-send-email-mikko.rapeli@iki.fi>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Fixes Coverity CID's 1042341 and 1042342.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 sockets.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sockets.c b/sockets.c
index 7eade96..75acc5b 100644
--- a/sockets.c
+++ b/sockets.c
@@ -99,8 +99,10 @@ void generate_sockets(void)
 
 	while (nr_to_create > 0) {
 
-		if (shm->exit_reason != STILL_RUNNING)
+		if (shm->exit_reason != STILL_RUNNING) {
+			close(cachefile);
 			return;
+		}
 
 		/* Pretend we're child 0 and we've called sys_socket */
 		sanitise_socket(0);
@@ -213,6 +215,7 @@ void open_sockets(void)
 			if (domain != specific_proto) {
 				printf("ignoring socket cachefile due to specific protocol request, and stale data in cachefile.\n");
 				generate_sockets();
+				close(cachefile);
 				return;
 			}
 		}
@@ -231,9 +234,10 @@ regenerate:
 		}
 
 		/* check for ctrl-c */
-		if (shm->exit_reason != STILL_RUNNING)
+		if (shm->exit_reason != STILL_RUNNING) {
+			close(cachefile);
 			return;
-
+		}
 	}
 
 	if (nr_sockets < NR_SOCKET_FDS) {
-- 
1.8.3.1
