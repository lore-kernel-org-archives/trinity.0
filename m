From: Cui Bixuan <cuibixuan@huawei.com>
Subject: Re: Trinity 1.7
Date: Sat, 29 Oct 2016 09:31:01 +0800
Message-ID: <5813FBD5.3030707@huawei.com>
References: <20161028180147.a6ep57wobdtwxfky@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20161028180147.a6ep57wobdtwxfky@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: Dave Jones <davej@codemonkey.org.uk>, trinity@vger.kernel.org

On 2016/10/29 2:01, Dave Jones wrote:
> For those not following -git, I just made a tarball release at
> https://codemonkey.org.uk/projects/trinity/
>=20
> It's been a year since the last one, so a fair bit of work had
> accumulated, and I've spent the last few weeks polishing things up.
>=20
> Do let me know if anything unusual pops up.
Hi,
There are some errors when I checkout v1.7 to do './configure && make':
1.
ioctls/ext.c:10:2: error: unknown type name =91__u32=92
ioctls/ext.c:11:2: error: unknown type name =91__u64=92
ioctls/ext.c:12:2: error: unknown type name =91__u64=92
ioctls/ext.c:13:2: error: unknown type name =91__u64=92
ioctls/ext.c:14:2: error: unknown type name =91__u32=92
ioctls/ext.c:15:2: error: unknown type name =91__u16=92
ioctls/ext.c:16:2: error: unknown type name =91__u16=92
ioctls/ext.c:20:2: error: unknown type name =91__u32=92
ioctls/ext.c:21:2: error: unknown type name =91__u32=92
ioctls/ext.c:22:2: error: unknown type name =91__u64=92
ioctls/ext.c:23:2: error: unknown type name =91__u64=92
ioctls/ext.c:24:2: error: unknown type name =91__u64=92
ioctls/ext.c:25:2: error: unknown type name =91__u64=92
ioctls/ext.c:80:45: error: =91__u64=92 undeclared here (not in a function)
ioctls/ext.c:84:57: error: =91__u8=92 undeclared here (not in a function)

Then add '#include <linux/types.h>' into ioctls/ext.c will be ok :-) .


2. Then another error occurs to me:
net/proto-packet.c:38:39: warning: =91struct tpacket_req3=92 declared insid=
e parameter list [enabled by default]
net/proto-packet.c:38:39: warning: its scope is only this definition or dec=
laration, which is probably not what you want [enabled by default]
net/proto-packet.c: In function =91setup_tpacket_req3=92:
net/proto-packet.c:43:24: error: invalid application of =91sizeof=92 to inc=
omplete type =91struct tpacket_req3=92
net/proto-packet.c:44:5: error: dereferencing pointer to incomplete type
net/proto-packet.c:45:5: error: dereferencing pointer to incomplete type
net/proto-packet.c:46:5: error: dereferencing pointer to incomplete type
net/proto-packet.c:47:5: error: dereferencing pointer to incomplete type
net/proto-packet.c:48:5: error: dereferencing pointer to incomplete type
net/proto-packet.c:49:5: error: dereferencing pointer to incomplete type

And I can't find 'struct tpacket_req3' in my system
/usr/include/net/if_packet.h
/usr/include/linux/if_packet.h

But I find it in include/uapi/linux/if_packet.h of kernel 4.8 code.

I'm trying to solve this problem.

Thanks,
Cui Bixuan
>=20
> thanks,
>=20
> 	Dave
