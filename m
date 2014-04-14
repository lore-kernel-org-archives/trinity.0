From: Vinson Lee <vlee@twopensource.com>
Subject: GCC 4.9 build error child.c:274:14: error: variable 'lastop' might be
 clobbered by 'longjmp' or 'vfork' [-Werror=clobbered]
Date: Mon, 14 Apr 2014 11:42:11 -0700
Message-ID: <CAHTgTXUQO_5zCZuW_bYE0Vk473=K0-_qR7ZzfghEOKr381Ov=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

This build error occurs with GCC 4.9.

$ gcc --version
gcc (GCC) 4.9.0 20140411 (Red Hat 4.9.0-0.10)
Copyright (C) 2014 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ make
[...]
  CC    child.o
child.c: In function 'child_process':
child.c:274:14: error: variable 'lastop' might be clobbered by
'longjmp' or 'vfork' [-Werror=clobbered]
  const char *lastop = NULL;
              ^
