From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] Free correct argument in post_ppoll()
Date: Wed, 18 Nov 2015 15:58:04 +0200
Message-ID: <1447855084-64843-1-git-send-email-kirill.shutemov@linux.intel.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

sanitise_ppoll() allocates first and third arguments and we need to free
them in post_ppoll(), not first and fourth.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 syscalls/poll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/syscalls/poll.c b/syscalls/poll.c
index 2e491eca4ba1..da9ac671c4bc 100644
--- a/syscalls/poll.c
+++ b/syscalls/poll.c
@@ -80,7 +80,7 @@ static void sanitise_ppoll(struct syscallrecord *rec)
 static void post_ppoll(struct syscallrecord *rec)
 {
 	freeptr(&rec->a1);
-	freeptr(&rec->a4);
+	freeptr(&rec->a3);
 }
 
 struct syscallentry syscall_ppoll = {
-- 
2.6.2
