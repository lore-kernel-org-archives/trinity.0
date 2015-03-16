From: tyson.w.smith@gmail.com
Subject: [PATCH 5/7] make r an int to avoid unintended behavior
Date: Mon, 16 Mar 2015 13:26:32 -0700
Message-ID: <1426537592-54960-1-git-send-email-tyson.w.smith@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=R+WyWxDFmI9GAuao+Kd96tw7ffa/DJo+9fbkymODKxw=;
        b=zK51nSPz96G2xhoxgMRHiJN+MNPw8V+gudgK4UuueZ27QQxhbn6AvjZc2Qnux3HDvw
         R5Dabc7gTBPmZ6DUC9QTb7LyAJaYx/3dSACmLiHepfM/A7vtAKRWjkj2Yn5xxTiDfChA
         qW7OludnNTjNf29MlFe+lBg7dHviJ3hMIIWth5nTpneMVdJEwlmfMgAV/d5Qth4GWJaX
         a+wlfsHCAe3eyBkmkgB45tGM5r2cGw3xbbRHCB4HcykyKY1/kiyxcoJCV1o0b6pDl+De
         RvxkZXUVbkmfQU5B8EmPRKGJmdA0UHN+hcRaWcPQ8KD0e1IShHBjtwtcilkvZgSWQSmJ
         /dyA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, tysmith@motorola.com, Tyson Smith <tyson.w.smith@gmail.com>

From: Tyson Smith <tyson.w.smith@gmail.com>

---
 random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/random.c b/random.c
index 8b8de04..bbfc8da 100644
--- a/random.c
+++ b/random.c
@@ -87,7 +87,7 @@ static unsigned long rept_byte(void)
  */
 unsigned int rand32(void)
 {
-	unsigned long r = 0;
+	unsigned int r = 0;
 
 	switch (rand() % 4) {
 	case 0: r = rand_single_bit(32);
-- 
1.9.1
