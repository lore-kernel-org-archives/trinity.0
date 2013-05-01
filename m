From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] setsockopt: sanitize PF_PACKET SOL_PACKET options for zero-copy rings
Date: Wed,  1 May 2013 17:10:15 +0200
Message-ID: <3f833e7246a223dc545e3f9d06b75ebeca723e6f.1367420720.git.dborkman@redhat.com>
References: <cover.1367420720.git.dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <cover.1367420720.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org

In SOL_PACKET, we can sanitize the setsockopt() syscall a bit in the
following ways:

i) PACKET_VERSION is always checked in the kernel and it is quite
   likely to return -EINVAL here, very unlikely to crash this option.
   However, if we pass the correct values to it (TPACKET_V1, TPACKET_V2,
   TPACKET_V3), we can jump into this version specific code on other
   syscalls on that socket.

ii) PACKET_{R,T}X_RING never gets a structure of size int, so it might
    always return -EINVAL here. Depending on the TPACKET version, it
    can either be tpacket_req or tpacket_req3. Make it more likely to
    have size tpacket_req though.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 syscalls/setsockopt.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index ce610af..2932bfb 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -185,6 +185,22 @@ void sanitise_setsockopt(int childno)
 	case SOL_PACKET:
 		val = rand() % NR_SOL_PACKET_OPTS;
 		shm->a3[childno] = packet_opts[val];
+
+		/* Adjust length according to operation set. */
+		switch (shm->a3[childno]) {
+		case PACKET_VERSION:
+			page_rand[0] = rand() % 3; /* tpacket versions 1/2/3 */
+			break;
+		case PACKET_TX_RING:
+		case PACKET_RX_RING:
+			if (rand() % 3 == 0)
+				shm->a5[childno] = sizeof(struct tpacket_req3);
+			else
+				shm->a5[childno] = sizeof(struct tpacket_req);
+			break;
+		default:
+			break;
+		}
 		break;
 
 	case SOL_ATM:
-- 
1.7.11.7
