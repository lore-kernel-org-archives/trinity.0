From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Expected 0x
Date: Wed, 3 Jul 2013 23:19:27 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307032316420.13409@vincent-weaver-1.um.maine.edu>
References: <20130703182141.GA13149@redhat.com> <alpine.DEB.2.10.1307031701440.14644@vincent-weaver-1.um.maine.edu> <20130703212941.GA26512@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130703212941.GA26512@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, 3 Jul 2013, Dave Jones wrote:

> btw, here's something curious that llvm finds when you build trinity with clang.
> I'm not sure if this is a real problem, or a bug in the compiler, but you
> might want to take a look anyway:
> 
> syscalls/perf_event_open.c:66:19: warning: Assigned value is garbage or undefined
>                 format_string[i]=string[i];
>                                 ^~~~~~~~~~
> syscalls/perf_event_open.c:159:12: warning: Assigned value is garbage or undefined
>                         field[i]=value[ptr];
>                                 ^~~~~~~~~~~
> 
> In case you're not setup for llvm, I've put the decision trees it generated at
> http://codemonkey.org.uk/junk/1.html
> http://codemonkey.org.uk/junk/2.html

I'll see if I can figure out llvm, I've been wanting an excuse to look 
into it.

The values that it is complaining about are gathered via a fscanf followed 
by a strdup, so in theory if the fscanf fails (due to the file being 
empty) or if strdup() fails (due to OOM) it is indeed possible the string 
is garbage.  I can add handling for those conditions to see if it helps.

Vince
