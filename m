From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 0/3] script enhancements
Date: Wed,  9 Oct 2013 12:56:23 +0200
Message-ID: <1381316186-8562-1-git-send-email-anders.roxell@linaro.org>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, patches@linaro.org, Anders Roxell <anders.roxell@linaro.org>

Hi,

Some small trinity patches to enhance the scripts.
Please have a look.

Cheers,
Anders

Anders Roxell (3):
  scripts: TRINITY_PATH defaults to "."
  scripts: change mkdir tmp to mktemp
  scripts: arch dependent to get the syscall_list

 scripts/analyse-dumps.sh                  |  4 +++-
 scripts/clean-cores.sh                    |  4 +++-
 scripts/find.sh                           | 26 +++++++++++++++++---------
 scripts/test-all-syscalls-parallel.sh     | 20 ++++++++++++++------
 scripts/test-all-syscalls-sequentially.sh | 25 ++++++++++++++++---------
 scripts/test-multi.sh                     | 18 +++++++++---------
 scripts/test-vm.sh                        | 12 ++++++------
 7 files changed, 68 insertions(+), 41 deletions(-)

-- 
1.8.1.2
