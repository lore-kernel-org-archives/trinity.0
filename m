From: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH] overwritten assignment in sanitise_setsockopt
Date: Tue, 2 Apr 2013 13:40:03 +0200
Message-ID: <20130402134003.747af8ed@absol.kitzblitz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

I noticed an assignment that gets immediately overwritten, contradicting
a nearby comment.
According to the comment, 'optval' should get disabled half of the time.

As at the time of the conditional assignment optval was already set to
different nonzero values, it looks to me like the trailing assignment,
which was introduced in commit 737e1a71, may be unintended.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 syscalls/setsockopt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/syscalls/setsockopt.c b/syscalls/setsockopt.c
index 4d5877b..ce610af 100644
--- a/syscalls/setsockopt.c
+++ b/syscalls/setsockopt.c
@@ -322,8 +322,6 @@ void sanitise_setsockopt(int childno)
 	 */
 	if (rand() % 2)
 		shm->a4[childno] = 0;
-
-	shm->a4[childno] = sizeof(int);
 }
 
 struct syscall syscall_setsockopt = {
