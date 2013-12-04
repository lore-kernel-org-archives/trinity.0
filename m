From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] syscall/prctl.c: Fix unused variable build error with
 USE_SECCOMP=0.
Date: Wed, 4 Dec 2013 13:44:15 -0500
Message-ID: <20131204184415.GA6013@redhat.com>
References: <1386181980-3294-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1386181980-3294-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org, Vinson Lee <vlee@twitter.com>

On Wed, Dec 04, 2013 at 10:33:00AM -0800, Vinson Lee wrote:
 > From: Vinson Lee <vlee@twitter.com>
 >=20
 > This patch fixes this build error on CentOS 6.
 >=20
 >   CC	syscalls/prctl.o
 > cc1: warnings being treated as errors
 > syscalls/prctl.c: In function =E2=80=98sanitise_prctl=E2=80=99:
 > syscalls/prctl.c:36: error: unused variable =E2=80=98saddr=E2=80=99
 >=20
 > Signed-off-by: Vinson Lee <vlee@twitter.com>

bigger diff, but I think this looks cleaner..
Can you test ?


diff --git a/syscalls/prctl.c b/syscalls/prctl.c
index acca0279acab..09364df6a37a 100644
--- a/syscalls/prctl.c
+++ b/syscalls/prctl.c
@@ -17,6 +17,7 @@
 #include "maps.h"
 #include "shm.h"
 #include "compat.h"
+#include "trinity.h"
=20
 #define NR_PRCTL_OPTS 28
 static int prctl_opts[NR_PRCTL_OPTS] =3D {
@@ -29,31 +30,39 @@ static int prctl_opts[NR_PRCTL_OPTS] =3D {
 	PR_MCE_KILL, PR_MCE_KILL_GET,
 };
=20
+
+#ifdef USE_SECCOMP
+static void do_set_seccomp(int childno)
+{
+	struct sockaddr *saddr =3D NULL;
+
+//	if (rand() % 3 =3D=3D SECCOMP_MODE_FILTER) {
+
+// FIXME: This leaks memory, but needs to be cleared after the syscall=
 is done.
+		gen_seccomp_bpf((unsigned long **) &saddr, NULL);
+		shm->a2[childno] =3D SECCOMP_MODE_FILTER;
+		shm->a3[childno] =3D (unsigned long) saddr;
+//	}
+}
+#else
+static void do_set_seccomp(__unused__ int childno) { }
+#endif
+
 /* We already got a generic_sanitise at this point */
 void sanitise_prctl(int childno)
 {
 	int option =3D prctl_opts[rand() % NR_PRCTL_OPTS];
-	struct sockaddr *saddr =3D NULL;
=20
 // For now, just do SECCOMP, the other options need some attention.
-option =3D PR_SET_SECCOMP;
+	option =3D PR_SET_SECCOMP;
=20
-	/* Also allow crap by small chance */
-	if (rand() % 100 !=3D 0)
-		shm->a1[childno] =3D option;
+	shm->a1[childno] =3D option;
=20
 	switch (option) {
 	case PR_SET_SECCOMP:
-#ifdef USE_SECCOMP
-//		if (rand() % 3 =3D=3D SECCOMP_MODE_FILTER) {
-// FIXME: This leaks memory, but needs to be cleared
-// after the syscall is done.
-			gen_seccomp_bpf((unsigned long **) &saddr, NULL);
-			shm->a2[childno] =3D SECCOMP_MODE_FILTER;
-			shm->a3[childno] =3D (unsigned long) saddr;
-//		}
-#endif
+		do_set_seccomp(childno);
 		break;
+
 	default:
 		break;
 	}
