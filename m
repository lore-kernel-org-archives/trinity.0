From: Fabien Siron <fabien.siron@epita.fr>
Subject: [PATCH] net/proto-unix.c: set protocol to 0 in unix_rand_socket()
Date: Tue, 5 Jul 2016 10:02:46 +0000
Message-ID: <20160705100246.3951-1-fabien.siron@epita.fr>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=epitafr.onmicrosoft.com; s=selector1-epita-fr;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qSsP75Sj7d3rodge92b25foyaRJBTJ1FxHzhHXKvYf8=;
 b=nSJf2uxhaVuRV8JF+f8au9LVtW9IU1uMH6ZQcx0NEMZOXYaJGRWH9MjSJBT5siYk7ClesqH3R6YPrslxPWLZzNojnzRT1GpSJtndF02xbXFLo0C/Jrim1zq36dLTtgGB7fpS7WfYKmtGZJVwTizwU+v+vhdFrG42v4yOlEE9B3U=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Fabien Siron <fabien.siron@epita.fr>

The protocol of an AF_UNIX socket should be 0.

Signed-off-by: Fabien Siron <fabien.siron@epita.fr>
---
 net/proto-unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/proto-unix.c b/net/proto-unix.c
index 2ef0457..8d1ee9a 100644
--- a/net/proto-unix.c
+++ b/net/proto-unix.c
@@ -24,7 +24,7 @@ static void unix_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
 
 static void unix_rand_socket(struct socket_triplet *st)
 {
-	st->protocol = PF_UNIX;
+	st->protocol = 0;
 
 	switch (rnd() % 3) {
 	case 0: st->type = SOCK_STREAM;
-- 
2.9.0
