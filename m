From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCHv2 3/3] tables.c: change the output format of -L
Date: Thu, 10 Oct 2013 10:41:15 +0200
Message-ID: <1381394475-24803-1-git-send-email-anders.roxell@linaro.org>
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

So the scripts can works for both biarch and !biarch

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 scripts/find.sh                           |  2 +-
 scripts/test-all-syscalls-parallel.sh     |  2 +-
 scripts/test-all-syscalls-sequentially.sh |  2 +-
 tables.c                                  | 10 +++++-----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/find.sh b/scripts/find.sh
index 3f10c58..4c970c1 100755
--- a/scripts/find.sh
+++ b/scripts/find.sh
@@ -27,7 +27,7 @@ while [ 1 ];
 do
 
 
-for sc in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+for sc in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $3 }' | sort -u)
 do
   mkdir -p tmp.$i
   pushd tmp.$i
diff --git a/scripts/test-all-syscalls-parallel.sh b/scripts/test-all-syscalls-parallel.sh
index 312fd2a..7206364 100755
--- a/scripts/test-all-syscalls-parallel.sh
+++ b/scripts/test-all-syscalls-parallel.sh
@@ -8,7 +8,7 @@ cd $TRINITY_TMP
 
 while [ 1 ];
 do
-  for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+  for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $3 }' | sort -u)
   do
 	MALLOC_CHECK_=2 $TRINITY_PATH/trinity -q -c $syscall -D &
   done
diff --git a/scripts/test-all-syscalls-sequentially.sh b/scripts/test-all-syscalls-sequentially.sh
index 2b726fc..14fb4c3 100755
--- a/scripts/test-all-syscalls-sequentially.sh
+++ b/scripts/test-all-syscalls-sequentially.sh
@@ -18,7 +18,7 @@ TAINT=$(cat /proc/sys/kernel/tainted)
 
 while [ 1 ]
 do
-for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $4 }' | sort -u)
+for syscall in $($TRINITY_PATH/trinity -L | grep entrypoint | grep -v AVOID | awk '{ print $3 }' | sort -u)
 do
 	chmod 755 $TRINITY_TMP
 	pushd $TRINITY_TMP
diff --git a/tables.c b/tables.c
index 618d742..b5c06fa 100644
--- a/tables.c
+++ b/tables.c
@@ -527,18 +527,18 @@ void dump_syscall_tables(void)
 	unsigned int i;
 
 	if (biarch == TRUE) {
-		printf("32-bit syscalls: %d\n", max_nr_32bit_syscalls);
-		printf("64-bit syscalls: %d\n", max_nr_64bit_syscalls);
+		printf("syscalls: %d [32-bit] \n", max_nr_32bit_syscalls);
+		printf("syscalls: %d [64-bit] \n", max_nr_64bit_syscalls);
 
 		for_each_32bit_syscall(i) {
-			printf("32-bit entrypoint %d %s : ", syscalls_32bit[i].entry->number, syscalls_32bit[i].entry->name);
+			printf("entrypoint %d %s : [32-bit] ", syscalls_32bit[i].entry->number, syscalls_32bit[i].entry->name);
 			show_state(syscalls_32bit[i].entry->flags & ACTIVE);
 			if (syscalls_32bit[i].entry->flags & AVOID_SYSCALL)
 				printf(" AVOID");
 			printf("\n");
 		}
 		for_each_64bit_syscall(i) {
-			printf("64-bit entrypoint %d %s : ", syscalls_64bit[i].entry->number, syscalls_64bit[i].entry->name);
+			printf("entrypoint %d %s : [64-bit] ", syscalls_64bit[i].entry->number, syscalls_64bit[i].entry->name);
 			show_state(syscalls_64bit[i].entry->flags & ACTIVE);
 			if (syscalls_64bit[i].entry->flags & AVOID_SYSCALL)
 				printf(" AVOID");
@@ -547,7 +547,7 @@ void dump_syscall_tables(void)
 	} else {
 		printf("syscalls: %d\n", max_nr_syscalls);
 		for_each_syscall(i) {
-			printf("%d %s : ", syscalls[i].entry->number, syscalls[i].entry->name);
+			printf("entrypoint %d %s : ", syscalls[i].entry->number, syscalls[i].entry->name);
 			show_state(syscalls[i].entry->flags & ACTIVE);
 			if (syscalls[i].entry->flags & AVOID_SYSCALL)
 				printf(" AVOID");
-- 
1.8.1.2
