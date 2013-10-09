From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 1/3] scripts: TRINITY_PATH defaults to "."
Date: Wed,  9 Oct 2013 12:56:24 +0200
Message-ID: <1381316186-8562-2-git-send-email-anders.roxell@linaro.org>
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

TRINITY_PATH may be changed in the enviroment

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 scripts/analyse-dumps.sh                  | 4 +++-
 scripts/clean-cores.sh                    | 4 +++-
 scripts/find.sh                           | 8 +++++---
 scripts/test-all-syscalls-parallel.sh     | 6 ++++--
 scripts/test-all-syscalls-sequentially.sh | 8 +++++---
 scripts/test-multi.sh                     | 6 ++++--
 scripts/test-vm.sh                        | 4 +++-
 7 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/scripts/analyse-dumps.sh b/scripts/analyse-dumps.sh
index d55393c..bd45ea5 100755
--- a/scripts/analyse-dumps.sh
+++ b/scripts/analyse-dumps.sh
@@ -1,8 +1,10 @@
 #!/bin/sh
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 for core in $(find . -name "core.*")
 do
-  gdb -batch -n -ex 'bt' ./trinity $core > core.txt
+  gdb -batch -n -ex 'bt' $TRINITY_PATH/trinity $core > core.txt
   SHA=$(cat core.txt|  grep -v New\ LWP | sha1sum)
   cat core.txt > core-$SHA.txt
   rm -f core.txt
diff --git a/scripts/clean-cores.sh b/scripts/clean-cores.sh
index 821e06a..0b90be6 100755
--- a/scripts/clean-cores.sh
+++ b/scripts/clean-cores.sh
@@ -1,8 +1,10 @@
 #!/bin/sh
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 # remove old cores
 for i in `find . -name "core.*" -exec ls -l {} \; | grep -v "$(date +%b\ %e)" | awk '{ print $9 }'`; do rm -f $i; done
 
 # Remove corrupted cores
 find . -empty -name "core.*" -exec rm -f {} \;
-for i in $(file core.* | grep -v trinity | awk '{ print $1 }'  | sed 's/://'); do rm -f $i; done
+for i in $(file core.* | grep -v $TRINITY_PATH/trinity | awk '{ print $1 }'  | sed 's/://'); do rm -f $i; done
diff --git a/scripts/find.sh b/scripts/find.sh
index 537160f..5528210 100755
--- a/scripts/find.sh
+++ b/scripts/find.sh
@@ -5,6 +5,8 @@
 # sendmsg that only occurred after connect was called.
 #
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 check_tainted()
 {
     if [ "$(cat /proc/sys/kernel/tainted)" != $TAINT ]; then
@@ -27,18 +29,18 @@ while [ 1 ];
 do
 
 
-for sc in $(../trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+for sc in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
 do
   mkdir -p tmp.$i
   pushd tmp.$i
 
-  if [ ! -f ../../trinity ]; then
+  if [ ! -f $TRINITY_PATH/trinity ]; then
     echo lost!
     pwd
     exit
   fi
 
-  ../../trinity -q -l off -n -c sendmsg -c $sc -C32 -N 999999
+  $TRINITY_PATH/trinity -q -l off -n -c sendmsg -c $sc -C32 -N 999999
 
   popd
 
diff --git a/scripts/test-all-syscalls-parallel.sh b/scripts/test-all-syscalls-parallel.sh
index 861c156..c713cce 100755
--- a/scripts/test-all-syscalls-parallel.sh
+++ b/scripts/test-all-syscalls-parallel.sh
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 if [ ! -d tmp ]; then
   mkdir tmp
 fi
@@ -8,9 +10,9 @@ cd tmp
 
 while [ 1 ];
 do
-  for syscall in $(../trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+  for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
   do
-	MALLOC_CHECK_=2 ../trinity -q -c $syscall -D &
+	MALLOC_CHECK_=2 $TRINITY_PATH/trinity -q -c $syscall -D &
   done
   wait
 done
diff --git a/scripts/test-all-syscalls-sequentially.sh b/scripts/test-all-syscalls-sequentially.sh
index 85bcf71..6d79db4 100755
--- a/scripts/test-all-syscalls-sequentially.sh
+++ b/scripts/test-all-syscalls-sequentially.sh
@@ -3,6 +3,8 @@
 # This is a useful test to run occasionally, to see which syscalls are
 # causing trinity to segfault.
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 check_tainted()
 {
     if [ "$(cat /proc/sys/kernel/tainted)" != $TAINT ]; then
@@ -19,18 +21,18 @@ TAINT=$(cat /proc/sys/kernel/tainted)
 
 while [ 1 ]
 do
-for syscall in $(./trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
 do
 	chmod 755 tmp
 	pushd tmp
 
-	if [ ! -f ../trinity ]; then
+	if [ ! -f $TRINITY_PATH/trinity ]; then
 		echo lost!
 		pwd
 		exit
 	fi
 
-	MALLOC_CHECK_=2 ../trinity -q -c $syscall -N 99999 -l off -C 64
+	MALLOC_CHECK_=2 $TRINITY_PATH/trinity -q -c $syscall -N 99999 -l off -C 64
 	popd
 
 	check_tainted
diff --git a/scripts/test-multi.sh b/scripts/test-multi.sh
index 6fddeba..993e124 100755
--- a/scripts/test-multi.sh
+++ b/scripts/test-multi.sh
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 check_tainted()
 {
     if [ "$(cat /proc/sys/kernel/tainted)" != $TAINT ]; then
@@ -22,7 +24,7 @@ NR_PROCESSES=$(($NR_CPUS * 2))
 while [ 1 ];
 do
   rm -f trinity
-  cp ../trinity .
+  cp $TRINITY_PATH/trinity .
   chmod -w trinity
 
   for i in `seq 1 $NR_PROCESSES`
@@ -35,7 +37,7 @@ do
     mkdir -p tmp.$i
     pushd tmp.$i
 
-    if [ ! -f ../../trinity ]; then
+    if [ ! -f $TRINITY_PATH/trinity ]; then
       echo lost!
       pwd
       exit
diff --git a/scripts/test-vm.sh b/scripts/test-vm.sh
index 4c472ca..6b75e8d 100755
--- a/scripts/test-vm.sh
+++ b/scripts/test-vm.sh
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+TRINITY_PATH=${TRINITY_PATH:-.}
+
 if [ ! -d tmp ]; then
   mkdir tmp
 fi
@@ -16,7 +18,7 @@ do
   cd tmp.$RND
   for i in `seq 1 $NR_PROCESSES`
   do
-	../../trinity -q -g vm &
+	$TRINITY_PATH/trinity -q -g vm &
   done
   wait
   cd ..
-- 
1.8.1.2
