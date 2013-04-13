From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: trinity-main is in an endless loop
Date: Sat, 13 Apr 2013 18:44:14 +0200
Message-ID: <51698B5E.5090501@gmx.de>
References: <51695CF2.2010108@gmx.de> <20130413145849.GA32144@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130413145849.GA32144@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>

On 04/13/2013 04:58 PM, Dave Jones wrote:
> On Sat, Apr 13, 2013 at 03:26:10PM +0200, Toralf F=C3=B6rster wrote:
>  > tl;dr;
>  >=20
>  >=20
>  > Running a recent trinity within a user mode linux guest (3.9-rc6-.=
=2E.) without parameter -N
>  > yields into an endless loop of the trinity-main process - it occup=
ies 100% CPU time
>  >=20
>  > The last lines of the command line
>  >=20
>  > trinity ~ #  ps axf | grep trinity
>  >   910 ?        SNs    0:01  |       \_ bash -c pkill -9 trinity; c=
d ~; T=3D/mnt/n22/v/victims; mkdir -p $T; for i in $(seq -w 1 100); do =
touch $T/f$i; mkdir $T/d$i; done; cd $T; trinity --children 4 --victims=
 $T -x mremap -r -q
>  >  1115 ?        SN     0:00  |           \_ trinity --children 4 --=
victims /mnt/n22/v/victims -x mremap -r -q
>  >  1116 ?        SN     0:00  |               \_ trinity --children =
4 --victims /mnt/n22/v/victims -x mremap -r -q
>  >  1117 ?        RN   257:20  |               \_ trinity --children =
4 --victims /mnt/n22/v/victims -x mremap -r -q
>  >  1359 ?        SNL    0:01  |                   \_ trinity --child=
ren 4 --victims /mnt/n22/v/victims -x mremap -r -q
>  >  1377 ?        SNL    0:00  |                   \_ trinity --child=
ren 4 --victims /mnt/n22/v/victims -x mremap -r -q
>  >  1392 ?        SNL    0:00  |                   \_ trinity --child=
ren 4 --victims /mnt/n22/v/victims -x mremap -r -q
>  >  1395 ?        SN     0:00  |                   \_ trinity --child=
ren 4 --victims /mnt/n22/v/victims -x mremap -r -q
>  >  1744 pts/0    S+     0:00          \_ grep --colour=3Dauto trinit=
y
>=20
> ok, all 4 children are stuck sleeping. it would be interesting to get=
 sysrq-T backtraces of those to see where
> they're sleeping.=20
>=20
> just to be sure, make sure they aren't sleeping/waking up very quickl=
y by doing a tail -f *.log
> If that's not making any progress, we're definitly hung.

The culprit of the hung are these directory permissions I fear :

# ls -l /mnt/n22/v/
total 0
d--------- 102 tfoerste users 4040 Apr 13 17:16 victims

and because I start trinity from within the directory "victims"
all processes just stuck b/c trinity locked out itself.

IMO trinity shouldn't change the directory permissions above its own lo=
g
files - and/or should not change the perms of the victims directory



--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
