From: Nico Golde <nico@ngolde.de>
Subject: Re: minor trinity patch
Date: Fri, 21 Jun 2013 15:20:46 +0200
Message-ID: <20130621132046.GS26707@ngolde.de>
References: <20121220165100.GA8748@ngolde.de> <20121220171726.GA7543@redhat.com> <20121220172246.GA16285@ngolde.de> <20121220172741.GA17760@redhat.com> <20121220200255.GB16285@ngolde.de> <20121220201903.GA14944@redhat.com> <20130522141458.GA18931@ngolde.de> <CA+ydwtrggwedMpTeOfbSDAYDT7H=zZU7qAzSs6SzDW1Yx3Gi4g@mail.gmail.com> <20130523234712.GS14739@ngolde.de> <CA+ydwtqCfUJhq-g-wG442GAs3yyTTfi3xnUNwgDfnGiWqh5D3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+ydwtqCfUJhq-g-wG442GAs3yyTTfi3xnUNwgDfnGiWqh5D3w@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: multipart/mixed; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
* Tommi Rantala <tt.rantala@gmail.com> [2013-06-03 07:56]:
> 2013/5/24 Nico Golde <nico@ngolde.de>:
> > * Tommi Rantala <tt.rantala@gmail.com> [2013-05-23 20:58]:
> >> 2013/5/22 Nico Golde <nico@ngolde.de>:
> >> > I changed the code the following way:
> >> > @@ -21,7 +22,8 @@ static size_t bldevs, chrdevs, miscdevs;
> >> >  static void parse_proc_devices(void)
> >> >  {
> >> >         FILE *fp;
> >> > -       char *name, *line =3D NULL;
> >> > +       char *line =3D NULL;
> >> > +       char name[32];
> >>
> >> It would be IMO preferable to not hardcode the max length.
> >
> > I agree, this is actually left over from quickly changing this.
> > Are you aware of a proper maximum defined in the kernel headers or do w=
e want to
> > allocate this completely dynamically?
>=20
> dynamic please!

Sorry I had no time to look into this for a while.
Patch attached.

Cheers
Nico
--=20
Nico Golde - XMPP: nion@jabber.ccc.de - GPG: 0xA0A0AAAA

--PmA2V3Z32TCmWXqI
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-devices.c-dont-use-as-scanf-format-string-but-instea.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 9acc7c59c6ae2643ffba4edc17b04477f5cdaee0 Mon Sep 17 00:00:00 2001
=46rom: Nico Golde <nion@debian.org>
Date: Fri, 21 Jun 2013 15:18:58 +0200
Subject: [PATCH] devices.c: dont use %as scanf format string, but instead
 allocate and parse the device name manually for
 compatibility with non-glibc libcs

---
 devices.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/devices.c b/devices.c
index 43433bc..d3916f9 100644
--- a/devices.c
+++ b/devices.c
@@ -21,7 +21,7 @@ static size_t bldevs, chrdevs, miscdevs;
 static void parse_proc_devices(void)
 {
 	FILE *fp;
-	char *name, *line =3D NULL;
+	char *p, *name, *line =3D NULL;
 	size_t n =3D 0;
 	int block, major;
 	void *new;
@@ -35,7 +35,14 @@ static void parse_proc_devices(void)
 	while (getline(&line, &n, fp) >=3D 0) {
 		if (strcmp("Block devices:\n", line) =3D=3D 0)
 			block =3D 1;
-		else if (sscanf(line, "%d %as", &major, &name) =3D=3D 2) {
+		else if (strcmp("Character devices:\n", line) =3D=3D 0)
+			block =3D 0;
+		else if (sscanf(line, "%d %*s", &major) =3D=3D 1) {
+			if ((p =3D strrchr(line, ' ')) =3D=3D NULL)
+				continue;
+			p++;
+			name =3D strdup(p);
+
 			if (block) {
 				new =3D realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
 				if (!new) {
--=20
1.7.10.4


--PmA2V3Z32TCmWXqI--

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRxFMuAAoJEM1LKvOgoKqqH2YP/0jzC8KzNEzt78zTOKboVzfP
8Xi86jx80x+6+AeD7B7/9hhKEwxxIVZFBURw8rbj12m4QrBaDT9npHQfKrvmsHCj
/I6oiGr42zWhOlc5BZuM30ZdjvJv5nNKggPsJ+R4dQ6XPQ43YDGBXGShFBbfFctv
PlZQTLXll+W4IUI2bNhhyvKOzt1N17LegThqvDL/CWxR9o5h3WvK/LlYa5dlsyGU
RLw35JmPIuwR64KQhXju2EIBejw4mAizLUGxPp2+jKEehHAPenVIOE1ixSsf+yLZ
paPbnJVOjkWPChbG+GrXpbktUSrhQaG/t6ebbfFdA3b/FlHjEW5vGY7hZfva7myK
dS6jYN1OAYBsJs0LiFybVNAqLHVcRsR4JbszYifFQ14AAW8o+VqxbtBi5ZAhbqgO
pZBLqG/XEF2xcEdyS9fpowhubq/keCwgcqEZiqKY7muT1DInLUGroi6BJGP6i9x/
OJY2kEMJ7MNd7ktlcrrzCJD5kNTaIRQ3czTi33klsNoOx7irukix6e2L9/nvif+L
+VRXrtWUezoXjc8AP5VN7ya3njP62NHBZJh6iczLE2EBhmgbU82EF8W3sTBB70Kt
nEt8UP+3DZshhBw2TYFlAghfh9hzz0Hvb0UFxo9qfp2n1TbWsoFxxjmRs3nVYC+c
6PqVg1RB/4XbD5jjywRi
=RBeR
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
