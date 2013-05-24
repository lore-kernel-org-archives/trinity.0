From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix build on kernels without perf_event_attr
 exclude_callchain_kernel.
Date: Fri, 24 May 2013 10:34:14 -0400
Message-ID: <20130524143413.GC3106@redhat.com>
References: <1369368527-21362-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1369368527-21362-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org, Vinson Lee <vlee@twitter.com>

On Thu, May 23, 2013 at 09:08:47PM -0700, Vinson Lee wrote:
 > From: Vinson Lee <vlee@twitter.com>
 >=20
 > This patch fixes these build errors on 3.6 and older.
 >=20
 >   CC	syscalls/perf_event_open.o
 > syscalls/perf_event_open.c: In function =E2=80=98create_mostly_valid=
_counting_event=E2=80=99:
 > syscalls/perf_event_open.c:382:6: error: =E2=80=98struct perf_event_=
attr=E2=80=99 has no member named =E2=80=98exclude_callchain_kernel=E2=80=
=99
 > syscalls/perf_event_open.c:383:6: error: =E2=80=98struct perf_event_=
attr=E2=80=99 has no member named =E2=80=98exclude_callchain_user=E2=80=
=99
 > syscalls/perf_event_open.c: In function =E2=80=98create_mostly_valid=
_sampling_event=E2=80=99:
 > syscalls/perf_event_open.c:431:6: error: =E2=80=98struct perf_event_=
attr=E2=80=99 has no member named =E2=80=98exclude_callchain_kernel=E2=80=
=99
 > syscalls/perf_event_open.c:432:6: error: =E2=80=98struct perf_event_=
attr=E2=80=99 has no member named =E2=80=98exclude_callchain_user=E2=80=
=99
 > make: *** [syscalls/perf_event_open.o] Error 1
 >=20
 > Signed-off-by: Vinson Lee <vlee@twitter.com>
 > ---
 >  configure.sh               |   26 ++++++++++++++++++++++++++
 >  syscalls/perf_event_open.c |    4 ++++
 >  2 files changed, 30 insertions(+)
 >=20
 > diff --git a/configure.sh b/configure.sh
 > index e676418..4be1e59 100755
 > --- a/configure.sh
 > +++ b/configure.sh
 > @@ -182,6 +182,32 @@ else
 >  fi

thanks, applied.

	Dave
