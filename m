From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 3/6] net: protocols -- Add lookup_proto helper
Date: Wed, 30 Oct 2013 16:15:43 +0400
Message-ID: <1383135346-31463-4-git-send-email-gorcunov@openvz.org>
References: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0lvA5PNV5Yyj8fUsf5QoXtbO5PGN+Exho432xAHhI18=;
        b=0efzgetIX6WcjZS/SVUgQowQq4gDUDCoZC7tXpuS4MunZ9dndkq73tyS719U5F1iFU
         XEnnGvvBxv08RBcg0HU3FxdfpQNeS98bMAhNFc3CwveiKT5pdjIieX29F5VO46UypT63
         MRivYwXcguiTPDeUwJGQsy4OeK+ZGDHt97i8v4+iCYTO6H0W5i3FtwgEMI0TGWaYVoPg
         vV74I0f6rocJ85WPlBYyGK8/9ZTKH5dTHZY7p10ng6wZWEHp8MFOpaaWHPXh6JWHnguy
         CZen5Wgks2Vptilhn59MG1AFxc5wr1jpWmUW2duqg3iX871+X61e4nIdMHkS3n/13MoV
         IEUA==
In-Reply-To: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

We will use it for parsing disabled sockets families as well.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 net/protocols.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/net/protocols.c b/net/protocols.c
index c4a4ae2..4331351 100644
--- a/net/protocols.c
+++ b/net/protocols.c
@@ -58,6 +58,19 @@ static const struct protocol protocols[] = {
 	{ "PF_VSOCK",        40 },
 };
 
+static const struct protocol *lookup_proto(const char *name, unsigned int proto)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(protocols); i++) {
+		if ((name && strcmp(name, protocols[i].name) == 0) ||
+		    (proto != -1u && protocols[i].proto == proto))
+			return &protocols[i];
+	}
+
+	return NULL;
+}
+
 const char * get_proto_name(unsigned int proto)
 {
 	unsigned int i;
@@ -70,33 +83,20 @@ const char * get_proto_name(unsigned int proto)
 
 void find_specific_proto(const char *protoarg)
 {
+	const struct protocol *p;
 	unsigned int i;
 
-	if (specific_proto == 0) {
-		/* we were passed a string */
-		for (i = 0; i < ARRAY_SIZE(protocols); i++) {
-			if (strcmp(protoarg, protocols[i].name) == 0) {
-				specific_proto = protocols[i].proto;
-				output(2, "Proto %s = %d\n", protoarg, specific_proto);
-				break;
-			}
-		}
-	} else {
-		/* we were passed a numeric arg. */
-		for (i = 0; i < ARRAY_SIZE(protocols); i++) {
-			if (specific_proto == protocols[i].proto)
-				break;
-		}
+	p = lookup_proto(protoarg, specific_proto ? : -1u);
+	if (p) {
+		specific_proto = p->proto;
+		output(2, "Using protocol %s (%u) for all sockets\n", p->name, p->proto);
+		return;
 	}
 
-	if (i > ARRAY_SIZE(protocols)) {
-		outputerr("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
-		for (i = 0; i < ARRAY_SIZE(protocols); i++)
-			outputerr("%s ", protocols[i].name);
-		outputerr("\n");
-
-		exit(EXIT_FAILURE);
-	}
+	outputerr("Protocol unknown. Pass a numeric value [0-%d] or one of ", TRINITY_PF_MAX);
+	for (i = 0; i < ARRAY_SIZE(protocols); i++)
+		outputerr("%s ", protocols[i].name);
+	outputerr("\n");
 
-	output(2, "Using protocol %s (%u) for all sockets\n", protocols[i].name, protocols[i].proto);
+	exit(EXIT_FAILURE);
 }
-- 
1.8.3.1
