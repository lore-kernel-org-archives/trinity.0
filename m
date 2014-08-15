From: Brian Haley <brian.haley@hp.com>
Subject: [PATCH] Fix two shadow compiler warnings
Date: Fri, 15 Aug 2014 17:02:39 -0400
Message-ID: <1408136559-13716-1-git-send-email-brian.haley@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

  CC	fd-files.o
fd-files.c: In function =E2=80=98list_to_index=E2=80=99:
fd-files.c:216:15: warning: declaration of =E2=80=98index=E2=80=99 shad=
ows a global declaration [-Wshadow]
  CC	fds.o
fds.c: In function =E2=80=98process_disable_fds_param=E2=80=99:
fds.c:164:38: warning: declaration of =E2=80=98optarg=E2=80=99 shadows =
a global declaration [-Wshadow]

Signed-off-by: Brian Haley <brian.haley@hp.com>
---
 fd-files.c |    8 ++++----
 fds.c      |   14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fd-files.c b/fd-files.c
index 6e0e37d..59dce01 100644
--- a/fd-files.c
+++ b/fd-files.c
@@ -213,14 +213,14 @@ static const char ** list_to_index(struct namelis=
t *namelist)
 {
 	struct list_head *node, *tmp;
 	struct namelist *nl;
-	const char **index;
+	const char **findex;
 	unsigned int i =3D 0;
=20
-	index =3D zmalloc(sizeof(char *) * files_in_index);
+	findex =3D zmalloc(sizeof(char *) * files_in_index);
=20
 	list_for_each_safe(node, tmp, &namelist->list) {
 		nl =3D (struct namelist *) node;
-		index[i++] =3D nl->name;
+		findex[i++] =3D nl->name;
=20
 		/* Destroy the list head, but keep the ->name alloc because
 		 * now the index points to it.
@@ -232,7 +232,7 @@ static const char ** list_to_index(struct namelist =
*namelist)
 	free(names);
 	names =3D NULL;
=20
-	return index;
+	return findex;
 }
=20
 static void generate_filelist(void)
diff --git a/fds.c b/fds.c
index ad963f9..79febcd 100644
--- a/fds.c
+++ b/fds.c
@@ -161,23 +161,23 @@ static void disable_fds_param(char *str)
 	exit(EXIT_FAILURE);
 }
=20
-void process_disable_fds_param(char *optarg)
+void process_disable_fds_param(char *param)
 {
 	unsigned int len, i;
-	char *str =3D optarg;
+	char *str =3D param;
=20
-	len =3D strlen(optarg);
+	len =3D strlen(param);
=20
 	/* Check if there are any commas. If so, split them into multiple par=
ams,
 	 * validating them as we go.
 	 */
 	for (i =3D 0; i < len; i++) {
-		if (optarg[i] =3D=3D ',') {
-			optarg[i] =3D 0;
+		if (param[i] =3D=3D ',') {
+			param[i] =3D 0;
 			disable_fds_param(str);
-			str =3D optarg + i + 1;
+			str =3D param + i + 1;
 		}
 	}
-	if (str < optarg + len)
+	if (str < param + len)
 		disable_fds_param(str);
 }
--=20
1.7.9.5
