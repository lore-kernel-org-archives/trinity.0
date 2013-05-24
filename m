From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] Fix build on kernels without perf_event_attr exclude_callchain_kernel.
Date: Thu, 23 May 2013 21:08:47 -0700
Message-ID: <1369368527-21362-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Vinson Lee <vlee@twitter.com>

=46rom: Vinson Lee <vlee@twitter.com>

This patch fixes these build errors on 3.6 and older.

  CC	syscalls/perf_event_open.o
syscalls/perf_event_open.c: In function =E2=80=98create_mostly_valid_co=
unting_event=E2=80=99:
syscalls/perf_event_open.c:382:6: error: =E2=80=98struct perf_event_att=
r=E2=80=99 has no member named =E2=80=98exclude_callchain_kernel=E2=80=99
syscalls/perf_event_open.c:383:6: error: =E2=80=98struct perf_event_att=
r=E2=80=99 has no member named =E2=80=98exclude_callchain_user=E2=80=99
syscalls/perf_event_open.c: In function =E2=80=98create_mostly_valid_sa=
mpling_event=E2=80=99:
syscalls/perf_event_open.c:431:6: error: =E2=80=98struct perf_event_att=
r=E2=80=99 has no member named =E2=80=98exclude_callchain_kernel=E2=80=99
syscalls/perf_event_open.c:432:6: error: =E2=80=98struct perf_event_att=
r=E2=80=99 has no member named =E2=80=98exclude_callchain_user=E2=80=99
make: *** [syscalls/perf_event_open.o] Error 1

Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 configure.sh               |   26 ++++++++++++++++++++++++++
 syscalls/perf_event_open.c |    4 ++++
 2 files changed, 30 insertions(+)

diff --git a/configure.sh b/configure.sh
index e676418..4be1e59 100755
--- a/configure.sh
+++ b/configure.sh
@@ -182,6 +182,32 @@ else
 fi
=20
 ######################################################################=
#######################
+# Does perf_event_attr have exclude_callchain_kernel?
+
+echo -n "[*] Checking if perf_event_attr can use exclude_callchain_ker=
nel.. "
+rm -f "$TMP" || exit 1
+
+cat >"$TMP.c" << EOF
+#include <stdio.h>
+#include <linux/perf_event.h>
+
+int main() {
+	struct perf_event_attr attr;
+	printf("%d\n", attr.exclude_callchain_kernel);
+}
+EOF
+
+${CC} "$TMP.c" -o "$TMP" &>"$TMP.log"
+
+if [ ! -x "$TMP" ]; then
+	echo $RED "[NO]" $COL_RESET
+	MISSING_DEFS=3D1
+else
+	echo $GREEN "[YES]" $COL_RESET
+	echo "#define USE_PERF_EVENT_EXCLUDE_CALLCHAINS" >> config.h
+fi
+
+######################################################################=
#######################
=20
 check_header linux/caif/caif_socket.h USE_CAIF
 check_header linux/if_alg.h USE_IF_ALG
diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 627ba48..bffd33d 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -379,8 +379,10 @@ static void create_mostly_valid_counting_event(str=
uct perf_event_attr *attr)
 	attr->sample_id_all =3D rand_bool();
 	attr->exclude_host =3D rand_bool();
 	attr->exclude_guest =3D rand_bool();
+#ifdef USE_PERF_EVENT_EXCLUDE_CALLCHAINS
 	attr->exclude_callchain_kernel =3D rand_bool();
 	attr->exclude_callchain_user =3D rand_bool();
+#endif
=20
 	attr->wakeup_events =3D rand();	// also wakeup_watermark
=20
@@ -428,8 +430,10 @@ static void create_mostly_valid_sampling_event(str=
uct perf_event_attr *attr)
 	attr->sample_id_all =3D rand_bool();
 	attr->exclude_host =3D rand_bool();
 	attr->exclude_guest =3D rand_bool();
+#ifdef USE_PERF_EVENT_EXCLUDE_CALLCHAINS
 	attr->exclude_callchain_kernel =3D rand_bool();
 	attr->exclude_callchain_user =3D rand_bool();
+#endif
=20
 	attr->wakeup_events =3D rand();	// also wakeup_watermark
=20
--=20
1.7.9.5
