From: Nico Golde <nico@ngolde.de>
Subject: Re: minor trinity patch
Date: Mon, 24 Jun 2013 18:03:57 +0200
Message-ID: <20130624160357.GK24423@ngolde.de>
References: <20121220171726.GA7543@redhat.com> <20121220172246.GA16285@ngolde.de> <20121220172741.GA17760@redhat.com> <20121220200255.GB16285@ngolde.de> <20121220201903.GA14944@redhat.com> <20130522141458.GA18931@ngolde.de> <CA+ydwtrggwedMpTeOfbSDAYDT7H=zZU7qAzSs6SzDW1Yx3Gi4g@mail.gmail.com> <20130523234712.GS14739@ngolde.de> <CA+ydwtqCfUJhq-g-wG442GAs3yyTTfi3xnUNwgDfnGiWqh5D3w@mail.gmail.com> <20130621132046.GS26707@ngolde.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130621132046.GS26707@ngolde.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: multipart/mixed; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
* Nico Golde <nico@ngolde.de> [2013-06-21 15:20]:
> Sorry I had no time to look into this for a while.
> Patch attached.

Attached is another patch on top of the previous one. I didn't see that the=
=20
device name includes the newline so that map_dev() will fail.
This was kind of hard to see unless you have a driver and you know how the=
=20
command ids should look like.

Thanks
Nico
--=20
Nico Golde - XMPP: nion@jabber.ccc.de - GPG: 0xA0A0AAAA

--IiVenqGWf+H9Y6IX
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-parse_proc_devices-cut-off-device-string-on-newline.patch"
Content-Transfer-Encoding: quoted-printable

=46rom f850d64ba34c0a0d203912740c00fff03e8f8f3e Mon Sep 17 00:00:00 2001
=46rom: Nico Golde <nion@debian.org>
Date: Mon, 24 Jun 2013 17:56:19 +0200
Subject: [PATCH] parse_proc_devices: cut off device string on newline

---
 devices.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/devices.c b/devices.c
index d3916f9..0166a53 100644
--- a/devices.c
+++ b/devices.c
@@ -38,6 +38,8 @@ static void parse_proc_devices(void)
 		else if (strcmp("Character devices:\n", line) =3D=3D 0)
 			block =3D 0;
 		else if (sscanf(line, "%d %*s", &major) =3D=3D 1) {
+			if ((p =3D strchr(line, '\n')) !=3D NULL)
+				*p =3D 0;
 			if ((p =3D strrchr(line, ' ')) =3D=3D NULL)
 				continue;
 			p++;
--=20
1.7.10.4


--IiVenqGWf+H9Y6IX--

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRyG3tAAoJEM1LKvOgoKqq3EgP/iCd02atldNtWTmVyTtHQ/gD
P88kLJQGb6z2JDc/PJrNtMl2PGNai27WiYde8Qs5CLFJF2Ocn0/XfD9rHmq48keF
1YLdk9KbpAIrwBtDmoDZIyU1cRvtKKdSG7eYYP+rz36antSnCom3VOiFn0Ff24Ee
TfVwGcJboMFIeXJiU8RDxKw7hNLURuZFOqO5lHW3WlS5qgNcQe/UAYrbsXAuMlRQ
9k5rWu/Amw1a48lJx07i51WDatd4xr+iNHKpHN4ejUF3BeojVoiqt7Vbv5XtSXwu
Uimtv6FkZEGorQMZ3CjO9GOqX/sU2W5YXLSujzs+gItY9XR1YFSqbdYkueNO48bZ
YklG6a9hBf6gUv4KA8UlmD2GwzgS7xsj/5C9bRLNmKBkl6dJOVmIyv2ZUjuS/DLe
xf6FE8DiKDeLa5w115wf/cfMhjZ20ziZm6VuqEHf45W4NZWzSW/XXOp9WcJTtVRd
75ZPYD5v+WHhSp/O/Hnv53OFG2d02jbteaDahSyjG+e3hOelJaFKbcoVEqdScW6C
HB466MF92svjfxTE8LPtbdwJ2eAYr9HQc6SCi4AC2tewwBM8sMa2tayxTIEeKmvD
i7rBHlcWNT1GAaDTxQiRj7SXkolZE2e2YGcv7gPWTcXW7GqNPlsSYBotESAX/TrY
44M8dJq5AO57y1oikgwy
=Tz9I
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
