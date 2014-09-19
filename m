From: Markos Chandras <markos.chandras@imgtec.com>
Subject: [PATCH 0/2] Small MIPS fixes
Date: Fri, 19 Sep 2014 15:11:53 +0100
Message-ID: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Markos Chandras <markos.chandras@imgtec.com>

Hi,

A few fixes for trinity in order to improve the MIPS build. The first
one allows the user to pass extra cflags. The other one renames the
MAP_GLOBAL and MAP_LOCAL definitions in order to avoid conflicts
with the userspace linux headers.

Markos Chandras (2):
  configure.sh: Respect CFLAGS from the environment
  maps: Rename MAP_{GLOBAL, LOCAL} to TRINITY_MAP_{GLOBAL, LOCAL}

 configure.sh    | 4 ++--
 include/maps.h  | 4 ++--
 maps-shared.c   | 2 +-
 maps.c          | 4 ++--
 syscalls/mmap.c | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.1.0
