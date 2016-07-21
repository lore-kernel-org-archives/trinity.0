From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH v2] Fix build on older kernels without BPF.
Date: Thu, 21 Jul 2016 16:10:48 -0400
Message-ID: <20160721201048.GA9384@codemonkey.org.uk>
References: <20160712190217.GA5525@codemonkey.org.uk>
 <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Tue, Jul 12, 2016 at 09:33:56PM +0000, Vinson Lee wrote:
 > Suggested-by: Dave Jones <davej@codemonkey.org.uk>
 > Signed-off-by: Vinson Lee <vlee@freedesktop.org>

Close, but..

 > diff --git a/include/syscalls-aarch64.h b/include/syscalls-aarch64.h
 > index 09acf41..ee18c64 100644
 > --- a/include/syscalls-aarch64.h
 > +++ b/include/syscalls-aarch64.h
 > @@ -290,6 +290,8 @@ struct syscalltable syscalls_aarch64[] = {
 >  /* 277 */	{ .entry = &syscall_seccomp },
 >  /* 278 */	{ .entry = &syscall_getrandom },
 >  /* 279 */	{ .entry = &syscall_memfd_create },
 > +#ifdef USE_BPF
 >  /* 280 */	{ .entry = &syscall_bpf },
 > +#endif
 >  /* 281 */	{ .entry = &syscall_execveat },
 >  };

You need an

#else
	NULL,

for each of these, otherwise the next syscall will be in the wrong slot.

	Dave
