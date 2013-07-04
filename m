From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 6/6] maps.c: only close() if fd is valid
Date: Thu,  4 Jul 2013 22:55:44 +0300
Message-ID: <1372967744-29353-7-git-send-email-mikko.rapeli@iki.fi>
References: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Fixes Coverity CID 1042340.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 maps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/maps.c b/maps.c
index 62b2328..b61575e 100644
--- a/maps.c
+++ b/maps.c
@@ -114,7 +114,8 @@ static void * alloc_zero_map(struct map *map, int prot, const char *name)
 	output(2, "mapping[%d]: (zeropage %s) %p (%lu bytes)\n",
 			num_mappings - 1, name, tmpmap->ptr, size);
 
-	close(fd);
+	if (fd >= 0)
+		close(fd);
 	return tmpmap;
 }
 
-- 
1.8.3.1
