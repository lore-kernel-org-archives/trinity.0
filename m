From: Sravan V Dodla <sravan@linux.vnet.ibm.com>
Subject: Re: Complie issues with trinity-2013-06-17 on s390
Date: Wed, 19 Jun 2013 11:10:59 +0530
Message-ID: <1371620459.4704.4.camel@oc6144502753.ibm.com>
References: <1371539246.4585.698.camel@oc6144502753.ibm.com>
	 <20130618153913.GA20496@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130618153913.GA20496@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Tue, 2013-06-18 at 11:39 -0400, Dave Jones wrote:
> On Tue, Jun 18, 2013 at 12:37:26PM +0530, Sravan V Dodla wrote:

> Does this help ?
Thanks a lot Dave. That did help :)
Still compilation does not complete successfully. I'm seeing the
following issue on both ppc64 and s390x archs:


 CC	ioctls/hpet.o
  CC	ioctls/kvm.o
In file included from ioctls/kvm.c:8:0:
ioctls/kvm.c:15:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_memory_alias=E2=80=99
  IOCTL(KVM_SET_MEMORY_ALIAS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:29:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_pit_state=E2=80=99
  IOCTL(KVM_GET_PIT),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:30:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_pit_state=E2=80=99
  IOCTL(KVM_SET_PIT),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:35:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_irq_routing=E2=80=99
  IOCTL(KVM_SET_GSI_ROUTING),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:47:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_xen_hvm_config=E2=80=99
  IOCTL(KVM_XEN_HVM_CONFIG),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:50:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_pit_state2=E2=80=99
  IOCTL(KVM_GET_PIT2),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:51:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_pit_state2=E2=80=99
  IOCTL(KVM_SET_PIT2),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:76:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_msrs=E2=80=99
  IOCTL(KVM_GET_MSRS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:77:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_msrs=E2=80=99
  IOCTL(KVM_SET_MSRS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:78:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_cpuid=E2=80=99
  IOCTL(KVM_SET_CPUID),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:82:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_lapic_state=E2=80=99
  IOCTL(KVM_GET_LAPIC),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:83:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_lapic_state=E2=80=99
  IOCTL(KVM_SET_LAPIC),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:84:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_cpuid2=E2=80=99
  IOCTL(KVM_SET_CPUID2),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:85:8: error: invalid application of =E2=80=98sizeof=E2=80=99=
 to incomplete
type =E2=80=98struct kvm_cpuid2=E2=80=99
  IOCTL(KVM_GET_CPUID2),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:90:2: error: large integer implicitly truncated to unsigne=
d
type [-Werror=3Doverflow]
  IOCTL(KVM_S390_STORE_STATUS_NOADDR),
  ^
ioctls/kvm.c:91:2: error: large integer implicitly truncated to unsigne=
d
type [-Werror=3Doverflow]
  IOCTL(KVM_S390_STORE_STATUS_PREFIXED),
  ^
In file included from ioctls/kvm.c:8:0:
ioctls/kvm.c:102:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_x86_mce=E2=80=99
  IOCTL(KVM_X86_SET_MCE),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:105:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_vcpu_events=E2=80=99
  IOCTL(KVM_GET_VCPU_EVENTS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:106:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_vcpu_events=E2=80=99
  IOCTL(KVM_SET_VCPU_EVENTS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:107:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_debugregs=E2=80=99
  IOCTL(KVM_GET_DEBUGREGS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:108:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_debugregs=E2=80=99
  IOCTL(KVM_SET_DEBUGREGS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:110:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_xsave=E2=80=99
  IOCTL(KVM_GET_XSAVE),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:111:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_xsave=E2=80=99
  IOCTL(KVM_SET_XSAVE),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:112:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_xcrs=E2=80=99
  IOCTL(KVM_GET_XCRS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
ioctls/kvm.c:113:8: error: invalid application of =E2=80=98sizeof=E2=80=
=99 to incomplete
type =E2=80=98struct kvm_xcrs=E2=80=99
  IOCTL(KVM_SET_XCRS),
        ^
include/ioctls.h:53:15: note: in definition of macro =E2=80=98IOCTL=E2=80=
=99
  { .request =3D _request, .name =3D #_request, }
               ^
cc1: all warnings being treated as errors
make: *** [ioctls/kvm.o] Error 1


>=20
> diff --git a/syscalls/fcntl.c b/syscalls/fcntl.c
> index 6eb2344..5d651af 100644
> --- a/syscalls/fcntl.c
> +++ b/syscalls/fcntl.c
> @@ -23,6 +23,10 @@
>  #include "shm.h"
>  #include "compat.h"
>=20
> +#if F_GETLK64 !=3D F_GETLK
> +#define HAVE_LK64
> +#endif
> +
>  void sanitise_fcntl(int childno)
>  {
>  	switch (shm->a2[childno]) {
> @@ -66,7 +70,7 @@ void sanitise_fcntl(int childno)
>  	case F_SETLK:
>  	case F_SETLKW:
>  		break;
> -#ifndef __x86_64__
> +#ifdef HAVE_LK64
>  	case F_GETLK64:
>  		break;
>  	case F_SETLK64:
> @@ -122,7 +126,7 @@ struct syscall syscall_fcntl =3D {
>  	.arg2name =3D "cmd",
>  	.arg2type =3D ARG_OP,
>  	.arg2list =3D {
> -#ifdef __x86_64__
> +#ifndef HAVE_LK64
>  		.num =3D 20,
>  #else
>  		.num =3D 23,
> @@ -130,7 +134,7 @@ struct syscall syscall_fcntl =3D {
>  		.values =3D { F_DUPFD, F_DUPFD_CLOEXEC, F_GETFD, F_SETFD, F_GETFL,=
 F_SETFL, F_GETLK, F_SETLK,
>  		  F_SETLKW, F_GETOWN, F_SETOWN, F_GETOWN_EX, F_SETOWN_EX, F_GETSIG=
, F_SETSIG, F_GETLEASE,
>  		  F_SETLEASE, F_NOTIFY, F_SETPIPE_SZ, F_GETPIPE_SZ,
> -#ifndef __x86_64__
> +#ifdef HAVE_LK64
>  		  F_GETLK64, F_SETLK64, F_SETLKW64,
>  #endif
>  		},
>=20

