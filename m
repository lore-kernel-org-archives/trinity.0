From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] fix off-by-one in dump_childnos()
Date: Sun, 16 Apr 2017 21:29:14 +0300
Message-ID: <20170416182914.24457-1-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=y1hfVr2ioDCTdKahl495BAm4U1LxGfACVxv1/hKsMv8=;
        b=IlINhhar+WZUI5RMFYI8sox2i8edfGU6MtY8qosc88gDgRtMSQi9/VH9+NcyjT2oRZ
         vdbdiJpM8eSYkdSD3zfcBkbEI9ZFypfXZZJu6/HfdM/Dyt5shFleKAhCHoIZHhpiwO1T
         XdB/b+jMx/oxOhbGlegW2k6HRu6Gf2gQQFRDJDEwE/HSItDMYvZwV/gMWDNVUPP4/6E2
         bIm6BIxfuTfg2MfkFYg1QWFBfw0Wv9CqPLyyI96WONIDDsygvDi1OSQCsvk36qB9lCnr
         pJz6zxq8ksx+fLxN1OmHjU6o+gMYe4ec778eH0TnUC9ON2dF7lJpQn0bj0kvVtaoiRC9
         aQQA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Fixes a segfault:

  ## pids: (60 active)
  0-7: 0 0 0 0 0 0 0 0
  8-15: 0 0 0 0 0 0 0 0
  16-23: 0 0 0 0 0 0 0 0
  24-31: 0 0 0 0 0 0 0 0
  32-39: 0 11081 11082 11083 11084 11085 11086 11087
  40-47: 11088 11089 11090 11091 11093 11094 11095 11096
  48-55: 11097 11098 11099 11100 11101 11102 0 0
  Segmentation fault
---
 pids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/pids.c b/pids.c
index 8b77e2f..1a23284 100644
--- a/pids.c
+++ b/pids.c
@@ -82,7 +82,7 @@ void dump_childnos(void)
 		for (j = 0; j < 8; j++) {
 			struct childdata *child;
 
-			if (i + j > max_children)
+			if (i + j >= max_children)
 				break;
 
 			child = shm->children[i + j];
-- 
2.9.3
