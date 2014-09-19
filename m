From: Markos Chandras <markos.chandras@imgtec.com>
Subject: [PATCH 2/2] maps: Rename MAP_{GLOBAL, LOCAL} to TRINITY_MAP_{GLOBAL, LOCAL}
Date: Fri, 19 Sep 2014 15:11:55 +0100
Message-ID: <1411135915-26522-3-git-send-email-markos.chandras@imgtec.com>
References: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1411135915-26522-1-git-send-email-markos.chandras@imgtec.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Markos Chandras <markos.chandras@imgtec.com>

The MAP_LOCAL flag is actually a valid flag and some architectures
make use of it according to the mmap manpage. More specifically,
MIPS and Xtensa define the MAP_LOCAL flag in their userpsace mman.h
header leading to build problems like this:

In file included from syscalls/mprotect.c:6:0:
include/maps.h:8:0: error: "MAP_LOCAL" redefined [-Werror]
 #define MAP_LOCAL 2
 ^
In file included from syscalls/mprotect.c:4:0:
/toolchain/mips-linux-gnu/libc/usr/include/asm/mman.h:37:0:
note: this is the location of the previous definition
 #define MAP_LOCAL 0x080  /* Copy on fork/sproc */
 ^

Therefore, we rename the definitions in trinity to avoid conflicts
with the linux headers.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 include/maps.h  | 4 ++--
 maps-shared.c   | 2 +-
 maps.c          | 4 ++--
 syscalls/mmap.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/maps.h b/include/maps.h
index 37914ce5e32b..6bfd443eca5f 100644
--- a/include/maps.h
+++ b/include/maps.h
@@ -4,8 +4,8 @@
 
 extern char *page_rand;
 
-#define MAP_GLOBAL 1
-#define MAP_LOCAL 2
+#define TRINITY_MAP_GLOBAL 1
+#define TRINITY_MAP_LOCAL 2
 
 struct map {
 	struct list_head list;
diff --git a/maps-shared.c b/maps-shared.c
index 8e8218619120..57c13541b669 100644
--- a/maps-shared.c
+++ b/maps-shared.c
@@ -43,7 +43,7 @@ static void alloc_zero_map(unsigned long size, int prot, const char *name)
 	newnode->name = strdup(name);
 	newnode->size = size;
 	newnode->prot = prot;
-	newnode->type = MAP_GLOBAL;
+	newnode->type = TRINITY_MAP_GLOBAL;
 	newnode->ptr = mmap(NULL, size, prot, MAP_ANONYMOUS | MAP_SHARED, fd, 0);
 	if (newnode->ptr == MAP_FAILED) {
 		outputerr("mmap failure\n");
diff --git a/maps.c b/maps.c
index f2f1f5c67d12..3cf910ab34cd 100644
--- a/maps.c
+++ b/maps.c
@@ -65,10 +65,10 @@ static void delete_local_mapping(struct map *map)
 /* Called from munmap()'s ->post routine. */
 void delete_mapping(struct map *map)
 {
-	if (map->type == MAP_LOCAL)
+	if (map->type == TRINITY_MAP_LOCAL)
 		delete_local_mapping(map);
 
-	/* Right now, we don't want to delete MAP_GLOBAL mappings */
+	/* Right now, we don't want to delete TRINITY_MAP_GLOBAL mappings */
 }
 
 /* used in several sanitise_* functions. */
diff --git a/syscalls/mmap.c b/syscalls/mmap.c
index 4e1d9b0cabe5..1c342f44d6be 100644
--- a/syscalls/mmap.c
+++ b/syscalls/mmap.c
@@ -94,7 +94,7 @@ static void post_mmap(struct syscallrecord *rec)
 	new->prot = rec->a3;
 //TODO: store fd if !anon
 	new->ptr = p;
-	new->type = MAP_LOCAL;
+	new->type = TRINITY_MAP_LOCAL;
 
 	// Add this to a list for use by subsequent syscalls.
 	list = &this_child->mappings->list;
-- 
2.1.0
