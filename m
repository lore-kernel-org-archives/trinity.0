From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/2] Small MIPS fixes
Date: Mon, 22 Sep 2014 09:37:57 -0400
Message-ID: <20140922133757.GA32379@redhat.com>
References: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markos Chandras <markos.chandras@imgtec.com>
Cc: trinity@vger.kernel.org

On Fri, Sep 19, 2014 at 03:11:53PM +0100, Markos Chandras wrote:
 > Hi,
 > 
 > A few fixes for trinity in order to improve the MIPS build. The first
 > one allows the user to pass extra cflags. The other one renames the
 > MAP_GLOBAL and MAP_LOCAL definitions in order to avoid conflicts
 > with the userspace linux headers.

both applied and pushed. Apologies for delay, vacation.

	Dave
