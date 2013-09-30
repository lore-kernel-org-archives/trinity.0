From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Added ability to select only 32 or 64 bit syscall
Date: Mon, 30 Sep 2013 13:34:23 -0400
Message-ID: <20130930173423.GA11016@redhat.com>
References: <CAEGbLtsPA2MvD_=s7ASTg8fkWD-cGHPk=ePGNPnZaALc_XDtsg@mail.gmail.com>
 <20130927214946.GA30967@redhat.com>
 <CAEGbLtsonrCxxeNxfDW0t91R32=6HhfeWWh7_dwnJChNM7pbhg@mail.gmail.com>
 <20130930170712.GA9455@redhat.com>
 <CAEGbLttCZo8nXwn_tAeouG_m_v7RHkt3h9YayYo1Jx=UHJjcCQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLttCZo8nXwn_tAeouG_m_v7RHkt3h9YayYo1Jx=UHJjcCQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Mon, Sep 30, 2013 at 10:28:27AM -0700, Ildar Muslukhov wrote:
 > I see, I though of this as a bad wording since architecture means
 > different things but what we are really doing in this parameter is
 > picking between 64 and 32 bit types, which is also an architecture.
 > Right now it expects 32 or 64 as an architecture. Thus you need to run
 > like
 > $./trinity -c open,32
 
duh. Reading the diff now, it seems obvious. Still, I just committed some reworded
--help text, and also the error message.

thanks,

	Dave
