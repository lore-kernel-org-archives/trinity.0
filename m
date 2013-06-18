From: Dave Jones <davej@redhat.com>
Subject: Re: Complie issues with trinity-2013-06-17 on s390
Date: Tue, 18 Jun 2013 11:39:13 -0400
Message-ID: <20130618153913.GA20496@redhat.com>
References: <1371539246.4585.698.camel@oc6144502753.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371539246.4585.698.camel@oc6144502753.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Sravan V Dodla <sravan@linux.vnet.ibm.com>
Cc: trinity@vger.kernel.org

On Tue, Jun 18, 2013 at 12:37:26PM +0530, Sravan V Dodla wrote:
 > Hello,
 >=20
 > I was trying to compile trinity-2013-06-17 build on s390x with kerne=
l
 > 3.9.4 and have hit the following issue:
 >=20
 >   CC	syscalls/fcntl.o
 > syscalls/fcntl.c: In function =E2=80=98sanitise_fcntl=E2=80=99:
 > syscalls/fcntl.c:70:2: error: duplicate case value
 >   case F_GETLK64:
 >   ^
 > syscalls/fcntl.c:65:2: error: previously used here
 >   case F_GETLK:
 >   ^
 > syscalls/fcntl.c:72:2: error: duplicate case value
 >   case F_SETLK64:
 >   ^
 > syscalls/fcntl.c:66:2: error: previously used here
 >   case F_SETLK:
 >   ^
 > syscalls/fcntl.c:74:2: error: duplicate case value
 >   case F_SETLKW64:
 >   ^
 > syscalls/fcntl.c:67:2: error: previously used here
 >   case F_SETLKW:
 >   ^
 > make: *** [syscalls/fcntl.o] Error 1
 >=20
 > Was this a known issue and I was not able to find anything related t=
o
 > this in archived mails.

Does this help ?

diff --git a/syscalls/fcntl.c b/syscalls/fcntl.c
index 6eb2344..5d651af 100644
--- a/syscalls/fcntl.c
+++ b/syscalls/fcntl.c
@@ -23,6 +23,10 @@
 #include "shm.h"
 #include "compat.h"
=20
+#if F_GETLK64 !=3D F_GETLK
+#define HAVE_LK64
+#endif
+
 void sanitise_fcntl(int childno)
 {
 	switch (shm->a2[childno]) {
@@ -66,7 +70,7 @@ void sanitise_fcntl(int childno)
 	case F_SETLK:
 	case F_SETLKW:
 		break;
-#ifndef __x86_64__
+#ifdef HAVE_LK64
 	case F_GETLK64:
 		break;
 	case F_SETLK64:
@@ -122,7 +126,7 @@ struct syscall syscall_fcntl =3D {
 	.arg2name =3D "cmd",
 	.arg2type =3D ARG_OP,
 	.arg2list =3D {
-#ifdef __x86_64__
+#ifndef HAVE_LK64
 		.num =3D 20,
 #else
 		.num =3D 23,
@@ -130,7 +134,7 @@ struct syscall syscall_fcntl =3D {
 		.values =3D { F_DUPFD, F_DUPFD_CLOEXEC, F_GETFD, F_SETFD, F_GETFL, F=
_SETFL, F_GETLK, F_SETLK,
 		  F_SETLKW, F_GETOWN, F_SETOWN, F_GETOWN_EX, F_SETOWN_EX, F_GETSIG, =
=46_SETSIG, F_GETLEASE,
 		  F_SETLEASE, F_NOTIFY, F_SETPIPE_SZ, F_GETPIPE_SZ,
-#ifndef __x86_64__
+#ifdef HAVE_LK64
 		  F_GETLK64, F_SETLK64, F_SETLKW64,
 #endif
 		},
