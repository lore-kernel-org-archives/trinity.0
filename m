From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] f2fs get_dnode_of_data oops
Date: Wed, 10 Sep 2014 00:23:44 -0700
Message-ID: <20140910072344.GB9242@jaegeuk-mac02.mot-mobility.com>
References: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
 <CA+ydwtrtyb5wQXCmyBigqufVz10UkKS76hVOY8mKc4FOyYmECw@mail.gmail.com>
 <20140908042056.GA13863@jaegeuk-mac02.hsd1.ca.comcast.net>
 <CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
 <20140909044157.GA24581@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003301cfcc05$95bfc6f0$c13f54d0$@samsung.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <003301cfcc05$95bfc6f0$c13f54d0$@samsung.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chao Yu <chao2.yu@samsung.com>
Cc: 'Tommi Rantala' <tt.rantala@gmail.com>, 'Dave Jones' <davej@redhat.com>, trinity@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net

On Tue, Sep 09, 2014 at 04:10:00PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> Looks good to me!
> 
> One nitpick, how about judging this condition before we lock ->i_mutex to
> avoid unneeded lock contention and invoking of i_size_read()?

Agreed.

From 0b4c5afde9b57c08b55d26725d228d5314cfc57a Mon Sep 17 00:00:00 2001
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
[Jaegeuk Kim: relocate the condition as suggested by Chao]
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9f0ea3d..5cde363 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -353,6 +353,8 @@ static loff_t f2fs_llseek(struct file *file, loff_t offset, int whence)
 						maxbytes, i_size_read(inode));
 	case SEEK_DATA:
 	case SEEK_HOLE:
+		if (offset < 0)
+			return -ENXIO;
 		return f2fs_seek_block(file, offset, whence);
 	}
 
-- 
1.8.5.2 (Apple Git-48)

