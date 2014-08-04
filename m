From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] trinity: add connection support for AF_INET and AF_INET6
Date: Mon, 4 Aug 2014 18:06:42 -0400
Message-ID: <20140804220642.GB15670@redhat.com>
References: <1407082590-17098-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407082590-17098-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Trinity <trinity@vger.kernel.org>, Daniel Borkmann <dborkman@redhat.com>

On Mon, Aug 04, 2014 at 12:16:30AM +0800, Hangbin Liu wrote:
 > Trinity is a syscall fuzz tool for local host testing. But it would also be
 > very useful to fuzz during established sessions over the network. This patch
 > add simple connection ability for IPv4/IPv6 so user can use it as a
 > client/server and simulate as a real environment.

Useful addition, something I've had at the back of my mind for a while
to revisit when I move back to the networking code, so I'm glad you got
there before I did :-)

Couple small things..

 > @@ -80,6 +83,8 @@ static void usage(void)
 >  	outputerr(" --syslog,-S: log important info to syslog. (useful if syslog is remote)\n");
 >  	outputerr(" --verbose,-v: increase output verbosity.\n");
 >  	outputerr(" --victims,-V: path to victim files.\n");
 > +	outputerr(" --server_addr: supply an IPv4 or IPv6 address to connect, no need for server side.\n");
 > +	outputerr(" --server_port: supply an server port to listen or connect, will fuzz between port to (port + 100)\n");
 >  	outputerr("\n");
 >  	outputerr(" -c#,@: target specific syscall (takes syscall name as parameter and optionally 32 or 64 as bit-width. Default:both).\n");
 >  	outputerr(" -N#: do # syscalls then exit.\n");

Please keep in alphabetical order.

 > @@ -113,13 +118,16 @@ static const struct option longopts[] = {
 >  	{ "syslog", no_argument, NULL, 'S' },
 >  	{ "verbose", no_argument, NULL, 'v' },
 >  	{ "victims", required_argument, NULL, 'V' },
 > +	{ "server_addr", required_argument, NULL, 0 },
 > +	{ "server_port", required_argument, NULL, 0 },
 >  	{ NULL, 0, NULL, 0 } };

and here too.

 > +		case 0:
 > +			/*
 > +			 * FIXME: It's really hard to find two reasonable short
 > +			 * names since S s P p all have been used. Use long
 > +			 * options before we fix this issue.
 > +			*/
 > +			if (strcmp("server_addr", longopts[opt_index].name) == 0)
 > +				strcpy(server_addr, optarg);
 > +			if (strcmp("server_port", longopts[opt_index].name) == 0)
 > +				server_port = atoi(optarg);
 > +			break;

Yeah, this kinda sucks, that we've burned through so many options
already. I wonder if it's getting to the point where a config file
parser would be a good addition instead of adding more parameters.

Another possibility.. part of me is disliking those 'server_port'
'server_addr' variables, so I was trying to think of something better,
but I didn't really get far other than wondering if perhaps we can
extend the -V/--victims option.

Hm, I'll think on it some more.

I've not done any review of the actual networking bits, but from a quick
skim, nothing jumped out at me.

thanks,

	Dave
