From: Jann Horn <jann@thejh.net>
Subject: trinity and ioctls
Date: Sun, 19 May 2013 14:47:25 +0200
Message-ID: <20130519124725.GL592@debjann.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org


--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
I had a relatively quick look at trinity. It seems to me that it currently
only has support for a few ioctls, right?

I am thinking about how hard it would be to automatically determine ioctls
for arbitrary devices. I coded a little PoC:

http://git.thejh.net/?p=3Dmoctel.git;a=3Dsummary

Run "make", load the kernel module. Then determine the ioctl handler's name
for a given device or so like this:

$ sudo ./show_ioctl /dev/xconsole
pipe_ioctl
$ sudo ./show_ioctl /dev/kvm
kvm_dev_ioctl
$ sudo ./show_ioctl /dev/fuse

$ sudo ./show_ioctl /dev/btrfs-control=20
btrfs_control_ioctl
$ sudo ./show_ioctl /root
ext4_ioctl

So far, it is fairly straightforward. Knowing the handler method's name, you
could then try to find the valid ioctls under the assumption that some gene=
ric
patterns are followed:

$ grep -R -n '^[^ ].*btrfs_control_ioctl' fs | grep '\.c:[0-9]*:\S'
fs/btrfs/super.c:1477:static long btrfs_control_ioctl(struct file *file, un=
signed int cmd,
$ tail -n +1477 fs/btrfs/super.c | grep -n '^}' | head -n 1
31:}
$ tail -n +1477 fs/btrfs/super.c | head -n 31 | grep 'case .*:' | sed 's|^.=
*case \(.*\):$|\1|g'
BTRFS_IOC_SCAN_DEV
BTRFS_IOC_DEVICES_READY
$ cat fs/btrfs/super.c > /tmp/a.c
$ echo 'int main(void){printf("%x %x\n", (unsigned)BTRFS_IOC_SCAN_DEV, (uns=
igned)BTRFS_IOC_DEVICES_READY);}' >> /tmp/a.c
$ gcc -nostdinc -I arch/x86/include -I arch/x86/include/asm -I arch/x86/inc=
lude/generated -I include -D __KERNEL__ -D CONFIG_X86_X32_ABI -D CONFIG_AS_=
CFI=3D1 -D CONFIG_AS_CFI_SIGNAL_FRAME=3D1 -D CONFIG_AS_CFI_SECTIONS=3D1 -D =
CONFIG_AS_FXSAVEQ=3D1 -D CONFIG_AS_AVX=3D1 -D CC_HAVE_ASM_GOTO -D 'KBUILD_S=
TR(s)=3D#s' -D KBUILD_BASENAME=3D'KBUILD_STR(calibrate)' -D KBUILD_MODNAME=
=3D'KBUILD_STR(calibrate)' -isystem /usr/lib/gcc/x86_64-linux-gnu/4.7/inclu=
de -include include/linux/kconfig.h -I fs/btrfs/ /tmp/a.c -o /tmp/a -Wl,--u=
nresolved-symbols=3Dignore-all
/tmp/a.c: In function =E2=80=98main=E2=80=99:
/tmp/a.c:1673:16: warning: incompatible implicit declaration of built-in fu=
nction =E2=80=98printf=E2=80=99 [enabled by default]
$ /tmp/a
50009404 90009427

Obviously, this won't always work because it heavily relies on assumptions =
and
conventions, but maybe it would be possible to automatically extract valid
ioctls from the kernel source this way at least in some cases?

What do you think, is this a good idea?

Jann

--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRmMndAAoJEGhmizV0f2d1GmYQAIre4c4o4AWJmCZ7/ldmRfiI
Z8oav6bTfvZ3Px70pQWdlCaIhU9gwsdHW/fKlymmiIP/gNzzqRH6hW1zJXFIpJGA
1jtzUx39l2goUqfdbFRMUYZEcTLb8b+T9DDmqb7MvoNHZpQCMxt/sFacnp2fKmm+
cJd8jV4MUuqJmJ3oKwkIns9RCnKiRGWlLa0u8kMgbV4/kCjrE+mfCpVyPTqglyNz
rYRgxp1amg0r7V0+L6/vxJYDwdWpVzfAhNcm6S7Fw4uaeOvZU6bNTT6uudvfU5xl
ntto/ihNFGzXTCfDlP0iG/Nns/rMwc5Ki2/B7m6KRrDlJXaK+X0DjgPqvcj+Wvqs
2GIG9wXH7Uh0DLO0NQ48VUVsLht92dlRHrWwnPOHqyfmbvT28C60PwpLpGl+KNIv
3q0+Bs6m9r8WiHbyhrPpsdre0YgvyBX2JDSgry+0jU071OVa7w/syqhnp1ixPVxR
UHBB3VeM4aPJVzB2MCoIzB+fOkvD+vfv3z3+/fawB0dg0uNTIIsrG1bjfjH1wcO7
XFC0/bSJ7+mrYxs2irOQ2zo1735XE8O6n+3MUQ3DMDIMhOgD+t5BC9HiPNovy3Rj
XY7WgVw8oVhZXPQ4vn3lQKHAZKfXVtgtFt6XxohVQZuKipQyRdpyXQgoXEYJXLtY
H9ogAEEfUnQKeVklAzjf
=AW+4
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--
