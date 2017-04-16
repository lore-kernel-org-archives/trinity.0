From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] fix off-by-one in dump_childnos()
Date: Sun, 16 Apr 2017 14:34:31 -0400
Message-ID: <20170416183431.axmhqtnea3ebjiek@codemonkey.org.uk>
References: <20170416182914.24457-1-tt.rantala@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170416182914.24457-1-tt.rantala@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: trinity@vger.kernel.org

On Sun, Apr 16, 2017 at 09:29:14PM +0300, Tommi Rantala wrote:
 > Fixes a segfault:
 > 
 >   ## pids: (60 active)
 >   0-7: 0 0 0 0 0 0 0 0
 >   8-15: 0 0 0 0 0 0 0 0
 >   16-23: 0 0 0 0 0 0 0 0
 >   24-31: 0 0 0 0 0 0 0 0
 >   32-39: 0 11081 11082 11083 11084 11085 11086 11087
 >   40-47: 11088 11089 11090 11091 11093 11094 11095 11096
 >   48-55: 11097 11098 11099 11100 11101 11102 0 0
 >   Segmentation fault

Applied.  If you're seeing that though, that's indicative of a bigger
problem (that we corrupted the pid table, or lost track of a child proc.).
I've not seen that happen in about a year, does it happen often for you?

	Dave
