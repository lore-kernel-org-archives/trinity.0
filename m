From: Andi Shyti <andi@etezian.org>
Subject: [PATCH v3] ioctls: btrfs-control: fix header inclusion order
Date: Wed, 24 Jul 2013 12:31:05 +0200
Message-ID: <1374661865-6564-1-git-send-email-andi@etezian.org>
References: <CA+ydwtobNJMxn5r+jLQM3Pc8kY_swh1=pNw7dwEDhkGneC9r8g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CA+ydwtobNJMxn5r+jLQM3Pc8kY_swh1=pNw7dwEDhkGneC9r8g@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tt.rantala@gmail.com
Cc: trinity@vger.kernel.org, andi@etezian.org, mikko.rapeli@iki.fi

This patch enables newer linux/btrfs.h in Kernel headers 3.11,
where NULL is not recognized as a define. This is done by
including  stdlib.h before linux/btrfs.h. It gets rid of the
following compiling error:

In file included from ioctls/btrfs-control.c:5:0:
/usr/include/linux/btrfs.h: In function =E2=80=98btrfs_err_str=E2=80=99=
:
/usr/include/linux/btrfs.h:486:11: error: =E2=80=98NULL=E2=80=99 undecl=
ared (first use in
    return NULL;
           ^

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 ioctls/btrfs-control.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ioctls/btrfs-control.c b/ioctls/btrfs-control.c
index 35e5389..3b0b50a 100644
--- a/ioctls/btrfs-control.c
+++ b/ioctls/btrfs-control.c
@@ -2,6 +2,7 @@
=20
 #ifdef USE_BTRFS
=20
+#include <stdlib.h>
 #include <linux/btrfs.h>
=20
 #include "trinity.h"
--=20
1.8.3.2
