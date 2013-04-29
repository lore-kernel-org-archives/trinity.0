From: Dave Jones <davej@redhat.com>
Subject: Re: compile error in latest git tree
Date: Mon, 29 Apr 2013 16:38:20 -0400
Message-ID: <20130429203820.GA30835@redhat.com>
References: <517ED743.2020900@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517ED743.2020900@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Mon, Apr 29, 2013 at 10:25:39PM +0200, Toralf F=C3=B6rster wrote:
 > At an 32 bit stable Gentoo w/ kernel 3.9 I get :
 >=20
 >   CC    ioctls/vt.o
 > ioctls/kvm.c:114:2: error: =E2=80=98KVM_GET_REG_LIST=E2=80=99 undecl=
ared here (not in a
 > function)
 >   CC    ioctls/firewire.o
 > make: *** [ioctls/kvm.o] Error 1
 > make: *** Waiting for unfinished jobs....

=46ixed, thanks for the report.

	Dave
