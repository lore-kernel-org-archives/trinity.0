From: Dave Jones <davej@redhat.com>
Subject: Re: stack smash detected bug
Date: Fri, 4 Oct 2013 11:29:34 -0400
Message-ID: <20131004152934.GA22724@redhat.com>
References: <CAEGbLtsV-FUm0Q8NiGyiTscDVUOfqYxz=9Dncv3xFgAb6b6saw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsV-FUm0Q8NiGyiTscDVUOfqYxz=9Dncv3xFgAb6b6saw@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Thu, Oct 03, 2013 at 06:53:08PM -0700, Ildar Muslukhov wrote:
 > Hi,
 > 
 > I've been looking through the strange behavior today, where I am
 > getting lots of "stack smashing detected" and found that the most
 > probable place is the mkcall function. Here is the call stack:
 > [0x440545] (stack check related calls)
 > [0x44050e] (stack check related calls)
 > [0x408db4]<-stack canary check
 > [0x412709]<-call mkcall
 > [0x402228]
 > [0x405586]
 > [0x40185a]
 > [0x412b44]
 > [0x401db1]<-main()
 > 
 > After looking into the code in mkcall:
 > >long mkcall(int childno)
 > >{
 > >        unsigned long olda1, olda2, olda3, olda4, olda5, olda6;
 > >        unsigned int call = shm->syscallno[childno];
 > >        unsigned long ret = 0;
 > >        int errno_saved;
 > >        char string[512], *sptr;
 > ...
 > I suspect that string[512] is the issue. The simple tests confirms
 > that assumption (I've just commented out the block of color_arg
 > function calls that fill the buffer with parameter values).

If that's getting overrun, I'm really curious what the string is,
because that should only be holding a single line of text.
Even with all the ansi codes it should be plenty.

	Dave
