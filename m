From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] set syscalls_todo to N, not N+1
Date: Thu, 31 Oct 2013 20:30:30 +0100
Message-ID: <1383247830-19522-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org
Cc: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>

I really do not see any use case to increment users choice.

Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
---
 params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/params.c b/params.c
index fe70ff3..5db33bd 100644
--- a/params.c
+++ b/params.c
@@ -254,7 +254,7 @@ void parse_args(int argc, char *argv[])
=20
 		/* Set number of syscalls to do */
 		case 'N':
-			syscalls_todo =3D strtoll(optarg, NULL, 10) + 1;
+			syscalls_todo =3D strtoll(optarg, NULL, 10);
 			break;
=20
 		/* Pause after each syscall */
--=20
1.8.1.5
