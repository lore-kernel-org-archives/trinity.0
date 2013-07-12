From: Vince Weaver <vincent.weaver@maine.edu>
Subject: rand64 change
Date: Fri, 12 Jul 2013 17:48:37 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307121746060.28314@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org


I noticed the following change.  The perf_event_open() syscall has various 
64-bit fields (that are 64-bit even on 32-bit machines) that I set with 
rand64().  Do I need to change something to get that to work?

Vince

commit c5bcbb108fe920851b853180849153ebcacb300a
Author: Dave Jones <davej@redhat.com>
Date:   Fri Jul 12 16:09:54 2013 -0400

    limit rand64 to 32bits when building on 32bit.
    
    I might later change this to make this function return u64 if necessary,
    but for now, the rand64() consumers on 32bit don't care because
    they work on ulongs.

