From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix two shadow compiler warnings
Date: Fri, 15 Aug 2014 17:18:16 -0400
Message-ID: <20140815211816.GA2096@redhat.com>
References: <1408136559-13716-1-git-send-email-brian.haley@hp.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408136559-13716-1-git-send-email-brian.haley@hp.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Brian Haley <brian.haley@hp.com>
Cc: trinity@vger.kernel.org

On Fri, Aug 15, 2014 at 05:02:39PM -0400, Brian Haley wrote:
 >   CC	fd-files.o
 > fd-files.c: In function =E2=80=98list_to_index=E2=80=99:
 > fd-files.c:216:15: warning: declaration of =E2=80=98index=E2=80=99 s=
hadows a global declaration [-Wshadow]
 >   CC	fds.o
 > fds.c: In function =E2=80=98process_disable_fds_param=E2=80=99:
 > fds.c:164:38: warning: declaration of =E2=80=98optarg=E2=80=99 shado=
ws a global declaration [-Wshadow]

ugh, what gcc is that with ?
It seems 4.9.1 is smart enough to figure out that isn't a problem.

I'll apply the patch though.

	Dave
