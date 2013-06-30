From: Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH 1/8] Use TRINITY_PF_MAX instead of PF_MAX in syscalls/socket.c
Date: Sun, 30 Jun 2013 22:33:05 +0300
Message-ID: <1372620792-16384-2-git-send-email-tt.rantala@gmail.com>
References: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=DgKWq+ldSQ0Wa3kbDCCsw13l+oKUrCkGYgBoOhOqS4U=;
        b=Epu/DHn3yNZ54XxjFR7/Ns3E8Kq5DbOCarvtgdLVauSGnJ6R9lh1bPNUEel/dNWZjk
         eUWoPwGj1RC1qoWrhSGpMQ3LYS2YN1R08oyB0acQ4bzsRniiwnjqH9bx64nBqbklwjk7
         iv01FdehknEfy32zYb7pDbxaaTtwygPUXag5cf4nqz045PwZ15+kwD6+uODaI8MOYSR8
         QNOa6NjbFTquh9WvD3salW70RbSqJ0pMb6aRqxSFLEGTs2vWJx7dP0Vzb1OuN7+Ay4rI
         Q/tafS5PvxiYb3lLF38ahhAeSKsGt9w7uwOt2LeU8+e++0q9DYpDJ2Az5VUJz+D98UsZ
         2AcQ==
In-Reply-To: <1372620792-16384-1-git-send-email-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

---
 syscalls/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/syscalls/socket.c b/syscalls/socket.c
index 26e3a6e..3601c04 100644
--- a/syscalls/socket.c
+++ b/syscalls/socket.c
@@ -47,7 +47,7 @@ void sanitise_socket(int childno)
 	if (do_specific_proto == TRUE)
 		family = specific_proto;
 	else
-		family = rand() % PF_MAX;
+		family = rand() % TRINITY_PF_MAX;
 
 	type = rand() % TYPE_MAX;
 	protocol = rand() % PROTO_MAX;
-- 
1.8.1.4
