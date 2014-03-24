From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Add SWAP_FLAG_DISCARD symbol for older distros.
Date: Mon, 24 Mar 2014 18:38:28 -0400
Message-ID: <20140324223828.GA15359@redhat.com>
References: <1395697616-10620-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1395697616-10620-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org, Vinson Lee <vlee@twitter.com>

On Mon, Mar 24, 2014 at 02:46:56PM -0700, Vinson Lee wrote:
 > From: Vinson Lee <vlee@twitter.com>
 >=20
 > This patch fixes this build error on CentOS 6.
 >=20
 >   CC	syscalls/swap.o
 > syscalls/swap.c:16: error: =E2=80=98SWAP_FLAG_DISCARD=E2=80=99 undec=
lared here (not in a function)

applied, thanks.

	Dave
