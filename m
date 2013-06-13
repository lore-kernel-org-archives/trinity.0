From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Thu, 13 Jun 2013 17:05:04 -0400
Message-ID: <20130613210504.GB5440@redhat.com>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
 <CA+ydwtr7eTOjtzWumr998TcxqhmX_M30aW99S=DF6mOwNURL=w@mail.gmail.com>
 <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu>
 <20130613205332.GA5440@redhat.com>
 <alpine.DEB.2.10.1306131706250.4638@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306131706250.4638@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Tommi Rantala <tt.rantala@gmail.com>, trinity@vger.kernel.org

On Thu, Jun 13, 2013 at 05:07:59PM -0400, Vince Weaver wrote:
 > On Thu, 13 Jun 2013, Dave Jones wrote:
 > > 
 > > Probably safer ?
 > > 
 > > +               *type = rand32() | 1;
 > > +               *config1 = rand64() | 1;
 > > +               return rand64() | 1;
 > 
 > no, 0 is a perfectly valid value for all of those fields.
 > 
 > The error was coming in to play because if sysfs wasn't found, num_pmus
 > was set to 0, and we were doing a " rand() % num_pmus " to choose
 > a random value for the type field.

ah, gotcha. I'll queue up your patch.

thanks,

	Dave
