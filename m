From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Ignore ENOSYS from sys_msgrcv() and sys_ipc()
Date: Wed, 4 Jun 2014 15:35:40 -0400
Message-ID: <20140604193540.GC12375@redhat.com>
References: <1401861929-23686-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401861929-23686-1-git-send-email-mpe@ellerman.id.au>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: trinity@vger.kernel.org

On Wed, Jun 04, 2014 at 04:05:29PM +1000, Michael Ellerman wrote:
 > sys_msgrcv() and therefore also sys_ipc() can return ENOSYS when
 > CONFIG_CHECKPOINT_RESTORE=n. See prepare_copy() in ipc/msg.c.

heh, good catch. I thought I had that syscall covered after
cc288084667fe87a496048a16ad45cc06d359be1

Applied and pushed out.

	Dave
