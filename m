From: Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 2/2] gitignore: ignore patch files
Date: Wed,  5 Jun 2013 17:41:24 +0800
Message-ID: <1370425284-18808-2-git-send-email-liuhangbin@gmail.com>
References: <1370425284-18808-1-git-send-email-liuhangbin@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=hhdSoITJvOXZYhUZYLXS8vtZURxRk/LDOb+2Q+q30J8=;
        b=A5VuysXyf7xbavaW4Yfd3EcPhFsYb3zWwLi8SKAUp+EeqTLoFuRZZVQ1jglivRpyNM
         wTEGqXtIFJGKqct2qg0um2nxdD2fL3jYHJCm5bM2XcUIXRK2rYYtGIp92s7g6n+TP3vN
         BD3ErKDEYMA0c1GfmPBkw0CTsw0MEJ80m7rzfRUuZcpIyMepoZMp1SWJrhHcUSDWkZ1B
         2Hv/VNZeJ3zki5aC/8aT7y7XJu6Nx5eB6Ib6aBfkpmRVijX9oWzlgwmfkn1K9MwZixg7
         HBvXK7IA3WASJVRncOo2QtAlU/FpF+jMhzbY2qw4BR3IMaz9eViuIURd40eQlQmMQbX2
         AFuA==
In-Reply-To: <1370425284-18808-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Hangbin Liu <liuhangbin@gmail.com>

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 156f787..831e3a9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -12,3 +12,4 @@ tags
 config.h
 cscope.*
 ncscope.*
+*.patch
-- 
1.8.1.4
