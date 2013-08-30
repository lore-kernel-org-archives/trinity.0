From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: trinity 1.1-677-g7bbde28 just hangs after creating fd and sockets
 in a user mode linux
Date: Fri, 30 Aug 2013 17:54:12 +0200
Message-ID: <5220C024.3070503@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

the last lines are :

fd[376] =3D domain:1 (PF_LOCAL) type:0x5 protocol:1
fd[377] =3D domain:2 (PF_INET) type:0x2 protocol:17
fd[378] =3D domain:10 (PF_INET6) type:0x1 protocol:0
fd[379] =3D domain:1 (PF_LOCAL) type:0x1 protocol:1
fd[380] =3D domain:2 (PF_INET) type:0x1 protocol:0
created 375 sockets
fd[380] =3D domain:2 (PF_INET) type:0x1 protocol:0
created 375 sockets
fd[5] =3D pipe
fd[381] =3D pipe
fd[382] =3D pipe
fd[383] =3D pipe

thats' all,  a
$> ps axf | grep trinity | grep -v grep

just gives

$ ssh tfoerste@trinity "ps axf | grep trinity | grep -v grep"
 1072 ?        Ss     0:00  |       \_ bash -c cd ~; sudo su -c 'if [[ =
-d ./t3 ]]; then chmod -R a+rwx ./t3; rm -rf ./t3; fi'; mkdir ./t3; cd =
=2E/t3; logger M=3D; if [[ -n "" ]]; then if [[ -d /victims/v1 ]]; then=
 sudo chmod -R a+rwx /victims/v1; sudo rm -rf /victims/v1; fi; mkdir -p=
 /victims/v1/v2; for i in $(seq -w 1 100); do touch /victims/v1/v2/f$i =
2>/dev/null; mkdir /victims/v1/v2/d$i 2>/dev/null; done; fi;  trinity -=
C 1 -N 10000
 1080 ?        S      0:00  |           \_ trinity -C 1 -N 10000
 1081 ?        S      0:00  |               \_ trinity -C 1 -N 10000
 1082 ?        R      2:37  |               \_ trinity -C 1 -N 10000

$ ssh tfoerste@trinity "ls -l ~/t3/*log"
-rw-r--r-- 1 tfoerste users     0 Aug 30 17:49 /home/tfoerste/t3/trinit=
y-child0.log
-rw-r--r-- 1 tfoerste users 19610 Aug 30 17:49 /home/tfoerste/t3/trinit=
y.log


Because I updated both trinity and the UML kernel I'm unsure were to st=
art
--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
