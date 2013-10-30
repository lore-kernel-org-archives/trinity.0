From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC 0/6] Allow to disable socket protocol families
Date: Wed, 30 Oct 2013 16:15:40 +0400
Message-ID: <1383135346-31463-1-git-send-email-gorcunov@openvz.org>
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=frvTjZvck9XuDiRMblOtx2vBGlJ/H1ghJlsw/VIrCW4=;
        b=YLYRtVv1mmUv3mqmdlehOsB7nOT57aqfuUKlxaOqFaMwGUf2c/XpOAkJBiPJmpDonF
         hfb5CbPkpyaUuIcXARLGYimq6JRQR5Xh4q2WYCxIi5PGApBjZbk7p8HMIRgVZPwDn7Ur
         beOW0IMQTge/+wagitWWn5ioa1VJFIdeawB4j/zfTT67xVy1FxI2mWvXO1AEfNSEW80w
         A3qDtL8Qewd2EyRbUbTtttAS+Uk31fnf0s5BOqbQ+AYeidFhAQqxzBDZbCIkWWQfetdn
         eH4mBRo8OGW3I38aR1u5BBS2kSFTUupIMFO6poBIcme5Hh9Gs8o0M87N7c1O6ZyPxDo/
         wjyA==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Vladimir Davydov <vdavydov@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>

When been testing the kernel with fresh trinity repo our admins
were unhappy about traffic which came from our testing nodes, so
here we add --no_proto option which allow a user to exclude
specified protocols from testing.

Please take a look, hope I don't miss something obvious.
Comments are highly appreciated!

Cyrill Gorcunov (6):
  log: Add BUG_ON helper
  net: protocols -- Use ARRAY_SIZE helper
  net: protocols -- Add lookup_proto helper
  net: protocols -- Move protocol function declarations to protocols.h
  params: Add --no_proto|-E option
  net: sockets -- Don't generate sockets with disabled protocol families

 include/log.h       |  2 ++
 include/net.h       |  2 --
 include/params.h    |  2 ++
 include/protocols.h |  9 +++++
 net/protocols.c     | 94 ++++++++++++++++++++++++++++++++++++++++-------------
 params.c            | 11 ++++++-
 sockets.c           | 27 ++++++++++++---
 syscalls/socket.c   | 36 ++++++++++++++++++--
 trinity.c           |  1 +
 9 files changed, 153 insertions(+), 31 deletions(-)
 create mode 100644 include/protocols.h

-- 
1.8.3.1
