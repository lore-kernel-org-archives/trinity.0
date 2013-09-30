From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Added ability to select only 32 or 64 bit syscall
Date: Mon, 30 Sep 2013 13:07:12 -0400
Message-ID: <20130930170712.GA9455@redhat.com>
References: <CAEGbLtsPA2MvD_=s7ASTg8fkWD-cGHPk=ePGNPnZaALc_XDtsg@mail.gmail.com>
 <20130927214946.GA30967@redhat.com>
 <CAEGbLtsonrCxxeNxfDW0t91R32=6HhfeWWh7_dwnJChNM7pbhg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsonrCxxeNxfDW0t91R32=6HhfeWWh7_dwnJChNM7pbhg@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Mon, Sep 30, 2013 at 09:51:02AM -0700, Ildar Muslukhov wrote:
 
 > On Fri, Sep 27, 2013 at 2:49 PM, Dave Jones <davej@redhat.com> wrote:
 > > On Fri, Sep 13, 2013 at 12:53:16PM -0700, Ildar Muslukhov wrote:
 > >  > This patch explicit selection of 32 or 64 bit version of a syscall via
 > >  > parameter.
 > >
 > > I only just noticed this..
 > >
 > >  > - fprintf(stderr, " -c#: target specific syscall (takes syscall name as parameter).\n");
 > >  > + fprintf(stderr, " -c#,@: target specific syscall (takes syscall name as parameter and @ as architecture. No @ defaults to both archs.).\n");
 > >
 > > The patch I ended up applying looks like it doesn't touch -c parsing.
 > > Is this incomplete ?
 >
 > Nope,
 > 
 > The splitting of the parameter is done in the toggle_syscall function.

Ok, then I'm confused, because the syntax above doesn't seem to parse architecture.

$ ./trinity -c open,x86_64
Trinity v1.3pre  Dave Jones <davej@redhat.com>
No idea what architecture for syscall (open,x86_64) is

	Dave
