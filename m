From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] convert syscall time tracking to CLOCK_MONOTONIC
Date: Tue, 29 Dec 2015 19:56:58 -0500
Message-ID: <20151230005658.GA29719@codemonkey.org.uk>
References: <1451432172-70916-1-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451432172-70916-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: trinity@vger.kernel.org

On Wed, Dec 30, 2015 at 02:36:12AM +0300, Kirill A. Shutemov wrote:
 > Commit e8646038d918 ("add some extra sanity checks inside the child
 > process") made trinity near unusable for me: the rec->tv sanity check
 > fails rather quickly after first syscall capable of changing wall time.

interesting. I wonder why I didn't notice that.

applied anyway, thanks.

	Dave
