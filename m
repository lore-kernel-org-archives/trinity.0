From: Vince Weaver <vincent.weaver@maine.edu>
Subject: divide by zero in random/taviso()
Date: Fri, 17 Jan 2014 15:21:20 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1401171519070.6751@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hello

so for my perf_fuzzer I re-use the trinity random.c, and today I hit

[ 1241.026870] traps: perf_fuzzer[4509] trap divide error ip:40a779 

which maps to the taviso() routine which is doing:

           case 1: r = rand() % rand();
#if __WORDSIZE == 64
                r <<= 32;
                r |= rand() % rand();
#endif
                break;

which is a divide by zero if rand() returns 0.

Is there a good way to fix this short of a lot of special case checks?

Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
