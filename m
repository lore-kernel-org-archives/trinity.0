From: Chris Murphy <lists@colorremedies.com>
Subject: Re: btrfs "possible irq lock inversion dependency detected"
Date: Mon, 17 Feb 2014 15:14:34 -0700
Message-ID: <4F3CC8F0-C37E-4448-AF65-796E643A301B@colorremedies.com>
References: <20140217200951.GB20312@optiplex>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Transfer-Encoding: 8BIT
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20140217200951.GB20312@optiplex>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, linux-kernel@vger.kernel.org


On Feb 17, 2014, at 1:09 PM, Tommi Rantala <tt.rantala@gmail.com> wrote:

> Hello,
> 
> Saw this while fuzzing the kernel with Trinity.
> 
> Tommi
> 
> 
> [  396.136048] =========================================================
> [  396.136048] [ INFO: possible irq lock inversion dependency detected ]
> [  396.136048] 3.14.0-rc3 #1 Not tainted
> [  396.136048] ---------------------------------------------------------
> [  396.136048] kswapd0/1482 just changed the state of lock:
> [  396.136048]  (&delayed_node->mutex){+.+.-.}, at: [<ffffffff8147b83b>] __btrfs_release_delayed_node+0x4b/0x1e0
> [  396.136048] but this lock took another, RECLAIM_FS-unsafe lock in the past:
> [  396.136048]  (&found->groups_sem){+++++.}

Looks like this is the same thing previously report on Btrfs list with 3.14.0-rc1 here:
https://bugzilla.redhat.com/show_bug.cgi?id=1062439

Which points to this:
https://bugzilla.redhat.com/show_bug.cgi?id=1062833#c24

Which points to this patch:
http://marc.info/?l=linux-netdev&m=139233546723342&q=raw


Chris Murphy