From: Dave Jones <davej@redhat.com>
Subject: Re: trinity 1.1-677-g7bbde28 just hangs after creating fd and
 sockets in a user mode linux
Date: Fri, 30 Aug 2013 11:57:59 -0400
Message-ID: <20130830155759.GA24496@redhat.com>
References: <5220C024.3070503@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5220C024.3070503@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Aug 30, 2013 at 05:54:12PM +0200, Toralf F=F6rster wrote:
 > the last lines are :
 >=20
 > fd[376] =3D domain:1 (PF_LOCAL) type:0x5 protocol:1
 > fd[377] =3D domain:2 (PF_INET) type:0x2 protocol:17
 > fd[378] =3D domain:10 (PF_INET6) type:0x1 protocol:0
 > fd[379] =3D domain:1 (PF_LOCAL) type:0x1 protocol:1
 > fd[380] =3D domain:2 (PF_INET) type:0x1 protocol:0
 > created 375 sockets
 > fd[380] =3D domain:2 (PF_INET) type:0x1 protocol:0
 > created 375 sockets
 > fd[5] =3D pipe
 > fd[381] =3D pipe
 > fd[382] =3D pipe
 > fd[383] =3D pipe
 >=20
 > thats' all,  a
 > $> ps axf | grep trinity | grep -v grep
 >=20
 > just gives
 >=20
 > $ ssh tfoerste@trinity "ps axf | grep trinity | grep -v grep"
 >  1072 ?        Ss     0:00  |       \_ bash -c cd ~; sudo su -c 'if =
[[ -d ./t3 ]]; then chmod -R a+rwx ./t3; rm -rf ./t3; fi'; mkdir ./t3; =
cd ./t3; logger M=3D; if [[ -n "" ]]; then if [[ -d /victims/v1 ]]; the=
n sudo chmod -R a+rwx /victims/v1; sudo rm -rf /victims/v1; fi; mkdir -=
p /victims/v1/v2; for i in $(seq -w 1 100); do touch /victims/v1/v2/f$i=
 2>/dev/null; mkdir /victims/v1/v2/d$i 2>/dev/null; done; fi;  trinity =
-C 1 -N 10000
 >  1080 ?        S      0:00  |           \_ trinity -C 1 -N 10000
 >  1081 ?        S      0:00  |               \_ trinity -C 1 -N 10000
 >  1082 ?        R      2:37  |               \_ trinity -C 1 -N 10000
 >=20
 > $ ssh tfoerste@trinity "ls -l ~/t3/*log"
 > -rw-r--r-- 1 tfoerste users     0 Aug 30 17:49 /home/tfoerste/t3/tri=
nity-child0.log
 > -rw-r--r-- 1 tfoerste users 19610 Aug 30 17:49 /home/tfoerste/t3/tri=
nity.log
 >=20
 >=20
 > Because I updated both trinity and the UML kernel I'm unsure were to=
 start

ah, I think I know what's up here. It's hanging just before it tries to=
 create
some 'perf' fds. I bet that either you have that config'd off in your u=
ml kernel,
or uml doesn't support perf.

I'll add some error handling later today.

	Dave
=20
