From: Nico Golde <nico@ngolde.de>
Subject: Re: minor trinity patch
Date: Wed, 22 May 2013 16:14:59 +0200
Message-ID: <20130522141458.GA18931@ngolde.de>
References: <20121220165100.GA8748@ngolde.de> <20121220171726.GA7543@redhat.com> <20121220172246.GA16285@ngolde.de> <20121220172741.GA17760@redhat.com> <20121220200255.GB16285@ngolde.de> <20121220201903.GA14944@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121220201903.GA14944@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
I'm not sure if you would like to change this....
In devices.c you scan for the device name in /proc/devices using the %as=20
string.
On bionic this doesn't seem to work and therefore no devices are found and=
=20
because of this no ioctl group ever matches.

I changed the code the following way:
@@ -21,7 +22,8 @@ static size_t bldevs, chrdevs, miscdevs;
 static void parse_proc_devices(void)
 {
        FILE *fp;
-       char *name, *line =3D NULL;
+       char *line =3D NULL;
+       char name[32];
        size_t n =3D 0;
        int block, major;
        void *new;
@@ -33,30 +35,31 @@ static void parse_proc_devices(void)
        block =3D 0;

        while (getline(&line, &n, fp) >=3D 0) {
+               memset(name, 0, sizeof(name));
                if (strcmp("Block devices:\n", line) =3D=3D 0)
                        block =3D 1;
-               else if (sscanf(line, "%d %as", &major, &name) =3D=3D 2) {
+               else if (strcmp("Character devices:\n", line) =3D=3D 0)
+                       block =3D 0;
+               else if (sscanf(line, "%d %s", &major, &name) =3D=3D 2) {
                        if (block) {
                                new =3D realloc(block_devs, (bldevs+1)*size=
of(*block_devs));
                                if (!new) {
-                                       free(name);
                                        continue;
                                }
                                block_devs =3D new;
                                block_devs[bldevs].major =3D major;
                                block_devs[bldevs].minor =3D 0;
-                               block_devs[bldevs].name =3D name;
+                               block_devs[bldevs].name =3D strdup(name);
                                bldevs++;
                        } else {
                                new =3D realloc(char_devs, (chrdevs+1)*size=
of(*char_devs));
                                if (!new) {
-                                       free(name);
                                        continue;
                                }
                                char_devs =3D new;
                                char_devs[chrdevs].major =3D major;
                                char_devs[chrdevs].minor =3D 0;
-                               char_devs[chrdevs].name =3D name;
+                               char_devs[chrdevs].name =3D strdup(name);
                                chrdevs++;
                        }
                }


I also added the additional strcmp just to make sure that the code works al=
so
if the order of character devices/block devices in /proc/devices changes at
some point.

Cheers
Nico

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJRnNLiAAoJEM1LKvOgoKqquQAQAKxgso/n4wzp2ouz2C0aTbXI
Fh9jO8GUtQKpY+hdPaxEZMegC8oMWZwYa5TifB9f2rQ+BhzVK6TspLNA8uf9baGZ
S6M1ZcObTnfUC6XQ+hv1vWApBfb/O08w+pF9dauKOrEKb0Oc+uZKKwLeBAzhqQ1f
6WUmamPtzYKHn7cf6KSNc7Syn4gc1pSaKPDc1UL0Su4ZqjOaK1lCZCR6z4EHQh4Q
apXN8M8ahOeaGhZvluy8orXB3gfOZLwoEEiJIx6g1LjMEBO61yWExjamZEWTSbbG
JzReJG73Fkn5nRk46d/BtbWjZOH+j4HDPUY1HqfySeZ8tYoxNdKc/NKAwx6sxHJk
xHgAgGYhmFf1TpXS7ztoCb2S30zp7Bj0yubC85ZYhm+9jdLqU2dv8nyh8aO1m9GO
aizFlwdTVMhW7HHwakDU8zVEYVYOQVwHwggW9eQvl7pJUZ5wNSPWSmz+cbJbWW9p
tP/jVSyKly80b50FITRsaNfAw77QnHqADzzz71Cws55dDEehdla1Xpl9gmcmo6xj
f1A06bkAN2IxgbJQLjek7EfDPRZSKQmGCiINmcxbINdQxf9ElZcxSrrDfSXqeXff
FVa95V0Es/5hgcCJdR9+WJv82tVM/HkFSxAmsNrStKQxszPQ7LHNROnU3sz9b21N
8Ha0xkOp1x5mVyVXuH1/
=NF2p
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
