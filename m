From: Dave Jones <davej@redhat.com>
Subject: Re: Trinity ctrl-c'ing itself?
Date: Thu, 6 Jun 2013 14:12:37 -0400
Message-ID: <20130606181237.GA1884@redhat.com>
References: <1370485831.7282.15.camel@concordia>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370485831.7282.15.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michael Ellerman <michael@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Thu, Jun 06, 2013 at 12:30:31PM +1000, Michael Ellerman wrote:
 > Hi folks,
 >=20
 > Has anyone else seen trinity appear to control-c itself?
 >=20
 > I've seen this a few times now, and I'm _really_ sure I didn't contr=
ol-c
 > this one manually. It was running overnight in a screen session.
 >=20
 > Tail of output is:
 >=20
 > [13645] [120] mbind(start=3D0, len=3D0, mode=3D0, nmask=3D0x1fffb9cf=
0010, maxnode=3D0x80000, flags=3D0x4000) [13655] [182] add_key(_type=3D=
0x7fffffff00001001, _description=3D0x7fffffff00001009, _payload=3D0x1ff=
ffe2d0000, plen=3D0, ringid=3D0x1000000000) =3D -1 (Bad address)
 > =3D -1 (Invalid argument)
 > [13655] [183] getrusage(who=3D0x8010658612110214, ru=3D0xc0000000000=
00000) [13645] [121] symlink(oldname=3D"/proc/87/task/87/wchan", newn=CC=
=B3=CC=A3=EF=BF=BD=EF=BF=BDo=EF=BF=BD=EF=BF=BDs=CC=A4=EF=BF=BD.=EF=BF=BD=
=EF=BF=BD=CC=AD=CC=A3=CC=B3=CC=BC=EF=BF=BD  =CC=A2=CC=BB=EF=BF=BD=EF=BF=
=BD=CC=AC=EF=BF=BD=CC=B0=CC=A6W=CC=AE=CC=B2=EF=BF=BD=CC=BC=CC=A9=EF=BF=BD=
=EF=BF=BDi=EF=BF=BD=EF=BF=BD=CD=A1
 > t=EF=BF=BD=CC=AF=EF=BF=BDh=CC=B7=CC=AC=EF=BF=BD=EF=BF=BD=EF=BF=BD=CC=
=AC=C3=8C=EF=BF=BD=CC=BA=EF=BF=BD=EF=BF=BDe=EF=BF=BD=EF=BF=BD[13655] [1=
88] readahead(fd=3D414, offset=3D1, count=3D4096) =3D 196608
 > =3D -1 (Bad file descriptor)645] [1i=EF=BF=BDn=EF=BF=BD=CC=A9=CC=B9=EF=
=BF=BD=EF=BF=BD=CC=B9g=EF=BF=BD =CC=A0=CC=A5=3D0x1ffffe310000) =3D 1365=
5
 > child 13585 exiting=EF=BF=BD=CC=A0=CC=B2=CC=AB=EF=BF=BDfe=CC=A4=EF=BF=
=BD=EF=BF=BD=CC=B1e=EF=BF=BD=CC=AE=CC=A0=CC=B9=CC=AD=EF=BF=BD=EF=BF=BDl=
=EF=BF=BD=CC=B2=EF=BF=BD=EF=BF=BD=CC=A0=CC=AAi=CC=A2=EF=BF=BD=C3=8C=EF=BF=
=BD=EF=BF=BD=CC=AF=EF=BF=BD=CC=A9n=CC=B8=CC=B0g=EF=BF=BD=CC=B1=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=CC=AC=EF=BF=BD=CC=A6=EF=BF=BD=EF=BF=BDI=CC=A0child 1=
3655 exiting=CC=B7=EF=BF=BD=3D413, mode=3D2047) =3D 0                  =
                       =20
 > =3D 0655] [186] setfsgid(gid=3D0=CC=A3=EF=BF=BD=E1=B8=A5i=CC=BC=CC=A6=
=EF=BF=BD=CC=BCv=EF=BF=BD=CC=A9=EF=BF=BD=EF=BF=BD=EF=BF=BD=CC=A9=EF=BF=BD=
n=CC=A2=EF=BF=BD=CC=AA=EF=BF=BD=EF=BF=BD=CC=B0=CC=A0=CC=A6t=CC=BA=EF=BF=
=BD=CC=B0i=EF=BF=BDn=EF=BF=BD=CC=AE=CC=A6=EF=BF=BD=EF=BF=BDg=CC=AE=EF=BF=
=BDd=CC=B4=CC=BAchild 13639 exiting=EF=BF=BD=CD=A2ep=EF=BF=BDr=EF=BF=BD=
=CC=AF=EF=BF=BD=EF=BF=BD=EF=BF=BD=C3=8C=EF=BF=BDe=CC=B4s=CC=A5e=CC=B5=EF=
=BF=BD=CC=B3=EF=BF=BD nr_segs=3D976, flags=3D6) =3D 2=CC=AA44
 > child 13640 exitingnkat(oldname=3D"", newdfd=3D413, newname=3D"./pro=
=EF=BF=BD=CC=B9=EF=BF=BD=CC=BCe=CC=A6=EF=BF=BD=CC=AA=EF=BF=BDlatency=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=E0=B9=B9=EF=BF=BD=E0=B9=B9child 13590 exiting =
=EF=BF=BDT=CC=AB=CC=BA=CC=B3o=CC=AC=EF=BF=BD =C3=AC=CC=AC=C3=8C=EF=BF=BD=
=EF=BF=BDnv=EF=BF=BD=EF=BF=BD=CC=BB=CC=A3=CC=B9=EF=BF=BDo=EF=BF=BD=EF=BF=
=BD=CC=A0=EF=BF=BD=CC=A4k
 > child 13536 exiting
 > child 13613 exiting
 > [3791] Bailing main loop. Exit reason: ctrl-c

I've seen it in the past, but not since last summer when I merged
commit dbad5389a1d5d413e533a85f914f3eeef03a3ebe

I wonder if there's some other way we're sending signals to child pids =
that
currently isn't marked AVOID.

	Dave
