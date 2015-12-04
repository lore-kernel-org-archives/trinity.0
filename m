From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH v2] Remove unused variable in fds/drm.c.
Date: Fri, 4 Dec 2015 13:07:01 -0500
Message-ID: <20151204180701.GA28404@codemonkey.org.uk>
References: <1449224332-29060-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449224332-29060-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Fri, Dec 04, 2015 at 02:18:52AM -0800, Vinson Lee wrote:
 > Fix build error with GCC 5.2.1.
 >=20
 >   CC	fds/drm.o
 > fds/drm.c: In function =E2=80=98open_drm_fds=E2=80=99:
 > fds/drm.c:70:15: error: unused variable =E2=80=98i=E2=80=99 [-Werror=
=3Dunused-variable]
 >   unsigned int i;
 >                ^

Applied. I wonder why debian's 5.2.1 didn't pick up on this.
Judging by your other patches, I'm guessing this is Fedora's version ?

	Dave
