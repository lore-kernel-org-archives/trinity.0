From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 5/8] move perf_event.h to include/
Date: Sun, 30 Jun 2013 22:33:09 +0300
Message-ID: <1372620792-16384-6-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=GZTHnon+Z8nVBlHFtidDmJdE/rtzm24Up2ORXGENPiI=;
        b=tCNBT3tiEXO4uJuRGU+puQfIMcWm0I7NDeDeq9cYz+U69S97aa1lbf3uq+8QphTVqK
         +8L9wn4E3yqKYyRdyzpgYKcThbVHqYAMa/nUp2h5Fkw9RdvTc5zfoff7z3y3VefAG6Ks
         GYw25onZ1js1VsJ8XU1U7KxqmtfdhBz0KjNFXimlxDnopVSpd9EEym/4MZuCMowT5mPX
         OJtFDLDJJgofC5YyeKwi8FnNbIEMN28zkx5nhIXrD+trdgxRU5bWaMm0E5H1H6rNkjud
         Js60FjTFwHyDs2ADu91uy5OZmbhSQWlo9P8xiZGggt0GNM8x2gaim67060J+TSK7lhaK
         /M2w==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

The perf header will be used also in a few other places beyond syscalls,
so move it to the include/ directory so that it is easily available.
---
 {syscalls => include}/perf_event.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename {syscalls => include}/perf_event.h (100%)

diff --git a/syscalls/perf_event.h b/include/perf_event.h
similarity index 100%
rename from syscalls/perf_event.h
rename to include/perf_event.h
-- 
1.8.1.4
