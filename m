From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] add parameter to explicitly select 32 or 64 bit variant
 of syscalls
Date: Mon, 16 Sep 2013 14:14:05 -0400
Message-ID: <20130916181405.GA13688@redhat.com>
References: <52339222.2090403@google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52339222.2090403@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Fri, Sep 13, 2013 at 03:30:58PM -0700, Ildar Muslukhov wrote:
 > This patch enables explicit selection of 32 or 64 bit version of 
 > syscall(s) via parameter.

This version gets the tab/spacing right, but is word-wrapped..

 
 > @@ -60,8 +63,9 @@ static void usage(void)
 >   	fprintf(stderr, " --syslog,-S: log important info to syslog. (useful 
 > if syslog is remote)\n");
 >   	fprintf(stderr, " --verbose,-v: increase output verbosity.\n");
 >   	fprintf(stderr, " --victims,-V: path to victim files.\n");
 > +	fprintf(stderr, " --arch, -a: selects syscalls for the specified 
 > architecture (32 or 64). Both by default.");
 >   	fprintf(stderr, "\n");
 > -	fprintf(stderr, " -c#: target specific syscall (takes syscall name as 
 > parameter).\n");
 > +	fprintf(stderr, " -c#,@: target specific syscall (takes syscall name 
 > as parameter and @ as architecture. No @ defaults to both archs.).\n");
 >   	fprintf(stderr, " -N#: do # syscalls then exit.\n");
 >   	fprintf(stderr, " -p:  pause after syscall.\n");
 >   	fprintf(stderr, " -s#: use # as random seed.\n");
 > @@ -86,6 +90,7 @@ static const struct option longopts[] = {
 >   	{ "syslog", no_argument, NULL, 'S' },
 >   	{ "victims", required_argument, NULL, 'V' },
 >   	{ "verbose", no_argument, NULL, 'v' },
 > +	{ "arch", required_argument, NULL, 'a' },
 >   	{ NULL, 0, NULL, 0 } };

So I can't apply this.

	Dave
