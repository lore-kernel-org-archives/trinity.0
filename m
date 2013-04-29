From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: compile error in latest git tree
Date: Mon, 29 Apr 2013 22:25:39 +0200
Message-ID: <517ED743.2020900@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

At an 32 bit stable Gentoo w/ kernel 3.9 I get :

  CC    ioctls/vt.o
ioctls/kvm.c:114:2: error: =E2=80=98KVM_GET_REG_LIST=E2=80=99 undeclare=
d here (not in a
function)
  CC    ioctls/firewire.o
make: *** [ioctls/kvm.o] Error 1
make: *** Waiting for unfinished jobs....

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
