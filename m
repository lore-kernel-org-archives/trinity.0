From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 2/6] net: protocols -- Use ARRAY_SIZE helper
Date: Wed, 30 Oct 2013 16:15:42 +0400
Message-ID: <1383135346-31463-3-git-send-email-gorcunov@openvz.org>
References: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+uHDUkXaGD5VuEiYuRRm3qQe5nIfn6bFaZ9KnmCHrVI=;
        b=zO7nPj19SF3ivLvQpE4mjhlRSZcKWnOuxXi7usd0DaBOxwlp9VsZ2X/XAUEOSWgESL
         on7426b5A0LNbJsn4kRQBxLGDao4DKjtk8goJnTR445X/OJJD8AG9ILKzAWEbu2nbHj4
         asv+czWtwl+sv9bpA4Ekiph/V7XRIeZ1WgyWPnzOkX7O2iawIcq4LBuoLS4ve3lQvoY8
         61rHAHuplWce4hWIJSB6bWy78/oSZ8YCHBggNc+H2SSsZ2c+Yd/u6rGku0lY1TTpS96L
         NkRzzxFoGjiu7cYTOZIHgEj+u+DP7GXxAN4nXmI97jq/H0fxXKOl5Waa1sYobMJEi7I2
         xxcQ==
In-Reply-To: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

We're looking up over @protocols array so use appropriate
helper here instead of TRINITY_PF_MAX constant.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 net/protocols.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/protocols.c b/net/protocols.c
index 891acfe..c4a4ae2 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -62,7 +62,7 @@ const char * get_proto_name(unsigned int proto)
 {
 	unsigned int i;
 
-	for (i = 0; i < TRINITY_PF_MAX; i++)
+	for (i = 0; i < ARRAY_SIZE(protocols); i++)
 		if (protocols[i].proto == proto)
 			return protocols[i].name;
 	return NULL;
@@ -83,13 +83,13 @@ void find_specific_proto(const char *protoarg)
 		}
 	} else {
 		/* we were passed a numeric arg. */
-		for (i = 0; i < TRINITY_PF_MAX; i++) {
+		for (i = 0; i < ARRAY_SIZE(protocols); i++) {
 			if (specific_proto == protocols[i].proto)
 				break;
 		}
 	}
 
-	if (i > TRINITY_PF_MAX) {
+	if (i > ARRAY_SIZE(protocols)) {
 		outputerr("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
 		for (i = 0; i < ARRAY_SIZE(protocols); i++)
 			outputerr("%s ", protocols[i].name);
-- 
1.8.3.1
