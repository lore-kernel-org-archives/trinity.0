From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH v2] Fix build on older kernels without BPF.
Date: Fri, 5 Aug 2016 14:44:17 -0400
Message-ID: <20160805184417.fzsazloft5lkjwds@codemonkey.org.uk>
References: <20160712190217.GA5525@codemonkey.org.uk>
 <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
 <20160721201048.GA9384@codemonkey.org.uk>
 <CACKvgLE23r+RGDWhp3D0z9_gnbWCXJS45=mZGV+o6L3pZ=Ypkw@mail.gmail.com>
 <20160726005929.GA17542@codemonkey.org.uk>
 <20160804203606.gpulsvdyjr5mvzq3@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160804203606.gpulsvdyjr5mvzq3@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Thu, Aug 04, 2016 at 04:36:06PM -0400, Dave Jones wrote:

 >  > We might segv somewhere else after patching this up. It's been so long since
 >  > I touched this stuff I don't fully recall how it works.  I'll poke at it
 >  > some tomorrow.
 >  
 > Just getting around to this. It's a bit more involved than I hoped.
 > Spraying a bunch of null checks around like this seems to be the thing to do..

Now committed and pushed out, with an additional typo fix.

	Dave
