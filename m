From: Dave Jones <davej@redhat.com>
Subject: breakage on master.
Date: Tue, 3 Jun 2014 16:54:11 -0400
Message-ID: <20140603205411.GA32313@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

I just committed some code changing how logging works so that the
post-mortem dumping has a possibility of actually working.
It looks a lot closer to how I want it to be, but it does seem to have
a number of bugs right now which may take a couple days to nail down.

unless you're feeling brave, either stick with the 1.4 release,
or 8127f706044297d92c7448a075be51dff73d747a which was the last
'known good' commit before last nights carnage.

I hope to be on top of things in a day or two.

	Dave
