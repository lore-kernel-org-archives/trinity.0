From: Dave Jones <davej@codemonkey.org.uk>
Subject: Trinity 1.8
Date: Fri, 3 Nov 2017 11:24:39 -0400
Message-ID: <20171103152439.aohhnsucuba7lu76@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

For those still using tarball releases, I just cut a 1.8 release and put
the result at http://codemonkey.org.uk/projects/trinity/trinity-1.8.tar.xz

As well as all the usual improvements like updates to syscalls, flags
etc, the biggest feature this release is the still-work-in-progress "log to udp"
I hacked this up earlier this year, and it's still in proof of concept
phase, but if you want to play with that there's a rough server
implementation in the server/ directory. The protocol is pretty well
defined, but it has a bunch of known flaws that need improving on,
such as the general reliability (udp is lossy, who knew?)

Until that gets better the log-to-disk code still exists, and now also supports
just giving it a directory name rather than have them land in trinity's cwd.

go forth and break kernels.

	Dave
