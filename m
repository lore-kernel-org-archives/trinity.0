From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/5] Makefile: use grep -c to avoid wc -l
Date: Tue, 07 Feb 2017 21:05:45 +1100
Message-ID: <877f52b9ja.fsf@concordia.ellerman.id.au>
References: <20170205155352.13191-1-tt.rantala@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20170205155352.13191-1-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>, davej@codemonkey.org.uk
Cc: trinity@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>

Tommi Rantala <tt.rantala@gmail.com> writes:

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index b93fc3a..16fafe8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,7 +2,7 @@ VERSION="1.8pre"
>  
>  INSTALL_PREFIX ?= $(DESTDIR)
>  INSTALL_PREFIX ?= $(HOME)
> -NR_CPUS := $(shell grep ^processor /proc/cpuinfo | /usr/bin/wc -l)
> +NR_CPUS := $(shell grep -c ^processor /proc/cpuinfo)

Or you could just use nproc(1) ?

It's in coreutils, but maybe that's not sufficiently portable?

cheers
