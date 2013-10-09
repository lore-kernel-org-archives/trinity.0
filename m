From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 3/3] scripts: arch dependent to get the syscall_list
Date: Wed, 9 Oct 2013 12:41:26 -0400
Message-ID: <20131009164126.GD2821@redhat.com>
References: <1381316186-8562-1-git-send-email-anders.roxell@linaro.org>
 <1381316186-8562-4-git-send-email-anders.roxell@linaro.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381316186-8562-4-git-send-email-anders.roxell@linaro.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anders Roxell <anders.roxell@linaro.org>
Cc: trinity@vger.kernel.org, patches@linaro.org

On Wed, Oct 09, 2013 at 12:56:26PM +0200, Anders Roxell wrote:
 > ARCH may be changed in the enviroment
 > 
 > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
 > ---
 >  scripts/find.sh                           | 10 +++++++++-
 >  scripts/test-all-syscalls-parallel.sh     | 10 +++++++++-
 >  scripts/test-all-syscalls-sequentially.sh | 10 +++++++++-
 >  3 files changed, 27 insertions(+), 3 deletions(-)
 > 
 > diff --git a/scripts/find.sh b/scripts/find.sh
 > index 3f10c58..717beb1 100755
 > --- a/scripts/find.sh
 > +++ b/scripts/find.sh
 > @@ -8,6 +8,14 @@
 >  TRINITY_PATH=${TRINITY_PATH:-.}
 >  TRINITY_TMP=$(mktemp -d /tmp/trinity.XXXXXX)
 >  
 > +if [ $ARCH = "arm" ]; then
 > +    $TRINITY_PATH/trinity -L | grep -v AVOID | \
 > +        awk '{ print $2 }' | sort -u> $TRINITY_TMP/syscall_list
 > +else
 > +    $TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | \
 > +        awk '{ print $4 }' | sort -u> $TRINITY_TMP/syscall_list
 > +fi
 
Ugh. How about we just change the format of the output of -L so it's
more similar on both uniarch and biarch ?

Changing to to be..

on biarch=true:

entrypoint 0 restart_syscall [32-bit] : Enabled AVOID
entrypoint 1 exit [32-bit] : Enabled AVOID
..
entrypoint 312 kcmp [64-bit]
entrypoint 313 finit_module [64-bit]


And then the !biarch case would just lack the *-bit tags, allowing the awk to
pluck out column 2 regardless of arch.

Does that sound better ?

	Dave
