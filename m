From: Dave Jones <davej@redhat.com>
Subject: Re: stack smash detected bug
Date: Fri, 4 Oct 2013 13:17:09 -0400
Message-ID: <20131004171709.GA28371@redhat.com>
References: <CAEGbLtsV-FUm0Q8NiGyiTscDVUOfqYxz=9Dncv3xFgAb6b6saw@mail.gmail.com>
 <20131004152934.GA22724@redhat.com>
 <CAEGbLtuA81sypq9i2AUyEY89jErdLv6pk_ceaKFSggqBFDFsfQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtuA81sypq9i2AUyEY89jErdLv6pk_ceaKFSggqBFDFsfQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Fri, Oct 04, 2013 at 10:11:04AM -0700, Ildar Muslukhov wrote:
 > Here is an example that causes the crash, it is obviously longer that 512 ascii:
 > [child0:1607] [31] utimensat(dfd=^[[1;36m497
 > , filename=^[[1;36m".//proc/4/task/4/cpusetd%s%d%d%d%d%s%s%s%d%d%s%d%d%d%d%s%s%d
 > %s%s%d%s%d%s%s%d%d%s%d%d%d%d%s%d%d%s%s%s%d%s%d%d%s%d%d%s%d%s%d%s%d%d%d%s%s%s%s%s
 > %d%s%s%d%s%d%d%d%d%d%s%d%s%s%d%s%d%d%d%d%d%d%s%d%d%s%s%s%d%d%d%d%d%d%s%s%d%s%s%d
 > %s%s%s%s%d%s%d%d%d%d%d%d%s%s%d%s%d%d%s%d%d%s%s%d%s%d%d%d%s%s%d%s%d%s%d%s%s%d%s%s
 > %d%d%s%s%s%s%s%d%s%d%d%d%s%s%d%s%s%d%s%s%d%s%d%d%s%d%s%d%d%s%s%d%s%d%d%d%s%s%d%s
 > %s%s%s%d%d%s%s%d%d%d%s%d%d%s%d%s%s%d%s%s%s%d%s%d%d%s%d%s%d%s%d%s%d%s%d%d%s%s%d%s
 > %d%s%s%d%d%s%s%s%s%d%d%d%d%d%d%d%s%s%s%d%d%d%s%d%s%s%d%d%s%s%s%s%d%d%s%s%d%d%d%s
 > %d%s%d%d%s%d%d%d%s%s%d%s%s%d%s%s%s%d%s%d%s%s%s%s%s%d%d%s%d%s%s%d%d%s%d%s%s%d%s%s
 > %d%d%d%s%d%d%d%s%d%d%d%s%s%s%d%d%d%s%d%d%d%s%s%d%d%s%s%s%d%d%d%d%d%s%s%d%s%d%d%s
 > %d%d%d%s%s%d%s%s%s%s%d%s%d%s%s%d%d%d%d%d%s%d%d%s%s%d%d%d%d%d%s%d%d%s%s%s%d%d%s%s
 > %d%s%s%d%d%d%s%d%s%s%s%d%s%s%s%s%s%s%s%s%s%s%s%s%d%d%s%d%s%d%d%s%s%s%s%s%s%d%s%d
 > %s%d%d%s%d%d%d%s%s%s%s%s%d%d%d%s%s%s%s%d%s%s%s%d%d%d%s%d%s%s%d%d%s%s%s%s%s%s%s%d
 > %s%d%s%s%d%d%d%s%s%d%s%s%s%d%s%d%s%
 > [child1:1608] [0] setreuid(ruid=0x400000000000000,
 > euid=0xffffffffffffffff) [child1:1608] = -1 (Operation not permitted)

Ah, of course.. the pathname mangler. Oops.

This perhaps ?

	Dave

diff --git a/syscall.c b/syscall.c
index 80f5a34..94d2f1b 100644
--- a/syscall.c
+++ b/syscall.c
@@ -222,9 +222,11 @@ long mkcall(int childno)
        unsigned int call = shm->syscallno[childno];
        unsigned long ret = 0;
        int errno_saved;
-       char string[512], *sptr;
+       char *string, *sptr;
        uid_t olduid = getuid();
 
+       string = malloc(page_size);
+
        shm->regenerate++;
 
        sptr = string;
@@ -318,6 +320,9 @@ skip_args:
 
        output(2, "%s\n", string);
 
+       free(string);
+
+
        if (dopause == TRUE)
                sleep(1);
