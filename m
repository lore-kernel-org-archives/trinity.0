From: Hangbin Liu <liuhangbin@gmail.com>
Subject: How about use default type for syscall setsockopt
Date: Mon, 26 Aug 2013 11:11:05 +0800
Message-ID: <20130826031105.GN14331@localhost.localdomain>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=St/7rgLEojYIMbA+GfuwT5U+EWI0K74OYg7GI0b4d74=;
        b=EYlXIjmWGteSUyP2Khc19K2tye+eFqp1dRGPtMbRXw5rTitzHBitRJIs64aLQwMc1m
         HGlPMEr+4G6/34b7HmFRFMIj2eLvdikpVl3XF9wXaGMFWaeKFC0fFJ9XQYb7aF6zX5W8
         cmacpHuVxdnHTHXk7nej1btg5IhxtnJQzKUhe+mCGKi+ii/raXSWfI325qmpA/wmfdsA
         tItwpGwYKbx+O365ZLamIwiJvHukxa2fTZ6G0gtiMD9LUSO3FJWsNKWUXDlwqwAJYCUA
         hl/Yoidk0ZzNgPOClsQgVVFNYGP+C6/HVZnvLjsWcOoXskjNW3lXbs5T9pQJPdj2QxSy
         0VFg==
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hi all,

I don't know why we use unsigned int/long for all sockopt parameters. But how
about use the default type for setsockopt. Then we can set optval for some
special options such as SO_LIGNER, SO_SNDTIMEO...


diff --git a/include/net.h b/include/net.h
index 78665d2..6306551 100644
--- a/include/net.h
+++ b/include/net.h
@@ -29,10 +29,10 @@ struct socket_triplet {
 };

 struct sockopt {
-       unsigned int level;
-       unsigned long optname;
-       unsigned long optval;
-       unsigned long optlen;
+       int level;
+       int optname;
+       const void *optval;
+       socklen_t optlen;
 };


-- 

Thanks & Best Regards
Hangbin Liu <liuhangbin@gmail.com>
