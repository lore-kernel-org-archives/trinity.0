From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Avoid do_rt_tgsigqueueinfo kernel warning.
Date: Wed, 28 Aug 2013 16:40:36 -0400
Message-ID: <20130828204036.GC22866@redhat.com>
References: <1377310218-12590-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377310218-12590-1-git-send-email-vlee@freedesktop.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org, Vinson Lee <vlee@twitter.com>

On Fri, Aug 23, 2013 at 07:10:18PM -0700, Vinson Lee wrote:
 > From: Vinson Lee <vlee@twitter.com>
 > 
 > trinity regularly hits the following kernel warning, which doesn't
 > appear to be an actual kernel bug, and stops running.
 > 
 > WARNING: at kernel/signal.c:2955 do_rt_tgsigqueueinfo+0x42/0x5c()
 > Call Trace:
 >  [<ffffffff8104920c>] warn_slowpath_common+0x85/0x9d
 >  [<ffffffff8104923e>] warn_slowpath_null+0x1a/0x1c
 >  [<ffffffff810591eb>] do_rt_tgsigqueueinfo+0x42/0x5c
 >  [<ffffffff81059257>] sys_rt_tgsigqueueinfo+0x52/0x5f
 >  [<ffffffff814df4a9>] system_call_fastpath+0x16/0x1b
 > 
 > This patch sanitizes rt_tgsigqueueinfo arguments to avoid triggering the
 > above warning.
 > 
 > Signed-off-by: Vinson Lee <vlee@twitter.com>

I think we're better off trying to get that removed upstream.
It's kind of a silly warning.

	Dave
