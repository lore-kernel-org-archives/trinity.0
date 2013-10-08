From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] converted debugf from macro to a function
Date: Tue, 8 Oct 2013 14:34:17 -0700
Message-ID: <CAEGbLttPiVvmcFbO+yVkgiyLNiKXiYCa3_a+tS73HBhFMvUoOg@mail.gmail.com>
References: <1381267965-10656-1-git-send-email-ildarm@google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=H4Ky8l5M1ztgoKZmwAuSiGgATykOIJadwSi2ZTw3kkI=;
        b=i47Aj4SgQA3hJY6/xmFTMR93d8Ddje9mjsZ33gcXMVuXbzNq+0u+i8AKxojSuzmlWd
         bA0vidzFw9UPtSB/kWob+0qj526Z6SPNFPmpx/OA9NxABBhMLRB9M/u3FaqFnxNKDNi9
         gbLYrNp1NW+uPBA4zgm0BMq3UgYEoCTfucKef01TnI942nhw6Fl/5b2SnI4FcjcrTznw
         1FYg2KB3RNm0AAchrAiCJnuTQAQ0wWIo6KqbVLDH56oXS+9xv1Mxt/VVsGYCsgnIN5QV
         RGVlsgq0xZ6Ml5JMyMowSkCtxtciX4lBb8W7doj0vUi2iffLSmxCzI4R4fNV6T9wLtnI
         ud1A==
In-Reply-To: <1381267965-10656-1-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

This one is nothing major, just decided to fill one of the TODO on
converting it to a function in order to contain as many printf in one
source file as possible.

-ildar

On Tue, Oct 8, 2013 at 2:32 PM, Ildar Muslukhov <ildarm@google.com> wrote:
> This patch replaces debugf macro with a function.
>
> Signed-off-by: Ildar Muslukhov <ildarm@google.com>
>
> ---
>  fils.c       |  6 +++---
>  include/log.h |  1 +
>  log.c         | 13 ++++++++++++-
>  main.c        |  2 --
>  sockets.c     |  8 ++++----
>  tables.c      |  2 +-
>  6 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/files.c b/files.c
> index a5296da..7fcfb77 100644
> --- a/files.c
> +++ b/files.c
> @@ -68,7 +68,7 @@ static int ignore_files(const char *path)
>                 }
>
>                 if (!strcmp(path, ignored_paths[i])) {
> -//                     printf("Skipping %s\n", path);
> +                       debugf("Skipping %s\n", path);
>                         return 1;
>                 }
>         }
> @@ -85,14 +85,14 @@ static int ignore_files(const char *path)
>
>         for (i = 0; ignored_patterns[i]; i++) {
>                 if (!strcmp(path + offset, ignored_patterns[i])) {
> -//                     printf("Skipping pattern %s\n", path);
> +                       debugf("Skipping pattern %s\n", path);
>                         return 1;
>                 }
>         }
>
>         /* special case to match tty* until I do globbing */
>         if (!strncmp(path + offset, "tty", 3)) {
> -//             printf("Skipping %s\n", path);
> +               debugf("Skipping %s\n", path);
>                 return 1;
>         }
>         return 0;
> diff --git a/include/log.h b/include/log.h
> index bc870ab..b257b53 100644
> --- a/include/log.h
> +++ b/include/log.h
> @@ -36,6 +36,7 @@ void output_syscall_postfix(unsigned long ret, int errno_saved, bool err);
>
>  void open_logfiles(void);
>  void close_logfiles(void);
> +void debugf(const char *fmt, ...);
>
>  #define __stringify_1(x...)     #x
>  #define __stringify(x...)       __stringify_1(x)
> diff --git a/log.c b/log.c
> index 6340d59..705153c 100644
> --- a/log.c
> +++ b/log.c
> @@ -423,4 +423,15 @@ void output_syscall_postfix(unsigned long ret, int errno_saved, bool err)
>                 if (quiet_level == MAX_LOGLEVEL)
>                         output_syscall_postfix_success(ret, stdout, monochrome);
>         }
> -}
> \ No newline at end of file
> +}
> +
> +void debugf(const char *fmt, ...)
> +{
> +       va_list args;
> +
> +       if (debug == TRUE) {
> +               va_start(args, fmt);
> +               vprintf(fmt, args);
> +               va_end(args);
> +       }
> +}
> diff --git a/main.c b/main.c
> index 0a1eba7..51732a6 100644
> --- a/main.c
> +++ b/main.c
> @@ -84,8 +84,6 @@ static void oom_score_adj(int adj)
>         fclose(fp);
>  }
>
> -#define debugf if (debug == TRUE) printf
> -
>  static void fork_children(void)
>  {
>         int pidslot;
> diff --git a/sockets.c b/sockets.c
> index de43d4b..ee56e49 100644
> --- a/sockets.c
> +++ b/sockets.c
> @@ -49,15 +49,15 @@ static int open_socket(unsigned int domain, unsigned int type, unsigned int prot
>
>                 ret = bind(fd, &sa, salen);
>  /*             if (ret == -1)
> -                       printf("bind: %s\n", strerror(errno));
> +                       debugf("bind: %s\n", strerror(errno));
>                 else
> -                       printf("bind: success!\n");
> +                       debugf("bind: success!\n");
>  */
>                 ret = listen(fd, (rand() % 2) + 1);
>  /*             if (ret == -1)
> -                       printf("listen: %s\n", strerror(errno));
> +                       debugf("listen: %s\n", strerror(errno));
>                 else
> -                       printf("listen: success!\n");
> +                       debugf("listen: success!\n");
>  */
>         }
>
> diff --git a/tables.c b/tables.c
> index fab6675..f159814 100644
> --- a/tables.c
> +++ b/tables.c
> @@ -38,7 +38,7 @@ int search_syscall_table(const struct syscalltable *table, unsigned int nr_sysca
>         /* search by name */
>         for (i = 0; i < nr_syscalls; i++) {
>                 if (strcmp(arg, table[i].entry->name) == 0) {
> -                       //printf("Found %s at %u\n", table[i].entry->name, i);
> +                       //debugf("Found %s at %u\n", table[i].entry->name, i);
>                         return i;
>                 }
>         }
> --
> 1.8.4
>
