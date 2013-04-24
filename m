From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] print out the # of killed processes too
Date: Wed, 24 Apr 2013 22:43:44 +0200
Message-ID: <1366836224-572-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org
Cc: toralf.foerster@gmx.de

Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
---
 trinity.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/trinity.c b/trinity.c
index b95d287..a68dc18 100644
--- a/trinity.c
+++ b/trinity.c
@@ -235,8 +235,9 @@ int main(int argc, char* argv[])
=20
 	waitpid(shm->watchdog_pid, &childstatus, 0);
=20
-	printf("\nRan %ld syscalls. Successes: %ld  Failures: %ld\n",
-		shm->total_syscalls_done - 1, shm->successes, shm->failures);
+	printf("\nRan %ld syscalls. Successes: %ld  Failures: %ld  Killed: %l=
d\n",
+		shm->total_syscalls_done - 1, shm->successes, shm->failures,
+		shm->total_syscalls_done - 1 - shm->successes - shm->failures);
=20
 	ret =3D EXIT_SUCCESS;
=20
--=20
1.8.1.5
