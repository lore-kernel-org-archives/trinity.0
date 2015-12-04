From: Vinson Lee <vlee@freedesktop.org>
Subject: Re: [PATCH v2] Remove unused variable in fds/drm.c.
Date: Fri, 4 Dec 2015 10:49:42 -0800
Message-ID: <CACKvgLHsZMP-XpMEo-FVWiES4d4nw4YBgoybsf7jXEdgUHbUOQ@mail.gmail.com>
References: <1449224332-29060-1-git-send-email-vlee@freedesktop.org> <20151204180701.GA28404@codemonkey.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        bh=MLAdaEL48XWYgGddelF2qzJRUl3UE9JySSF4aTNPQuQ=;
        b=TURkYzaFwiBgr5cF3y1Eo9v24AiONdg2thvlKXaiVO+H78srPaEdVGk85ymEBNvBb1
         eLUu12y4ZYnfI8QJ+1GM1qsMPOGYAiO6J+hg/nQsJpBp4Jj+0vp8tTzMglrgsz4xARNx
         wyq6llXtsHLkDJW7OjnzAe3MrSzYWbAOhWSltt6oP98lzw0A0XET3YaI46pgJ1/0+qVv
         tc4f2/cpHh6ewUrX2k+QdUGbYaYyORFG8dIZwxjAd1A3fWPh5v49UjjUVpRs2dWE95yv
         qxI0vkPTN3Tz3qAlKgzYd8Gn5O/3C1N3TMLoEByXmdyAANvLVFJrPk9amftE9yYvRaa7
         73qA==
In-Reply-To: <20151204180701.GA28404@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

On Fri, Dec 4, 2015 at 10:07 AM, Dave Jones <davej@codemonkey.org.uk> w=
rote:
> On Fri, Dec 04, 2015 at 02:18:52AM -0800, Vinson Lee wrote:
>  > Fix build error with GCC 5.2.1.
>  >
>  >   CC fds/drm.o
>  > fds/drm.c: In function =E2=80=98open_drm_fds=E2=80=99:
>  > fds/drm.c:70:15: error: unused variable =E2=80=98i=E2=80=99 [-Werr=
or=3Dunused-variable]
>  >   unsigned int i;
>  >                ^
>
> Applied. I wonder why debian's 5.2.1 didn't pick up on this.
> Judging by your other patches, I'm guessing this is Fedora's version =
?
>
>         Dave
>

Yes, the error was from GCC on Fedora.

$  gcc -v
Using built-in specs.
COLLECT_GCC=3Dgcc
COLLECT_LTO_WRAPPER=3D/usr/libexec/gcc/x86_64-redhat-linux/5.2.1/lto-wr=
apper
Target: x86_64-redhat-linux
Configured with: ../configure --enable-bootstrap
--enable-languages=3Dc,c++,objc,obj-c++,fortran,ada,go,lto --prefix=3D/=
usr
--mandir=3D/usr/share/man --infodir=3D/usr/share/info
--with-bugurl=3Dhttp://bugzilla.redhat.com/bugzilla --enable-shared
--enable-threads=3Dposix --enable-checking=3Drelease --enable-multilib
--with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-gnu-unique-object
--enable-linker-build-id --with-linker-hash-style=3Dgnu --enable-plugin
--enable-initfini-array --disable-libgcj --with-isl --enable-libmpx
--enable-gnu-indirect-function --with-tune=3Dgeneric --with-arch_32=3Di=
686
--build=3Dx86_64-redhat-linux
Thread model: posix
gcc version 5.2.1 20151104 (Red Hat 5.2.1-5) (GCC)

Vinson
