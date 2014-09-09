From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: f2fs get_dnode_of_data oops
Date: Mon, 8 Sep 2014 21:41:57 -0700
Message-ID: <20140909044157.GA24581@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
	<CA+ydwtrtyb5wQXCmyBigqufVz10UkKS76hVOY8mKc4FOyYmECw@mail.gmail.com>
	<20140908042056.GA13863@jaegeuk-mac02.hsd1.ca.comcast.net>
	<CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
List-Id: <trinity.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net

Hi Tommi,

This patch should resolve this bug.
Thanks a lot. :)

From ee24677b9917583f50f16b6f59771439f91b890c Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Mon, 8 Sep 2014 10:59:43 -0700
Subject: [PATCH] f2fs: fix negative value for lseek offset

If application throws negative value of lseek with SEEK_DATA|SEEK_HOLE,
previous f2fs went into BUG_ON in get_dnode_of_data, which was reported
by Tommi Rantala.

He could make a simple code to detect this having:
	lseek(fd, -17595150933902LL, SEEK_DATA);

This patch should resolve that bug.

Reported-by: Tommi Rentala <tt.rantala@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9f0ea3d..c9a1295 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -281,7 +281,7 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 	mutex_lock(&inode->i_mutex);
 
 	isize = i_size_read(inode);
-	if (offset >= isize)
+	if (offset >= isize || offset < 0)
 		goto fail;
 
 	/* handle inline data case */
-- 
1.8.5.2 (Apple Git-48)


------------------------------------------------------------------------------
Want excitement?
Manually upgrade your production database.
When you want reliability, choose Perforce.
Perforce version control. Predictably reliable.
http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
