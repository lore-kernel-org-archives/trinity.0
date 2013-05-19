From: Jann Horn <jann@thejh.net>
Subject: Re: trinity and ioctls
Date: Sun, 19 May 2013 20:36:18 +0200
Message-ID: <20130519183618.GA15261@debjann.fritz.box>
References: <20130519124725.GL592@debjann.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130519124725.GL592@debjann.fritz.box>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2013 at 02:47:25PM +0200, Jann Horn wrote:
> I am thinking about how hard it would be to automatically determine ioctls
> for arbitrary devices. I coded a little PoC:
>=20
> http://git.thejh.net/?p=3Dmoctel.git;a=3Dsummary
>=20
> Run "make", load the kernel module. Then determine the ioctl handler's na=
me
> for a given device or so like this:
>=20
> $ sudo ./show_ioctl /dev/xconsole
> pipe_ioctl
> $ sudo ./show_ioctl /dev/kvm
> kvm_dev_ioctl
> $ sudo ./show_ioctl /dev/fuse
>=20
> $ sudo ./show_ioctl /dev/btrfs-control=20
> btrfs_control_ioctl
> $ sudo ./show_ioctl /root
> ext4_ioctl
>=20
> So far, it is fairly straightforward. Knowing the handler method's name, =
you
> could then try to find the valid ioctls under the assumption that some ge=
neric
> patterns are followed:

I added some code. Listing the ioctl names for a given device:

$ ./get_ioctl_names.sh /home/jann/software/linux-3.6.7 method_list "$(sudo =
=2E/show_ioctl /dev/vhost-net)"
[...]
ioctls found: VHOST_NET_SET_BACKEND VHOST_GET_FEATURES VHOST_SET_FEATURES V=
HOST_RESET_OWNER

This requires you to have a file method_list containing all the methods in =
your
kernel source ordered by file. You can generate it like this:

$ ./gen_method_list /home/jann/software/linux-3.6.7 method_list

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRmRuiAAoJEGhmizV0f2d1/bUP/RXCQQ3WHgGrY26yvznkjAWh
X38ymOR5ziQXW3QkiDC1XfxULV4TkwK6w4/p8yKwcLHh3PLUqDOf0vs9kw7Jx1rw
UXa0unG53cSYXaJBitztSIdaSIdS+U4lwWSed+uA3xf/+ofjHKe7ih2GATSxZiWP
O422/iZj1axXn/nSkeYB+euNJqJRA+tHwg3BMTBQKnzJNDm7SkHlElaieECO/D89
0cmntcca+WujPWoOFX68p+DNoMAdAuq8nGgdMyZ8rTtZ6KrF6IE/uWrlpRL0VumC
/+XhfxaRLbFFvPZr5nTbdVROeC77FSwaNdNI73cGnK64RP4R5BGtVJLzsKkI5QQC
14JdENvWMRaCTgehDk7js5BPoggjd9SyrzvE+pSrhqGfFP4CWHqMmM84MSEolzZi
3uzeyTiXQ9L9PIjkCp9kLBmq5Q1WCbKdH4Jwgkp6UjfcEqr7Tdjc9K/+ZwHLcGZJ
8Jn1aGT+rWO5UJ2XZ2ySiIHIl2bFbo6ZNknq2zF+Hvdyp6E7F5wi5EwnehQODxNh
7tAGIkw0xkN/DDqigzCz1MRp8zIxPFXm1ebL09Lb4AfgrzILZp1s6cFsK4J8Lf3s
XfaBjTBpOJIPX7R2WLVkEKL68/kUiMWvW2Sh4+/cIStbnY4b2W1GIU8yo0FHPRXc
79CtSdgrHUTQAzYcsuht
=kihJ
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
