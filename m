From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Added ability to select only 32 or 64 bit syscall
Date: Fri, 27 Sep 2013 17:49:46 -0400
Message-ID: <20130927214946.GA30967@redhat.com>
References: <CAEGbLtsPA2MvD_=s7ASTg8fkWD-cGHPk=ePGNPnZaALc_XDtsg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsPA2MvD_=s7ASTg8fkWD-cGHPk=ePGNPnZaALc_XDtsg@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Fri, Sep 13, 2013 at 12:53:16PM -0700, Ildar Muslukhov wrote:
 > This patch explicit selection of 32 or 64 bit version of a syscall via
 > parameter.
 
I only just noticed this..

 > - fprintf(stderr, " -c#: target specific syscall (takes syscall name as parameter).\n");
 > + fprintf(stderr, " -c#,@: target specific syscall (takes syscall name as parameter and @ as architecture. No @ defaults to both archs.).\n");

The patch I ended up applying looks like it doesn't touch -c parsing.
Is this incomplete ?

	Dave
