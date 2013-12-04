From: Vinson Lee <vlee@freedesktop.org>
Subject: Re: [PATCH] syscall/prctl.c: Fix unused variable build error with USE_SECCOMP=0.
Date: Wed, 4 Dec 2013 10:49:38 -0800
Message-ID: <CACKvgLGqQwuwB5UzCtxY0v-YOgrTpDF_X4dM+qRVfUJwYVidMw@mail.gmail.com>
References: <1386181980-3294-1-git-send-email-vlee@freedesktop.org>
	<20131204184415.GA6013@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=8b3kcfuXPkW/Le6Vpf7flTxdePSskuLX8HrqfsV5rKY=;
        b=C0xTXRwGxufVbc0iRobgGP6WP7WMTuITudwD5CqNCzSWyT+Pav1iEQ92zgDj1BjxeM
         dcsezHZW1Xe2kjSMzbGw2e+ev1XspeD6wln58PAQQoij1Y9hnemIx5oLdbdMaEL/0tcP
         LhpCvbp5GuR8e32nIEGmPxaebPaEyc3y0fbCa+7CQzmj+Gt6f3qvpSbZnOHmODXqEAO4
         N/SXO7qjNvKjkq/jftlZYuweAJEqMVRs9u3vHU0R4NClFnubAPdKKKa1efBUqXF0BBBg
         6iqA4+Rb2ocZmID3p/wt1xPUQA3yAaCtAfHX1GV0y0ccP6mZD4CEFdc2Ih1fl6Tka7tF
         OBog==
In-Reply-To: <20131204184415.GA6013@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org, Vinson Lee <vlee@twitter.com>

On Wed, Dec 4, 2013 at 10:44 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Dec 04, 2013 at 10:33:00AM -0800, Vinson Lee wrote:
>  > From: Vinson Lee <vlee@twitter.com>
>  >
>  > This patch fixes this build error on CentOS 6.
>  >
>  >   CC syscalls/prctl.o
>  > cc1: warnings being treated as errors
>  > syscalls/prctl.c: In function =91sanitise_prctl=92:
>  > syscalls/prctl.c:36: error: unused variable =91saddr=92
>  >
>  > Signed-off-by: Vinson Lee <vlee@twitter.com>
>
> bigger diff, but I think this looks cleaner..
> Can you test ?
>
>
> diff --git a/syscalls/prctl.c b/syscalls/prctl.c
> index acca0279acab..09364df6a37a 100644
> --- a/syscalls/prctl.c
> +++ b/syscalls/prctl.c
> @@ -17,6 +17,7 @@
>  #include "maps.h"
>  #include "shm.h"
>  #include "compat.h"
> +#include "trinity.h"
>
>  #define NR_PRCTL_OPTS 28
>  static int prctl_opts[NR_PRCTL_OPTS] =3D {
> @@ -29,31 +30,39 @@ static int prctl_opts[NR_PRCTL_OPTS] =3D {
>         PR_MCE_KILL, PR_MCE_KILL_GET,
>  };
>
> +
> +#ifdef USE_SECCOMP
> +static void do_set_seccomp(int childno)
> +{
> +       struct sockaddr *saddr =3D NULL;
> +
> +//     if (rand() % 3 =3D=3D SECCOMP_MODE_FILTER) {
> +
> +// FIXME: This leaks memory, but needs to be cleared after the sysca=
ll is done.
> +               gen_seccomp_bpf((unsigned long **) &saddr, NULL);
> +               shm->a2[childno] =3D SECCOMP_MODE_FILTER;
> +               shm->a3[childno] =3D (unsigned long) saddr;
> +//     }
> +}
> +#else
> +static void do_set_seccomp(__unused__ int childno) { }
> +#endif
> +
>  /* We already got a generic_sanitise at this point */
>  void sanitise_prctl(int childno)
>  {
>         int option =3D prctl_opts[rand() % NR_PRCTL_OPTS];
> -       struct sockaddr *saddr =3D NULL;
>
>  // For now, just do SECCOMP, the other options need some attention.
> -option =3D PR_SET_SECCOMP;
> +       option =3D PR_SET_SECCOMP;
>
> -       /* Also allow crap by small chance */
> -       if (rand() % 100 !=3D 0)
> -               shm->a1[childno] =3D option;
> +       shm->a1[childno] =3D option;
>
>         switch (option) {
>         case PR_SET_SECCOMP:
> -#ifdef USE_SECCOMP
> -//             if (rand() % 3 =3D=3D SECCOMP_MODE_FILTER) {
> -// FIXME: This leaks memory, but needs to be cleared
> -// after the syscall is done.
> -                       gen_seccomp_bpf((unsigned long **) &saddr, NU=
LL);
> -                       shm->a2[childno] =3D SECCOMP_MODE_FILTER;
> -                       shm->a3[childno] =3D (unsigned long) saddr;
> -//             }
> -#endif
> +               do_set_seccomp(childno);
>                 break;
> +
>         default:
>                 break;
>         }


I confirm that this diff also fixes the CentOS 6 build error.

Tested-by: Vinson Lee <vlee@twitter.com>
