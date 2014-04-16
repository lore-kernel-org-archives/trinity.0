From: Dave Jones <davej@redhat.com>
Subject: Re: GCC 4.9 build error child.c:274:14: error: variable 'lastop'
 might be clobbered by 'longjmp' or 'vfork' [-Werror=clobbered]
Date: Tue, 15 Apr 2014 23:27:46 -0400
Message-ID: <20140416032746.GA10266@redhat.com>
References: <CAHTgTXUQO_5zCZuW_bYE0Vk473=K0-_qR7ZzfghEOKr381Ov=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHTgTXUQO_5zCZuW_bYE0Vk473=K0-_qR7ZzfghEOKr381Ov=g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@twopensource.com>
Cc: trinity@vger.kernel.org

On Mon, Apr 14, 2014 at 11:42:11AM -0700, Vinson Lee wrote:
 > This build error occurs with GCC 4.9.
 > 
 > $ gcc --version
 > gcc (GCC) 4.9.0 20140411 (Red Hat 4.9.0-0.10)
 > Copyright (C) 2014 Free Software Foundation, Inc.
 > This is free software; see the source for copying conditions.  There is NO
 > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 > 
 > $ make
 > [...]
 >   CC    child.o
 > child.c: In function 'child_process':
 > child.c:274:14: error: variable 'lastop' might be clobbered by
 > 'longjmp' or 'vfork' [-Werror=clobbered]
 >   const char *lastop = NULL;
 >               ^

heh, I had a hard disk accident last weekend, so hadn't gotten around to
trying 4.9 until this morning.  Should be fixed now.
Was actually quite surprised this was the only new warning.

	Dave
