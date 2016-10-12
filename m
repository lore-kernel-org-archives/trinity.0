From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [BUG] invalid open call: O_CREAT or O_TMPFILE without mode
Date: Wed, 12 Oct 2016 15:28:04 -0400
Message-ID: <20161012192804.vc4jwo65dqdoewma@codemonkey.org.uk>
References: <20161012183216.GB32045@pdxjohnny>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161012183216.GB32045@pdxjohnny>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Andersen, John" <john.s.andersen@intel.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 12, 2016 at 11:32:16AM -0700, Andersen, John wrote:
 > Log attached. When I tried to fuzz devices in /dev. Hoping to fuzz an ioctl.
 > Trinity gets killed and displays the message seen in the subject.
 > 
 > 'invalid open call: O_CREAT or O_TMPFILE without mode'
 > 
 > I am running on Android which may have something / everything to do with this.
 > I just wanted to see if anyone has experienced this issue before. Otherwise
 > some pointers on where I might start looking to make a patch would be
 > appreciated.
 
I think this might be something that was fixed post 1.6.  Let me know if
it still happens with the version in git.

https://github.com/kernelslacker/trinity/commit/08bcce0b86046dc150d3100a77152dff7d19083c
should be the commit that fixed it.

I'll be doing a 1.7 tarball in a few weeks, there's been enough stuff
like this accumulated, along with all the new features.  Just need to
fix a handful of small problems.

	Dave
