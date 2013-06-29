From: Jann Horn <jann@thejh.net>
Subject: Re: wtf bug of the day.
Date: Sat, 29 Jun 2013 08:31:29 +0200
Message-ID: <20130629063129.GD13813@debjann.fritz.box>
References: <20130629022420.GA20808@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="veXX9dWIonWZEC6h"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130629022420.GA20808@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--veXX9dWIonWZEC6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 10:24:20PM -0400, Dave Jones wrote:
> I've beem holding off on cutting a new release of trinity until I've nail=
ed
> this one last bug[1].
>=20
> When it happens, the watchdog process is in Z state, and the child proces=
ses
> are all blocked on sockets (and no progress is made because the watchdog =
died).
>=20
> In the one case I've managed to catch a core from the watchdog, it makes =
no damn sense..
>=20
> Program terminated with signal 8, Arithmetic exception.
> #0  check_shm_sanity () at watchdog.c:47
> 	if (shm->running_childs =3D=3D 0)
>=20
> what the hell does that even mean ?
>=20
> 'shm' is valid, shm->running_childs is '4'.
>=20
> Any ideas ?

Could you post the disassembly of that functioni (including start address)?=
 Also, in case
you still have the coredump, could you post the exact address at which the =
error occured?

That signal is usually only triggered by errors with floating-point errors,=
 but maybe
trinity somehow ended up doing a kill(watchdog, 8) acidentially? I'm not ve=
ry familia with
trinity, so I don't know whether that's possible.

--veXX9dWIonWZEC6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzn9AAAoJEGhmizV0f2d1p9EP/RS7A59DGkCFT/A9R3ixCVBw
/WSksA6JWsbLkycYvclu8jqNZYHGPnibNufQlNjf43mawskKHZdWQVkpuyO+Y/H/
IGV/oHjNTAOtRMAxEYTnF1S5QHEI5T37JJeJpgnrHhHOap2GvXEN5kOgCjtaOmIP
ElY81CJLSRhif3pgEEk5CAgyqlVVUOPmSzyk5lfO1o/iJzuXww4MljEcsdl7PzXr
/W4JEXq3vZNdkuOWTrIZmkRCAKf9VmJ93FkXNvDCHPfRekEdpY+ajUhkmZKuLHXZ
7O3RNcO07dS0jhisRNKYeVE275a7Jb+NgoLmYGLezaPQEACje9wLkOpvoqugjmtY
ZJ+erhtbOB4UtJyiGvoHuMqpkyktJW6MqcUXMZsZ+y3AyWPNFe5zq6BIp74fy9zP
G3JdGITucsVfbNTXCWF6SdUcMnnV8DCsPNqg/beEi7HF6GREJVqDQorVD5TDt0ne
gubmbkkpVMs0WCYVpoYIm++GM4Lt+GJgrlNNtpEazW0H+DlRjkAMkHAfn51tM81b
AoUZD1w6iyoSOeZBHUHY0sKr5sYQ9nl+2GKTIeDlsTGfHfXCxZeTdQbi/eOvmAum
QhjpK8HO0ad8/KfSwS1utE+k1Lv7OdKduetndInuvPhy6To2t8GgR1cKysegfBwb
KIBR6TqNM6zqmqcTMmGK
=2PPZ
-----END PGP SIGNATURE-----

--veXX9dWIonWZEC6h--
