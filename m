From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] Read pid_max from /proc
Date: Mon, 03 Jun 2013 16:12:59 +1000
Message-ID: <1370239979.21159.3.camel@concordia>
References: <1370221633-7143-1-git-send-email-michael@ellerman.id.au>
	 <CA+ydwtoa-VRGoAVURKYT71Zu=DVzB5LmZ9BmjxbKxYQ7J+wAEg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CA+ydwtoa-VRGoAVURKYT71Zu=DVzB5LmZ9BmjxbKxYQ7J+wAEg@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: trinity@vger.kernel.org

On Mon, 2013-06-03 at 08:54 +0300, Tommi Rantala wrote:
> 2013/6/3 Michael Ellerman <michael@ellerman.id.au>:
> > I was hitting this on my system, where it's 65536. So fix the todo and
> > read it from /proc.
> >
> > I left a fallback to the hardcoded values in case /proc is not mounted
> > or something else goes wrong.
> 
> Looks good to me, but please also fclose() in read_pid_max().

Ah crap, I knew I'd miss something, will resend.

cheers

