From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 4/8] Fix double rand() in generate_pathname()
Date: Sun, 30 Jun 2013 22:33:08 +0300
Message-ID: <1372620792-16384-5-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=lBVw6/L63pGvNnB77y6KfDC56PlpiHj3vgoE53Z14e4=;
        b=k37oxBlKqAAkNppeq4F4mAc81HjNL6fT/OW98Df+6W5NWI8g7CSm9HqutNYZG14iIZ
         +SjEFJ1uWVkPiFU+KtZhUtK3NZLkMqSiJnqIn890qKYUKDQ9+vc6gtBMoz3qxPc2t9/q
         B9ake8LJj34U9uicMeLpwHxDwhIqYJTrcIOZBjc9Y6hjKN8/5AEmSKe0Hyh4tc/YPTeD
         nFFQxr7ukVXOolrQa/+isEGBOfc2akRSyM+gWLurZlGk574oH9xV1ZmVf14vtZG3ShyV
         14fiwHXVY3IX1ZUMyZU5uEQbdn63zadV2wmIZkWI0jLm/pKZXfc0Fjbc4N7UCpDJxFsN
         mFTg==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

We take 90% chance two times in the "unmangled" path in
generate_pathname(); looks accidental to me.
---
 files.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/files.c b/files.c
index 3319eef..ef44ee2 100644
--- a/files.c
+++ b/files.c
@@ -362,8 +362,7 @@ char * generate_pathname(void)
 
 	case 0 ... 90:
 		/* 90% chance of returning an unmangled filename */
-		if ((rand() % 100) > 10)
-			return pathname;
+		return pathname;
 
 	case 91 ... 99:
 		/* Create a bogus filename. */
-- 
1.8.1.4
