From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: drm_mode_create_dumb_ioctl: divide error
Date: Sun, 24 Aug 2014 19:18:11 +0200
Message-ID: <CANq1E4S97B_RA+WQbsHe8JQsVnqTS3g6=uR3EQFN9n9bptFV2w@mail.gmail.com>
References: <CA+ydwtoGKP622R5XSSSvibd_5PtsQxtsijrdD23c-7waQvjC=g@mail.gmail.com>
 <CANq1E4TZPZQSP2wWLG2LJmf1YXyRnv0rtMyKGkjsfSV50RDSnA@mail.gmail.com>
 <CA+ydwtq7-O4+5jtu_zZEFGM7Nbq7pGqGG=UgZBnDzg58QsgMoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=mime-version:in-reply-to:references:date:message-id:subject:from:to
 :cc:content-type;
 bh=qF67AGZhhULTaefq0j/vwGab/fJ1Ki3uSfWMl1RqQB4=;
 b=zqECdDyxDWcGCFE4i2SkaZHt//6Z2MMB2YEP/AAaQ2BICHJ3CENBhqnoO16qabyJTl
 B3ML8CHjUzFyxEI9/JMTgvZyDpkWQqm0erb6ZcJygwO1Q3/RdrMQZi+S4y6WPurQMzaB
 DYjF8BS19m5BA6fQUs4E8Irp5TwFrfZWB2GpP5RqR7nO7dGmRxDlSyAP0HMCOw83KOTO
 4FuvDByHSc9+6kv5QPElASUZuceP4n0QUlQpePu90kkZuoYaRGzx5Cx+IigPJ1vJ9CXu
 eOP2KQd++xl4AXC9QOwLWKIr8GHGHe7jvgPCZ6jJ1vrbt6BU/DB+APvZIZuswir9Bqpa
 xK0g==
In-Reply-To: <CA+ydwtq7-O4+5jtu_zZEFGM7Nbq7pGqGG=UgZBnDzg58QsgMoA@mail.gmail.com>
List-Id: <trinity.vger.kernel.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, trinity@vger.kernel.org

Hi

On Sun, Aug 24, 2014 at 7:12 PM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> (gdb) info locals
> cpp = 0
> stride = 0
> size = <optimized out>
>
> (gdb) print /x *(struct drm_mode_create_dumb *)data
> $13 = {
>   height = 0xffffffff,
>   width = 0xffffffff,
>   bpp = 0xffffffff,
>   flags = 0xffffffff,
>   handle = 0xffffffff,
>   pitch = 0xffffffff,
>   size = 0xffffffffffffffff
> }

Thanks a lot for digging into this. Looks like DIV_ROUND_UP() can
overflow... *check*
Yes, it's defined as:
        #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

Kinda unexpected that a function called "DIV" can overflow, but makes
sense here. Obvious fix is to test "cpp" for zero. I will send it to
dri-devel.

Thanks!
David
