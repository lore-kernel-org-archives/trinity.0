From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH 0/4] Enable seccomp generator and use Boehm-Demers-Weiser GC
Date: Mon,  3 Jun 2013 21:07:40 +0200
Message-ID: <cover.1370285968.git.dborkman@redhat.com>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, davej@redhat.com, dborkman@redhat.com

Applied Tommi's feedback in patch 4 and rebased on top of current
master, rest is unchanged.

Daniel Borkmann (4):
  net: bpf: let clang shut up
  minor: move offsetof into trinity.h
  prctl: enable seccomp generator invocation
  trinity: use Boehm-Demers-Weiser's garbage collecting memory allocator

 Makefile              |  4 +++-
 child.c               |  3 +++
 devices.c             | 21 +++++++++---------
 files.c               |  8 +++----
 include/sanitise.h    |  2 +-
 include/trinity.h     | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++
 log.c                 |  6 ++++--
 main.c                |  2 ++
 maps.c                | 20 ++++++++---------
 net/alg.c             |  4 +++-
 net/appletalk.c       |  4 +++-
 net/atm.c             |  6 ++++--
 net/ax25.c            |  4 +++-
 net/bpf.c             | 20 ++++++++---------
 net/caif.c            |  4 +++-
 net/can.c             |  5 ++++-
 net/decnet.c          |  4 +++-
 net/econet.c          |  4 +++-
 net/ipv4.c            |  4 +++-
 net/ipv6.c            |  4 +++-
 net/ipx.c             |  4 +++-
 net/irda.c            |  4 +++-
 net/llc.c             |  4 +++-
 net/netlink.c         |  4 +++-
 net/nfc.c             |  4 +++-
 net/packet.c          |  4 +++-
 net/phonet.c          |  4 +++-
 net/pppox.c           | 12 ++++++-----
 net/rose.c            |  4 +++-
 net/tipc.c            |  5 ++++-
 net/unix.c            |  4 +++-
 net/x25.c             |  4 +++-
 params.c              |  2 +-
 random-address.c      |  6 +++---
 random-syscalls.c     |  7 +++++-
 syscalls/execve.c     |  5 +++--
 syscalls/modify_ldt.c |  6 +++---
 syscalls/move_pages.c | 16 ++++++--------
 syscalls/prctl.c      | 43 +++++++++++++++++++++++++++++++++++++
 syscalls/sendmsg.c    |  4 +++-
 syscalls/shmget.c     |  8 +++++--
 syscalls/socketcall.c |  6 +++++-
 tables.c              |  6 +++---
 trinity.c             |  2 ++
 unicode.c             |  2 +-
 45 files changed, 266 insertions(+), 92 deletions(-)

-- 
1.7.11.7
