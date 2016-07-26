From: Vinson Lee <vlee@freedesktop.org>
Subject: Re: [PATCH v2] Fix build on older kernels without BPF.
Date: Mon, 25 Jul 2016 17:24:43 -0700
Message-ID: <CACKvgLE23r+RGDWhp3D0z9_gnbWCXJS45=mZGV+o6L3pZ=Ypkw@mail.gmail.com>
References: <20160712190217.GA5525@codemonkey.org.uk> <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
 <20160721201048.GA9384@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=M6eYxxAwGdoRHs9a6jTDtFlc1lxnIwhjEVPjJPXaDxI=;
        b=tKMc1Jv7v1PAfnQDjkwFeI9QSMWTj+cUUpQlhfjGiKNIO2JIkLrmm5d4jw25ZnPiEv
         yNRt3sEGpBPUBtogRQpddE6V445H7YxtSajpRaOwuNuKPnpyrWTzZ1Xsuik9DNDyWzAY
         48Z/06DuLCOs87mEYcsVPtzRmEuJrwsX2E1AdCPjiB7HoGRY9sytVUsgjA94vEcM1x20
         0eGa41UrJGNSHcYT2TtbiVxhmxPtF089gpIVBd012t6a8Xmw/iFeAVLVrSd3NQeeEMBx
         hP5xE4GQfC6rZEsDY3hdrSo5QMmk0gBJvPQXK09NAXk5f2gXhlifz7ngC1zFGcNnHMy6
         YPnQ==
In-Reply-To: <20160721201048.GA9384@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

On Thu, Jul 21, 2016 at 1:10 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
> On Tue, Jul 12, 2016 at 09:33:56PM +0000, Vinson Lee wrote:
>  > Suggested-by: Dave Jones <davej@codemonkey.org.uk>
>  > Signed-off-by: Vinson Lee <vlee@freedesktop.org>
>
> Close, but..
>
>  > diff --git a/include/syscalls-aarch64.h b/include/syscalls-aarch64.h
>  > index 09acf41..ee18c64 100644
>  > --- a/include/syscalls-aarch64.h
>  > +++ b/include/syscalls-aarch64.h
>  > @@ -290,6 +290,8 @@ struct syscalltable syscalls_aarch64[] = {
>  >  /* 277 */   { .entry = &syscall_seccomp },
>  >  /* 278 */   { .entry = &syscall_getrandom },
>  >  /* 279 */   { .entry = &syscall_memfd_create },
>  > +#ifdef USE_BPF
>  >  /* 280 */   { .entry = &syscall_bpf },
>  > +#endif
>  >  /* 281 */   { .entry = &syscall_execveat },
>  >  };
>
> You need an
>
> #else
>         NULL,
>
> for each of these, otherwise the next syscall will be in the wrong slot.
>
>         Dave


I tried making that change but trinity would crash in
copy_syscall_table with memcpy with a NULL from[n].entry.

Program received signal SIGSEGV, Segmentation fault.
0x000000000041300e in copy_syscall_table (from=0x63d840, nr=329) at
/usr/include/bits/string3.h:52
52  return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
(gdb) bt
#0  0x000000000041300e in copy_syscall_table (from=0x63d840, nr=329)
at /usr/include/bits/string3.h:52
#1  0x00000000004130f3 in select_syscall_tables () at tables.c:491
#2  0x0000000000413e95 in main (argc=1, argv=0x7fffffffe438) at trinity.c:115

tables.c
   470  static struct syscalltable * copy_syscall_table(struct
syscalltable *from, unsigned int nr)
   471  {
   472          unsigned int n;
   473          struct syscallentry *copy;
   474
   475          copy = alloc_shared(nr * sizeof(struct syscallentry));
   476          if (copy == NULL)
   477                  exit(EXIT_FAILURE);
   478
   479          for (n = 0; n < nr; n++) {
   480                  memcpy(copy + n , from[n].entry, sizeof(struct
syscallentry));
   481                  copy[n].number = n;
   482                  copy[n].active_number = 0;
   483                  from[n].entry = &copy[n];
   484          }
   485          return from;
   486  }

Vinson
