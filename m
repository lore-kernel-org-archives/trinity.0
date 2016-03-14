From: Vinson Lee <vlee@freedesktop.org>
Subject: [PATCH] net/proto-ipv4.c: Include limits.h as a workaround for older kernels.
Date: Mon, 14 Mar 2016 16:54:15 -0700
Message-ID: <1457999655-28780-1-git-send-email-vlee@freedesktop.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: trinity@vger.kernel.org

=46or example, CentOS 6 kernel-headers-2.6.32-573.18.1.el6.x86_64
linux/netfilter_ipv4.h does not include limits.h and results in this
build error.

  CC	net/proto-ipv4.o
In file included from /usr/include/linux/netfilter_ipv4/ip_tables.h:20,
                 from net/proto-ipv4.c:12:
/usr/include/linux/netfilter_ipv4.h:53: error: =E2=80=98INT_MIN=E2=80=99=
 undeclared here (not in a function)
/usr/include/linux/netfilter_ipv4.h:64: error: =E2=80=98INT_MAX=E2=80=99=
 undeclared here (not in a function)

This was fixed in upstream 3.2 598aaff2ee05c91728e5845956dd9754ed04315c=
=2E

commit 598aaff2ee05c91728e5845956dd9754ed04315c
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Wed Aug 24 18:45:36 2011 +0000

    headers, netfilter: Add missing #include <limits.h> for userland

    Various headers use INT_MIN and INT_MAX, which are defined for
    userland in <limits.h>.

    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Acked-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 net/proto-ipv4.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
index 0be0263..be24d37 100644
--- a/net/proto-ipv4.c
+++ b/net/proto-ipv4.c
@@ -9,6 +9,7 @@
 #include <arpa/inet.h>
 #include <linux/mroute.h>
 #include <linux/if.h>
+#include <limits.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_arp/arp_tables.h>
--=20
1.7.1
