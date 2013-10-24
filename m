From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] params: Add missing \n into usage output
Date: Thu, 24 Oct 2013 11:53:34 +0400
Message-ID: <1382601214-19394-1-git-send-email-gorcunov@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=BDJSF98axv1U52ZI8GeE3qlXa5CKzpJpBHIaDg2abqs=;
        b=dNL659jXOw6iW5SAtcHl0KH4htYqc2KoAWYpSjj2hzt8UgxFOh72sDtKFTlHR1Nfhh
         CZv6fhkVxMr+BQ8VdhJCs3IembW/jigZMTlHFIkihOdL6vWkrtPRlUXajB53OCdtuTCB
         YYIPD8AvxDWwPT9unPTVB0c+cN/veFtB7bX64Gv8MXNpy4GlCovn9ZTqoTKZunBmKlpd
         UaEsAYpX63S6FUxIthAvu2UIYc6XYMqlHRgIqJGF0XswP8ygRAy2AO1F14GYmthZfn5D
         C9L9bsGRfnqg3861uw73g+6y3hiqW2xf8yjg+TYPRWLvSSHvwjm25SNunOcGNCnbEJnX
         9UTg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/params.c b/params.c
index fe70ff3..77dc7e4 100644
--- a/params.c
+++ b/params.c
@@ -56,7 +56,7 @@ bool kernel_taint_param_occured = FALSE;
 static void usage(void)
 {
 	outputerr("%s\n", progname);
-	outputerr(" --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.");
+	outputerr(" --arch, -a: selects syscalls for the specified architecture (32 or 64). Both by default.\n");
 	outputerr(" --children,-C: specify number of child processes\n");
 	outputerr(" --exclude,-x: don't call a specific syscall\n");
 	outputerr(" --group,-g: only run syscalls from a certain group (So far just 'vm').\n");
-- 
1.8.3.1
