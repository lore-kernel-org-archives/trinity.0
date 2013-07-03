From: Dave Jones <davej@redhat.com>
Subject: Expected 0x
Date: Wed, 3 Jul 2013 14:21:41 -0400
Message-ID: <20130703182141.GA13149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

Linus' current tree seems to trigger this in perf_event_open on startup:

                        if (value[ptr]!='0') fprintf(stderr,"Expected 0x\n");
                        ptr++;
                        if (value[ptr]!='x') fprintf(stderr,"Expected 0x\n");
                        ptr++;

I think it's from this..

/sys/bus/event_source/devices/cpu/events/mem-loads
event=0xcd,umask=0x1,ldlat=3

Looks like that field isn't always hex.

	Dave
