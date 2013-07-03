From: Dave Jones <davej@redhat.com>
Subject: Re: Expected 0x
Date: Wed, 3 Jul 2013 17:29:41 -0400
Message-ID: <20130703212941.GA26512@redhat.com>
References: <20130703182141.GA13149@redhat.com>
 <alpine.DEB.2.10.1307031701440.14644@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307031701440.14644@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Wed, Jul 03, 2013 at 05:07:38PM -0400, Vince Weaver wrote:
 > 
 > The following patch should properly handle decimal values in
 >    /sys/bus/event_source/devices/cpu/events/
 > files.

applied and pushed. thanks.

 > Feel free to run lindent on the whole perf_event_open.c sometime.

maybe next week ;)

btw, here's something curious that llvm finds when you build trinity with clang.
I'm not sure if this is a real problem, or a bug in the compiler, but you
might want to take a look anyway:

syscalls/perf_event_open.c:66:19: warning: Assigned value is garbage or undefined
                format_string[i]=string[i];
                                ^~~~~~~~~~
syscalls/perf_event_open.c:159:12: warning: Assigned value is garbage or undefined
                        field[i]=value[ptr];
                                ^~~~~~~~~~~

In case you're not setup for llvm, I've put the decision trees it generated at
http://codemonkey.org.uk/junk/1.html
http://codemonkey.org.uk/junk/2.html

It may be that some of those combinations it took will never happen, but
I'd like to know for sure. (and if possible somehow silence the warnings
as long as it doesn't ugly stuff up too much)

	Dave
