From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 0/6] Some simple Coverity fixes
Date: Thu,  4 Jul 2013 22:55:38 +0300
Message-ID: <1372967744-29353-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

I registered trinity to Coverity scan and fixed a few simple looking findings.
Hopefully the leaks were not intentional. Some harder looking int64 range and
other bugs which had comments I don't dare to touch but maybe you should have
a quick look at the Coverity output anyway.

Tested these only shortly by running trinity as normal user.

Cheers,

Mikko Rapeli (6):
  trinity.c: fix uninitialized variable
  trinity.c: log errors if socket calls fail
  perf_event_open: initialize chars
  perf_event_open.c: close dir's on exit paths
  sockets.c: don't leak cachefile on return paths
  maps.c: only close() if fd is valid

 maps.c                     |  3 ++-
 sockets.c                  | 10 +++++++---
 syscalls/perf_event_open.c | 12 ++++++++++--
 trinity.c                  | 10 ++++++++--
 4 files changed, 27 insertions(+), 8 deletions(-)

-- 
1.8.3.1
