From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: f2fs get_dnode_of_data oops
Date: Mon, 8 Sep 2014 18:39:17 +0300
Message-ID: <CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
References: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
	<CA+ydwtrtyb5wQXCmyBigqufVz10UkKS76hVOY8mKc4FOyYmECw@mail.gmail.com>
	<20140908042056.GA13863@jaegeuk-mac02.hsd1.ca.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20140908042056.GA13863@jaegeuk-mac02.hsd1.ca.comcast.net>
List-Id: <trinity.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net

2014-09-08 7:20 GMT+03:00 Jaegeuk Kim <jaegeuk@kernel.org>:
> Hi,
>
> Thank you for the report.
> Could you share a little bit more information about the file accessing
> f2fs_llseek?
> E.g., file size, file offset, file allocation information, or dump of that file.

Hi,

I can reproduce the bug with the following.
-17595150933902 is just something I saw trinity passing to lseek().

#define _GNU_SOURCE

#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char **argv)
{
        int fd;

        if (argc < 2) {
                printf("give filename\n");
                return 1;
        }

        fd = open(argv[1], O_RDONLY);
        if (fd < 0) {
                perror("open");
                return 1;
        }

        lseek(fd, -17595150933902LL, SEEK_DATA);

        return 0;
}

{ttrantal@arkki ~}> touch /f2fs/x ; ./a.out /f2fs/x
[   73.437182] BUG: unable to handle kernel paging request at ffff88043368e340
[   73.438035] IP: [<ffffffff817792d9>] get_dnode_of_data+0x3a9/0x440
[   73.438035] PGD 4595067 PUD 0
[   73.438035] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   73.438035] CPU: 0 PID: 2933 Comm: a.out Not tainted 3.17.0-rc4+ #37
[   73.438035] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   73.438035] task: ffff88003755cac0 ti: ffff880022734000 task.ti:
ffff880022734000
[   73.438035] RIP: 0010:[<ffffffff817792d9>]  [<ffffffff817792d9>]
get_dnode_of_data+0x3a9/0x440
[   73.438035] RSP: 0018:ffff880022737e08  EFLAGS: 00010246
[   73.438035] RAX: ffff880033951000 RBX: 000000000000010b RCX: 00000000fff4f476
[   73.438035] RDX: ffff880033951168 RSI: 000000111932488f RDI: ffff880022737ef0
[   73.438035] RBP: ffff880022737eb8 R08: 0000000000000148 R09: 0000000000000000
[   73.438035] R10: 0000000000008b86 R11: 0000000000000001 R12: fffffffefff4f476
[   73.438035] R13: 0000000000000000 R14: ffffea0000ce5440 R15: ffff880021c28000
[   73.438035] FS:  00007fefc2f08700(0000) GS:ffff88003fa00000(0000)
knlGS:0000000000000000
[   73.438035] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   73.438035] CR2: ffff88043368e340 CR3: 0000000032d6b000 CR4: 00000000000006f0
[   73.438035] Stack:
[   73.438035]  ffff880022737ef0 ffffffff81228d7c ffff88003d9fe7b0
ffff880022737eb8
[   73.438035]  ffffffff81763164 00000002ffffffff 0000000000000000
00000000fff4f476
[   73.438035]  0000000000000246 ffffffff00000000 ffffffff8259bd47
ffffffff0000010b
[   73.438035] Call Trace:
[   73.438035]  [<ffffffff81228d7c>] ? pagevec_lookup_tag+0x1c/0x30
[   73.438035]  [<ffffffff81763164>] ? __get_first_dirty_index+0x44/0x90
[   73.438035]  [<ffffffff8259bd47>] ? _raw_spin_unlock_irq+0x27/0x40
[   73.438035]  [<ffffffff81189e75>] ? trace_hardirqs_on_caller+0x185/0x220
[   73.438035]  [<ffffffff817636b7>] f2fs_llseek+0xf7/0x420
[   73.438035]  [<ffffffff8127e735>] SyS_lseek+0x65/0xa0
[   73.438035]  [<ffffffff8259caa9>] system_call_fastpath+0x16/0x1b
[   73.438035] Code: ba 00 00 00 00 00 88 ff ff 48 c1 f8 06 48 c1 e0
0c 48 01 d0 8b 98 ec 0f 00 00 39 98 e8 0f 00 00 48 8d 90 68 01 00 00
48 0f 45 d0 <8b> 04 8a 89 47 24 31 c0 eb 75 41 bc e4 ff ff ff 4d 85 f6
74 19
[   73.438035] RIP  [<ffffffff817792d9>] get_dnode_of_data+0x3a9/0x440
[   73.438035]  RSP <ffff880022737e08>
[   73.438035] CR2: ffff88043368e340
[   73.438035] ---[ end trace e94f7065a7961f54 ]---

------------------------------------------------------------------------------
Want excitement?
Manually upgrade your production database.
When you want reliability, choose Perforce
Perforce version control. Predictably reliable.
http://pubads.g.doubleclick.net/gampad/clk?id=157508191&iu=/4140/ostg.clktrk
