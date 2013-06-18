From: Sravan V Dodla <sravan@linux.vnet.ibm.com>
Subject: Complie issues with trinity-2013-06-17 on s390
Date: Tue, 18 Jun 2013 12:37:26 +0530
Message-ID: <1371539246.4585.698.camel@oc6144502753.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

Hello,

I was trying to compile trinity-2013-06-17 build on s390x with kernel
3.9.4 and have hit the following issue:

  CC	syscalls/fcntl.o
syscalls/fcntl.c: In function =E2=80=98sanitise_fcntl=E2=80=99:
syscalls/fcntl.c:70:2: error: duplicate case value
  case F_GETLK64:
  ^
syscalls/fcntl.c:65:2: error: previously used here
  case F_GETLK:
  ^
syscalls/fcntl.c:72:2: error: duplicate case value
  case F_SETLK64:
  ^
syscalls/fcntl.c:66:2: error: previously used here
  case F_SETLK:
  ^
syscalls/fcntl.c:74:2: error: duplicate case value
  case F_SETLKW64:
  ^
syscalls/fcntl.c:67:2: error: previously used here
  case F_SETLKW:
  ^
make: *** [syscalls/fcntl.o] Error 1

Was this a known issue and I was not able to find anything related to
this in archived mails.

Thanks!
-Sravan.
