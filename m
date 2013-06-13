From: Dave Jones <davej@redhat.com>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Thu, 13 Jun 2013 16:53:32 -0400
Message-ID: <20130613205332.GA5440@redhat.com>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu>
 <CA+ydwtr7eTOjtzWumr998TcxqhmX_M30aW99S=DF6mOwNURL=w@mail.gmail.com>
 <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Tommi Rantala <tt.rantala@gmail.com>, trinity@vger.kernel.org

On Thu, Jun 13, 2013 at 03:58:37PM -0400, Vince Weaver wrote:
 > On Thu, 13 Jun 2013, Tommi Rantala wrote:
 > 
 > > [221186.493638] traps: trinity-child30[375] trap divide error
 > > ip:40dbae sp:7fff3c1d7ae0 error:0 in trinity[400000+28000]
 > 
 > diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
 > index 32c11cf..11f49e8 100644
 > --- a/syscalls/perf_event_open.c
 > +++ b/syscalls/perf_event_open.c
 > @@ -406,6 +406,14 @@ static long long random_sysfs_config(__u32 *type, __u64 *config1) {
 >  	int i,j;
 >  	long long c=0,c1=0;
 >  
 > +	if (num_pmus==0) {
 > +		/* For some reason we didn't get initialized */
 > +		/* Fake it so we don't divide by zero        */
 > +		*type=rand32();
 > +		*config1=rand64();
 > +		return rand64();
 > +	}

Probably safer ?

+               *type = rand32() | 1;
+               *config1 = rand64() | 1;
+               return rand64() | 1;

	Dave
