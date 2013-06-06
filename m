From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net: Unbreak compat_sys_{send,recv}msg
Date: Thu, 06 Jun 2013 06:45:37 -0700
Message-ID: <1370526337.24311.335.camel@edumazet-glaptop>
References: <20130606132926.f4161ddff87dc9a55e33a8ca@canb.auug.org.au>
	 <e3bf421e44c6d27817c15a8683612a49e093b419.1370496702.git.luto@amacapital.net>
	 <20130606.002625.223430401087826901.davem@davemloft.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=+S8nmS+yJ89+oQO+kuIei9zF+5CYYydLtQiZSHeZSBM=;
        b=TWYA0Pz+mGLJXURcipCwmIcIGVNUMtp6NryQ5B+7qmQ1baAQZFkwo+SKX8uACEJGou
         rEYprZpO//z6eL0DNLvn0bVP6fUaGNJ5j9Cho0+K3B4ZFNMKJ4UrhuLGnTXgrZxtMoiF
         ldIoFKOXuhiOYPl4Y/+Bu3BUoTKa7S3o/zTUPfVfWUloSzjYDxQIlO3KXNlFgM3pSnvS
         Uu7TeYSzGqeXuNv1WLvwsrKwDfB1pq/4osIbAFXUlVEf4WkdIAUC5gBATVeMB5Wb4nQV
         K1Yq6LznVrqD7cxRbwCIcgtXj8YAa6+DgUc8VXQMiuxn9WMPNh1bsOJvFx9N7Iu2/4uI
         0yjg==
In-Reply-To: <20130606.002625.223430401087826901.davem@davemloft.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Miller <davem@davemloft.net>
Cc: luto@amacapital.net, x86@kernel.org, torvalds@linux-foundation.org, mikey@neuling.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, trinity@vger.kernel.org

On Thu, 2013-06-06 at 00:26 -0700, David Miller wrote:
> From: Andy Lutomirski <luto@amacapital.net>
> Date: Wed,  5 Jun 2013 22:38:26 -0700
> 
> > I broke them in this commit:
> > 
> >     commit 1be374a0518a288147c6a7398792583200a67261
> >     Author: Andy Lutomirski <luto@amacapital.net>
> >     Date:   Wed May 22 14:07:44 2013 -0700
> > 
> >         net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
> > 
> > This patch adds __sys_sendmsg and __sys_sendmsg as common helpers that accept
> > MSG_CMSG_COMPAT and blocks MSG_CMSG_COMPAT at the syscall entrypoints.  It
> > also reverts some unnecessary checks in sys_socketcall.
> > 
> > Apparently I was suffering from underscore blindness the first time around.
> > 
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> 
> Eric, can you test this patch too?

Yes, this fixes the problem as well on x86_64

Tested-by: Eric Dumazet <edumazet@google.com>

Thanks !

PS: I had following fuzz while applying on Linus tree :

patching file include/linux/socket.h
Hunk #1 succeeded at 320 (offset -1 lines).
patching file net/compat.c
patching file net/socket.c
Hunk #1 succeeded at 1956 (offset -22 lines).
Hunk #2 succeeded at 2071 (offset -22 lines).
Hunk #3 succeeded at 2125 (offset -22 lines).
Hunk #4 succeeded at 2163 (offset -22 lines).
Hunk #5 succeeded at 2255 (offset -22 lines).
Hunk #6 succeeded at 2317 (offset -22 lines).
Hunk #7 succeeded at 2515 (offset -20 lines).

