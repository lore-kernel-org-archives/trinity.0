From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 3/3] scripts: arch dependent to get the syscall_list
Date: Wed,  9 Oct 2013 12:56:26 +0200
Message-ID: <1381316186-8562-4-git-send-email-anders.roxell@linaro.org>
References: <1381316186-8562-1-git-send-email-anders.roxell@linaro.org>
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1381316186-8562-1-git-send-email-anders.roxell@linaro.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davej@redhat.com
Cc: trinity@vger.kernel.org, patches@linaro.org, Anders Roxell <anders.roxell@linaro.org>

ARCH may be changed in the enviroment

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 scripts/find.sh                           | 10 +++++++++-
 scripts/test-all-syscalls-parallel.sh     | 10 +++++++++-
 scripts/test-all-syscalls-sequentially.sh | 10 +++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/scripts/find.sh b/scripts/find.sh
index 3f10c58..717beb1 100755
--- a/scripts/find.sh
+++ b/scripts/find.sh
@@ -8,6 +8,14 @@
 TRINITY_PATH=${TRINITY_PATH:-.}
 TRINITY_TMP=$(mktemp -d /tmp/trinity.XXXXXX)
 
+if [ $ARCH = "arm" ]; then
+    $TRINITY_PATH/trinity -L | grep -v AVOID | \
+        awk '{ print $2 }' | sort -u> $TRINITY_TMP/syscall_list
+else
+    $TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | \
+        awk '{ print $4 }' | sort -u> $TRINITY_TMP/syscall_list
+fi
+
 check_tainted()
 {
     if [ "$(cat /proc/sys/kernel/tainted)" != $TAINT ]; then
@@ -27,7 +35,7 @@ while [ 1 ];
 do
 
 
-for sc in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+for sc in $(cat $TRINITY_TMP/syscall_list)
 do
   mkdir -p tmp.$i
   pushd tmp.$i
diff --git a/scripts/test-all-syscalls-parallel.sh b/scripts/test-all-syscalls-parallel.sh
index 312fd2a..e229702 100755
--- a/scripts/test-all-syscalls-parallel.sh
+++ b/scripts/test-all-syscalls-parallel.sh
@@ -3,12 +3,20 @@
 TRINITY_PATH=${TRINITY_PATH:-.}
 TRINITY_TMP=$(mktemp -d /tmp/trinity.XXXXXX)
 
+if [ $ARCH = "arm" ]; then
+    $TRINITY_PATH/trinity -L | grep -v AVOID | \
+        awk '{ print $2 }' | sort -u> $TRINITY_TMP/syscall_list
+else
+    $TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | \
+        awk '{ print $4 }' | sort -u> $TRINITY_TMP/syscall_list
+fi
+
 chmod 755 $TRINITY_TMP
 cd $TRINITY_TMP
 
 while [ 1 ];
 do
-  for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+  for syscall in $(cat $TRINITY_TMP/syscall_list)
   do
 	MALLOC_CHECK_=2 $TRINITY_PATH/trinity -q -c $syscall -D &
   done
diff --git a/scripts/test-all-syscalls-sequentially.sh b/scripts/test-all-syscalls-sequentially.sh
index 2b726fc..1b56a0c 100755
--- a/scripts/test-all-syscalls-sequentially.sh
+++ b/scripts/test-all-syscalls-sequentially.sh
@@ -6,6 +6,14 @@
 TRINITY_PATH=${TRINITY_PATH:-.}
 TRINITY_TMP=$(mktemp -d /tmp/trinity.XXXXXX)
 
+if [ $ARCH = "arm" ]; then
+    $TRINITY_PATH/trinity -L | grep -v AVOID | \
+        awk '{ print $2 }' | sort -u> $TRINITY_TMP/syscall_list
+else
+    $TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | \
+        awk '{ print $4 }' | sort -u> $TRINITY_TMP/syscall_list
+fi
+
 check_tainted()
 {
     if [ "$(cat /proc/sys/kernel/tainted)" != $TAINT ]; then
@@ -18,7 +26,7 @@ TAINT=$(cat /proc/sys/kernel/tainted)
 
 while [ 1 ]
 do
-for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+for syscall in $(cat $TRINITY_TMP/syscall_list)
 do
 	chmod 755 $TRINITY_TMP
 	pushd $TRINITY_TMP
-- 
1.8.1.2
