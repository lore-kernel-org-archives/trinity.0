From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Added parameter that controls which taint flag causes
 trinity to stop.
Date: Tue, 24 Sep 2013 12:15:19 -0400
Message-ID: <20130924161519.GA10098@redhat.com>
References: <alpine.DEB.2.02.1309231938120.18899@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309231938120.18899@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Mon, Sep 23, 2013 at 07:41:14PM -0700, Ildar Muslukhov wrote:
 > 
 > Hello Everyone,
 > 
 > This is reworked patch for the parameter that allows to control which 
 > kernel taint flags causes trinity to stop. In particular, now the short 
 > parameter is -T (instead of -t) and flags has to be specified as literals 
 > (e.g., DIE, WARN, USER, etc.). All 13 supported flags are specified in 
 > README.
 > 
 > Signed-off-by: Ildar Muslukhov <ildarm@google.com>
 
Applied. Watch out for your whitespace though..

$ git am ~/ildar
Applying: Added parameter that controls which taint flag causes trinity to stop.
/home/davej/src/git-trees/trinity/.git/rebase-apply/patch:158: indent with spaces.
                toggle_taint_flag(TAINT_FORCED_MODULE);
/home/davej/src/git-trees/trinity/.git/rebase-apply/patch:160: indent with spaces.
                toggle_taint_flag(TAINT_UNSAFE_SMP);
/home/davej/src/git-trees/trinity/.git/rebase-apply/patch:162: indent with spaces.
                toggle_taint_flag(TAINT_FORCED_RMMOD);
/home/davej/src/git-trees/trinity/.git/rebase-apply/patch:164: indent with spaces.
                toggle_taint_flag(TAINT_MACHINE_CHECK);
/home/davej/src/git-trees/trinity/.git/rebase-apply/patch:166: indent with spaces.
                toggle_taint_flag(TAINT_BAD_PAGE);
warning: squelched 7 whitespace errors
warning: 12 lines applied after fixing whitespace errors.


There's a commit hook that fixes things up when I commit them, but it's better
if I don't even see that spew when I apply diffs ;)

thanks,

	Dave
