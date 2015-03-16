From: tyson.w.smith@gmail.com
Subject: [PATCH 1/7] add random_pathstring()
Date: Mon, 16 Mar 2015 13:25:21 -0700
Message-ID: <1426537521-54786-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=wAHCn2zJFrFd7eF8vtEcDnUGyy1JNB2Kdy+hgIseD+k=;
        b=GkJaodkXSR/jXkzrxCp6R4wLVf9QpeeM/WQVRdIVHr2n0uLNX/TI5vV4O0LzxsA5Mj
         vjE4egjUs+MT8jYjH22DeW6WDTmlhbxVbEr9Y+BUzsykNgHtgtCc6qctlZh9ekJ6R8a2
         SFx/hHSCQiW/oLuqyluAWtw3oDV0rUJioRJHA84NsHd5A/EqCsKfMgTIjMf2WE8N/ksm
         uNHtnraui6WEAjOfOrD3zDNfK6JGh5zoOxoT0jR6uZkr/aVMm44l/FYLdaGK/wAwMK5c
         ugCi0KEVXyV3ZrOoxjDlN2EYaZocU21R1ZWPlL6dxkYRZdOBHo9apI6wN1t+HdUIR+UG
         3lgw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

This will generate a path that will likely not exist but may
look somewhat valid or totally crazy depending on rand.
---
 random-pathname.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/random-pathname.c b/random-pathname.c
index 4d093d1..d8f5094 100644
--- a/random-pathname.c
+++ b/random-pathname.c
@@ -9,6 +9,52 @@
 
 #define MAX_PATH_LEN 4096
 
+/*
+ * Generate a path that will likely not exist but may look
+ * somewhat valid or totally crazy depending on rand.
+ */
+static void random_pathstring(char *path, unsigned int len) {
+	const char *fmts = "dns";
+	unsigned int i;
+
+	if (len < 1)
+		return;
+
+	switch(rand() % 5) {
+	case 0:
+		// single repeating random ASCII character
+		(void) memset(path, (rand() % 95) + 32, rand() % len);
+		path[len-1] = '\0';
+		break;
+	case 1:
+		// random ASCII characters 32(space) -> 126(~)
+		for (i=0; i < len; i++)
+			path[i] = (char) ((rand() % 95) + 32);
+		path[len-1] = '\0';
+		break;
+	case 2:
+		// random . or /
+		for (i=0; i < len; i++)
+			path[i] = RAND_BOOL() ? '.' : '/';
+		path[len-1] = '\0';
+		break;
+	case 3:
+		// format strings
+		for (i=0; i < (len - 2); i+=2) {
+			path[i] = '%';
+			path[i+1] = fmts[rand() % 3];
+		}
+		path[len-1] = '\0';
+		break;
+	case 4:
+		// junk
+		for (i=0; i < len; i++)
+			path[i] = (char) RAND_BYTE();
+		path[len-1] = '\0';
+		break;
+	}
+}
+
 const char * generate_pathname(void)
 {
 	const char *pathname = get_filename();
@@ -25,6 +71,13 @@ const char * generate_pathname(void)
 	/* Create a bogus filename. */
 	newpath = zmalloc(MAX_PATH_LEN);	// FIXME: We leak this.
 
+	/* 50/50 chance using a random path string */
+	if (RAND_BOOL()) {
+		len = RAND_BOOL() ? RAND_BYTE() : rand() % MAX_PATH_LEN;
+		random_pathstring(newpath, len);
+		return newpath;
+	}
+
 	len = strlen(pathname);
 
 	if (RAND_BOOL())
-- 
1.9.1
