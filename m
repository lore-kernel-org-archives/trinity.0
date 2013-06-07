From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: Trinity ctrl-c'ing itself?
Date: Fri, 7 Jun 2013 14:53:54 +1000
Message-ID: <20130607045354.GA3931@concordia>
References: <1370485831.7282.15.camel@concordia>
 <20130606181237.GA1884@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130606181237.GA1884@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Thu, Jun 06, 2013 at 02:12:37PM -0400, Dave Jones wrote:
> On Thu, Jun 06, 2013 at 12:30:31PM +1000, Michael Ellerman wrote:
>  > Hi folks,
>  >=20
>  > Has anyone else seen trinity appear to control-c itself?
>  >=20
>  > I've seen this a few times now, and I'm _really_ sure I didn't con=
trol-c
>  > this one manually. It was running overnight in a screen session.
>  >=20
>  > Tail of output is:
>  >=20
>  > [13645] [120] mbind(start=3D0, len=3D0, mode=3D0, nmask=3D0x1fffb9=
cf0010, maxnode=3D0x80000, flags=3D0x4000) [13655] [182] add_key(_type=3D=
0x7fffffff00001001, _description=3D0x7fffffff00001009, _payload=3D0x1ff=
ffe2d0000, plen=3D0, ringid=3D0x1000000000) =3D -1 (Bad address)
>  > =3D -1 (Invalid argument)
>  > [13655] [183] getrusage(who=3D0x8010658612110214, ru=3D0xc00000000=
0000000) [13645] [121] symlink(oldname=3D"/proc/87/task/87/wchan", newn=
=CC=B3=CC=A3=EF=BF=BD=EF=BF=BDo=EF=BF=BD=EF=BF=BDs=CC=A4=EF=BF=BD.=EF=BF=
=BD=EF=BF=BD=CC=AD=CC=A3=CC=B3=CC=BC=EF=BF=BD  =CC=A2=CC=BB=EF=BF=BD=EF=
=BF=BD=CC=AC=EF=BF=BD=CC=B0=CC=A6W=CC=AE=CC=B2=EF=BF=BD=CC=BC=CC=A9=EF=BF=
=BD=EF=BF=BDi=EF=BF=BD=EF=BF=BD=CD=A1
>  > t=EF=BF=BD=CC=AF=EF=BF=BDh=CC=B7=CC=AC=EF=BF=BD=EF=BF=BD=EF=BF=BD=CC=
=AC=C3=8C=EF=BF=BD=CC=BA=EF=BF=BD=EF=BF=BDe=EF=BF=BD=EF=BF=BD[13655] [1=
88] readahead(fd=3D414, offset=3D1, count=3D4096) =3D 196608
>  > =3D -1 (Bad file descriptor)645] [1i=EF=BF=BDn=EF=BF=BD=CC=A9=CC=B9=
=EF=BF=BD=EF=BF=BD=CC=B9g=EF=BF=BD =CC=A0=CC=A5=3D0x1ffffe310000) =3D 1=
3655
>  > child 13585 exiting=EF=BF=BD=CC=A0=CC=B2=CC=AB=EF=BF=BDfe=CC=A4=EF=
=BF=BD=EF=BF=BD=CC=B1e=EF=BF=BD=CC=AE=CC=A0=CC=B9=CC=AD=EF=BF=BD=EF=BF=BD=
l=EF=BF=BD=CC=B2=EF=BF=BD=EF=BF=BD=CC=A0=CC=AAi=CC=A2=EF=BF=BD=C3=8C=EF=
=BF=BD=EF=BF=BD=CC=AF=EF=BF=BD=CC=A9n=CC=B8=CC=B0g=EF=BF=BD=CC=B1=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=CC=AC=EF=BF=BD=CC=A6=EF=BF=BD=EF=BF=BDI=CC=A0chil=
d 13655 exiting=CC=B7=EF=BF=BD=3D413, mode=3D2047) =3D 0               =
                          =20
>  > =3D 0655] [186] setfsgid(gid=3D0=CC=A3=EF=BF=BD=E1=B8=A5i=CC=BC=CC=
=A6=EF=BF=BD=CC=BCv=EF=BF=BD=CC=A9=EF=BF=BD=EF=BF=BD=EF=BF=BD=CC=A9=EF=BF=
=BDn=CC=A2=EF=BF=BD=CC=AA=EF=BF=BD=EF=BF=BD=CC=B0=CC=A0=CC=A6t=CC=BA=EF=
=BF=BD=CC=B0i=EF=BF=BDn=EF=BF=BD=CC=AE=CC=A6=EF=BF=BD=EF=BF=BDg=CC=AE=EF=
=BF=BDd=CC=B4=CC=BAchild 13639 exiting=EF=BF=BD=CD=A2ep=EF=BF=BDr=EF=BF=
=BD=CC=AF=EF=BF=BD=EF=BF=BD=EF=BF=BD=C3=8C=EF=BF=BDe=CC=B4s=CC=A5e=CC=B5=
=EF=BF=BD=CC=B3=EF=BF=BD nr_segs=3D976, flags=3D6) =3D 2=CC=AA44
>  > child 13640 exitingnkat(oldname=3D"", newdfd=3D413, newname=3D"./p=
ro=EF=BF=BD=CC=B9=EF=BF=BD=CC=BCe=CC=A6=EF=BF=BD=CC=AA=EF=BF=BDlatency=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=E0=B9=B9=EF=BF=BD=E0=B9=B9child 13590 exiting =
=EF=BF=BDT=CC=AB=CC=BA=CC=B3o=CC=AC=EF=BF=BD =C3=AC=CC=AC=C3=8C=EF=BF=BD=
=EF=BF=BDnv=EF=BF=BD=EF=BF=BD=CC=BB=CC=A3=CC=B9=EF=BF=BDo=EF=BF=BD=EF=BF=
=BD=CC=A0=EF=BF=BD=CC=A4k
>  > child 13536 exiting
>  > child 13613 exiting
>  > [3791] Bailing main loop. Exit reason: ctrl-c
>=20
> I've seen it in the past, but not since last summer when I merged
> commit dbad5389a1d5d413e533a85f914f3eeef03a3ebe
>=20
> I wonder if there's some other way we're sending signals to child pid=
s that
> currently isn't marked AVOID.

Looks like it. I added some instrumentation to the kernel in the signal
sending path, here's a call trace of the process (trinity-child5) doing
the sending:

[c0000002ea663640] [c000000000099f5c] .do_send_sig_info+0x5c/0xa0
[c0000002ea6636f0] [c0000000001f578c] .send_sigio_to_task+0x1cc/0x370
[c0000002ea663830] [c0000000001f6498] .send_sigio+0xd8/0x230
[c0000002ea6638f0] [c0000000001f6730] .kill_fasync+0x140/0x380
[c0000002ea6639a0] [c0000000001eb44c] .pipe_write+0x3ec/0x610
[c0000002ea663ac0] [c0000000001df75c] .do_sync_readv_writev+0x9c/0x120
[c0000002ea663c20] [c0000000001e1320] .do_readv_writev+0xf0/0x320
[c0000002ea663d80] [c0000000001e1790] .SyS_writev+0x60/0xe0
[c0000002ea663e30] [c000000000009e60] syscall_exit+0x0/0x98


Looking at the code for send_sigio_to_task() at the very top it says:

	/*
	 * F_SETSIG can change ->signum lockless in parallel, make
	 * sure we read it once and use the same value throughout.
	 */
	int signum =3D ACCESS_ONCE(fown->signum);

So despite it being called send_sigio_to_task() it's really
send_fown_signum_to_task() and can potentially send any signal.

And I see that trinity does fuzz F_SETSIG, and it looks like it's just =
passing
a rand32() as the signal number argument. So that looks like it to me.

I'll try sanitising the arg to F_SETSIG to avoid SIGINT and run for a w=
hile.

cheers
