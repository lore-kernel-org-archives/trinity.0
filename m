From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCHv2 3/3] tables.c: change the output format of -L
Date: Thu, 10 Oct 2013 13:20:23 -0400
Message-ID: <20131010172023.GA1231@redhat.com>
References: <1381316186-8562-1-git-send-email-anders.roxell@linaro.org>
 <1381394475-24803-1-git-send-email-anders.roxell@linaro.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381394475-24803-1-git-send-email-anders.roxell@linaro.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anders Roxell <anders.roxell@linaro.org>
Cc: trinity@vger.kernel.org, patches@linaro.org

On Thu, Oct 10, 2013 at 10:41:15AM +0200, Anders Roxell wrote:
 > So the scripts can works for both biarch and !biarch
 > 
 > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
 > ---
 >  scripts/find.sh                           |  2 +-
 >  scripts/test-all-syscalls-parallel.sh     |  2 +-
 >  scripts/test-all-syscalls-sequentially.sh |  2 +-
 >  tables.c                                  | 10 +++++-----
 >  4 files changed, 8 insertions(+), 8 deletions(-)

applied, with some tweaks to fit on top of Ildar's recent output() changes.

thanks,

	Dave
