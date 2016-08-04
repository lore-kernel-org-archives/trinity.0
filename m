From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH v2] Fix build on older kernels without BPF.
Date: Thu, 4 Aug 2016 16:36:06 -0400
Message-ID: <20160804203606.gpulsvdyjr5mvzq3@codemonkey.org.uk>
References: <20160712190217.GA5525@codemonkey.org.uk>
 <1468359236-6940-1-git-send-email-vlee@freedesktop.org>
 <20160721201048.GA9384@codemonkey.org.uk>
 <CACKvgLE23r+RGDWhp3D0z9_gnbWCXJS45=mZGV+o6L3pZ=Ypkw@mail.gmail.com>
 <20160726005929.GA17542@codemonkey.org.uk>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160726005929.GA17542@codemonkey.org.uk>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vinson Lee <vlee@freedesktop.org>
Cc: trinity@vger.kernel.org

On Mon, Jul 25, 2016 at 08:59:29PM -0400, Dave Jones wrote:


 >  > tables.c
 >  >    470  static struct syscalltable * copy_syscall_table(struct
 >  > syscalltable *from, unsigned int nr)
 >  >    471  {
 >  >    472          unsigned int n;
 >  >    473          struct syscallentry *copy;
 >  >    474
 >  >    475          copy = alloc_shared(nr * sizeof(struct syscallentry));
 >  >    476          if (copy == NULL)
 >  >    477                  exit(EXIT_FAILURE);
 >  >    478
 >  >    479          for (n = 0; n < nr; n++) {
 >  >    480                  memcpy(copy + n , from[n].entry, sizeof(struct
 >  > syscallentry));
 >  >    481                  copy[n].number = n;
 >  >    482                  copy[n].active_number = 0;
 >  >    483                  from[n].entry = &copy[n];
 >  >    484          }
 >  >    485          return from;
 >  >    486  }
 > 
 > 
 > stick a 
 > 		if (from[n] == NULL)
 > 			continue
 > 
 > before the memcpy. Does that dtrt ?
 > 
 > We might segv somewhere else after patching this up. It's been so long since
 > I touched this stuff I don't fully recall how it works.  I'll poke at it
 > some tomorrow.
 
Just getting around to this. It's a bit more involved than I hoped.
Spraying a bunch of null checks around like this seems to be the thing to do..

Let me know how this works out for you.

	Dave



diff --git a/configure b/configure
index 8d959298f129..93cf19c5861c 100755
--- a/configure
+++ b/configure
@@ -239,6 +239,7 @@ check_header execinfo.h USE_BACKTRACE
 check_header netatalk/at.h USE_APPLETALK
 check_header netrom/netrom.h USE_NETROM
 check_header netrose/rose.h USE_ROSE
+check_header linux/bfp.h USE_BPFF
 
 rm -f "$TMP" "$TMP.log" "$TMP.c"
 
diff --git a/include/syscalls-aarch64.h b/include/syscalls-aarch64.h
index 09acf418a12e..fda0814128bc 100644
--- a/include/syscalls-aarch64.h
+++ b/include/syscalls-aarch64.h
@@ -290,6 +290,10 @@ struct syscalltable syscalls_aarch64[] = {
 /* 277 */	{ .entry = &syscall_seccomp },
 /* 278 */	{ .entry = &syscall_getrandom },
 /* 279 */	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 /* 280 */	{ .entry = &syscall_bpf },
+#else
+		{ .entry = NULL },
+#endif
 /* 281 */	{ .entry = &syscall_execveat },
 };
diff --git a/include/syscalls-arm.h b/include/syscalls-arm.h
index 7ecc4353a835..0f40e57e5501 100644
--- a/include/syscalls-arm.h
+++ b/include/syscalls-arm.h
@@ -396,7 +396,11 @@ struct syscalltable syscalls_arm[] = {
 		{ .entry = &syscall_seccomp },
 		{ .entry = &syscall_getrandom },
 /* 385 */	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 		{ .entry = &syscall_bpf },
+#else
+		{ .entry = NULL },
+#endif
 		{ .entry = &syscall_execveat },
 		{ .entry = &syscall_userfaultfd },
 		{ .entry = &syscall_membarrier },
diff --git a/include/syscalls-i386.h b/include/syscalls-i386.h
index 147b1eb12607..316836406674 100644
--- a/include/syscalls-i386.h
+++ b/include/syscalls-i386.h
@@ -364,7 +364,11 @@ struct syscalltable syscalls_i386[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_execveat },
 	{ .entry = &syscall_socket },
 	{ .entry = &syscall_socketpair },
diff --git a/include/syscalls-ia64.h b/include/syscalls-ia64.h
index 28eacce0ac3d..5efcb7d42f88 100644
--- a/include/syscalls-ia64.h
+++ b/include/syscalls-ia64.h
@@ -324,7 +324,11 @@ struct syscalltable syscalls_ia64[] = {
 	{ .entry = &syscall_renameat2 },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_userfaultfd },
 	{ .entry = &syscall_membarrier },
 	{ .entry = &syscall_kcmp },
diff --git a/include/syscalls-mips.h b/include/syscalls-mips.h
index 273ba257db1c..26130f323f4a 100644
--- a/include/syscalls-mips.h
+++ b/include/syscalls-mips.h
@@ -371,5 +371,9 @@ struct syscalltable syscalls_mips[] = {
 		{ .entry = &syscall_seccomp },
 		{ .entry = &syscall_getrandom },
 		{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 		{ .entry = &syscall_bpf },		/* 4355 */
+#else
+		{ .entry = NULL },
+#endif
 };
diff --git a/include/syscalls-parisc.h b/include/syscalls-parisc.h
index 8d164e501b12..2ac2d5f9513e 100644
--- a/include/syscalls-parisc.h
+++ b/include/syscalls-parisc.h
@@ -348,6 +348,10 @@ struct syscalltable syscalls_parisc[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_execveat },
 };
diff --git a/include/syscalls-s390.h b/include/syscalls-s390.h
index dd9c93aeae04..9916e6c6e772 100644
--- a/include/syscalls-s390.h
+++ b/include/syscalls-s390.h
@@ -358,7 +358,11 @@ struct syscalltable syscalls_s390[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_write
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_read
 	{ .entry = &syscall_execveat },
diff --git a/include/syscalls-s390x.h b/include/syscalls-s390x.h
index 6ddeb85ea39d..6dbaffb37397 100644
--- a/include/syscalls-s390x.h
+++ b/include/syscalls-s390x.h
@@ -358,7 +358,11 @@ struct syscalltable syscalls_s390x[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_write
 	{ .entry = &syscall_ni_syscall },	// TODO: syscall_s390_pci_mmio_read
 	{ .entry = &syscall_execveat },
diff --git a/include/syscalls-sparc.h b/include/syscalls-sparc.h
index 5cedd89b4fee..dbdd4e8d4620 100644
--- a/include/syscalls-sparc.h
+++ b/include/syscalls-sparc.h
@@ -356,6 +356,10 @@ struct syscalltable syscalls_sparc[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_getrandom },
 	{ .entry = &syscall_memfd_create },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_execveat },
 };
diff --git a/include/syscalls-x86_64.h b/include/syscalls-x86_64.h
index c75f4dee142f..cc67889e7e23 100644
--- a/include/syscalls-x86_64.h
+++ b/include/syscalls-x86_64.h
@@ -328,7 +328,11 @@ struct syscalltable syscalls_x86_64[] = {
 	{ .entry = &syscall_seccomp },
 	{ .entry = &syscall_memfd_create },
 	{ .entry = &syscall_kexec_file_load },
+#ifdef USE_BPF
 	{ .entry = &syscall_bpf },
+#else
+	{ .entry = NULL },
+#endif
 	{ .entry = &syscall_execveat },
 	{ .entry = &syscall_userfaultfd },
 	{ .entry = &syscall_membarrier },
diff --git a/syscalls/bpf.c b/syscalls/bpf.c
index b2f57d36feff..476a2778d8a0 100644
--- a/syscalls/bpf.c
+++ b/syscalls/bpf.c
@@ -1,6 +1,7 @@
 /*
  * SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
  */
+#ifdef USE_BPF
 #include <linux/bpf.h>
 #include <linux/filter.h>
 #include "arch.h"
@@ -102,3 +103,4 @@ struct syscallentry syscall_bpf = {
 	.sanitise = sanitise_bpf,
 	.post = post_bpf,
 };
+#endif
diff --git a/tables-biarch.c b/tables-biarch.c
index 635aac966880..53e9b8330615 100644
--- a/tables-biarch.c
+++ b/tables-biarch.c
@@ -216,8 +216,12 @@ int setup_syscall_group_biarch(unsigned int group)
 	unsigned int i;
 
 	for_each_32bit_syscall(i) {
-		if (syscalls_32bit[i].entry->group == group)
-			toggle_syscall(syscalls_32bit[i].entry->name, TRUE);
+		struct syscallentry *entry = syscalls_32bit[i].entry;
+		if (entry == NULL)
+			continue;
+
+		if (entry->group == group)
+			toggle_syscall(entry->name, TRUE);
 	}
 
 	if (shm->nr_active_32bit_syscalls == 0)
@@ -227,8 +231,12 @@ int setup_syscall_group_biarch(unsigned int group)
 
 	/* now the 64 bit table*/
 	for_each_64bit_syscall(i) {
-		if (syscalls_64bit[i].entry->group == group)
-			toggle_syscall(syscalls_64bit[i].entry->name, TRUE);
+		struct syscallentry *entry = syscalls_64bit[i].entry;
+		if (entry == NULL)
+		continue;
+
+		if (entry->group == group)
+			toggle_syscall(entry->name, TRUE);
 	}
 
 	if (shm->nr_active_64bit_syscalls == 0) {
@@ -247,14 +255,20 @@ void mark_all_syscalls_active_biarch(void)
 
 	if (do_32_arch) {
 		for_each_32bit_syscall(i) {
-			syscalls_32bit[i].entry->flags |= ACTIVE;
+			struct syscallentry *entry = syscalls_32bit[i].entry;
+			if (entry == NULL)
+				continue;
+			entry->flags |= ACTIVE;
 			activate_syscall32(i);
 		}
 	}
 
 	if (do_64_arch) {
 		for_each_64bit_syscall(i) {
-			syscalls_64bit[i].entry->flags |= ACTIVE;
+			struct syscallentry *entry = syscalls_64bit[i].entry;
+			if (entry == NULL)
+				continue;
+			entry->flags |= ACTIVE;
 			activate_syscall64(i);
 		}
 	}
@@ -267,6 +281,9 @@ void init_syscalls_biarch(void)
 
 	for_each_64bit_syscall(i) {
 		entry = syscalls_64bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		if (entry->flags & ACTIVE)
 			if (entry->init)
 				entry->init();
@@ -274,6 +291,9 @@ void init_syscalls_biarch(void)
 
 	for_each_32bit_syscall(i) {
 		entry = syscalls_32bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		if (entry->flags & ACTIVE)
 			if (entry->init)
 				entry->init();
@@ -287,6 +307,9 @@ void deactivate_disabled_syscalls_biarch(void)
 
 	for_each_64bit_syscall(i) {
 		entry = syscalls_64bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		if (entry->flags & TO_BE_DEACTIVATED) {
 			entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 			deactivate_syscall64(i);
@@ -297,6 +320,9 @@ void deactivate_disabled_syscalls_biarch(void)
 
 	for_each_32bit_syscall(i) {
 		entry = syscalls_32bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		if (entry->flags & TO_BE_DEACTIVATED) {
 			entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 			deactivate_syscall32(i);
@@ -316,6 +342,9 @@ void dump_syscall_tables_biarch(void)
 
 	for_each_32bit_syscall(i) {
 		entry = syscalls_32bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		outputstd("entrypoint %d %s : [32-bit] ",
 			entry->number, entry->name);
 		show_state(entry->flags & ACTIVE);
@@ -328,6 +357,8 @@ void dump_syscall_tables_biarch(void)
 
 	for_each_64bit_syscall(i) {
 		entry = syscalls_64bit[i].entry;
+		if (entry == NULL)
+			continue;
 
 		outputstd("entrypoint %d %s : [64-bit] ",
 			entry->number, entry->name);
@@ -347,12 +378,18 @@ void display_enabled_syscalls_biarch(void)
 
 	for_each_64bit_syscall(i) {
 		entry = syscalls_64bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		if (entry->flags & ACTIVE)
 			output(0, "64-bit syscall %d:%s enabled.\n", i, entry->name);
 	}
 
 	for_each_32bit_syscall(i) {
 		entry = syscalls_32bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		if (entry->flags & ACTIVE)
 			output(0, "32-bit syscall %d:%s enabled.\n", i, entry->name);
 	}
diff --git a/tables-uniarch.c b/tables-uniarch.c
index 8f6bcd6553e1..5ba385e6fb74 100644
--- a/tables-uniarch.c
+++ b/tables-uniarch.c
@@ -100,7 +100,11 @@ void mark_all_syscalls_active_uniarch(void)
 	unsigned int i;
 
 	for_each_syscall(i) {
-		syscalls[i].entry->flags |= ACTIVE;
+		struct syscallentry *entry = syscalls[i].entry;
+		if (entry == NULL)
+			continue;
+
+		entry->flags |= ACTIVE;
 		activate_syscall(i);
 	}
 }
@@ -110,9 +114,10 @@ void init_syscalls_uniarch(void)
 	unsigned int i;
 
 	for_each_syscall(i) {
-		struct syscallentry *entry;
+		struct syscallentry *entry = syscalls[i].entry;
+		if (entry == NULL)
+			continue;
 
-		entry = syscalls[i].entry;
 		if (entry->flags & ACTIVE)
 			if (entry->init)
 				entry->init();
@@ -124,9 +129,11 @@ void deactivate_disabled_syscalls_uniarch(void)
 	unsigned int i;
 
 	for_each_syscall(i) {
-		struct syscallentry *entry;
+		struct syscallentry *entry = syscalls[i].entry;
+
+		if (entry == NULL)
+			continue;
 
-		entry = syscalls[i].entry;
 		if (entry->flags & TO_BE_DEACTIVATED) {
 			entry->flags &= ~(ACTIVE|TO_BE_DEACTIVATED);
 			deactivate_syscall_uniarch(i);
@@ -143,9 +150,11 @@ void dump_syscall_tables_uniarch(void)
 	outputstd("syscalls: %d\n", max_nr_syscalls);
 
 	for_each_syscall(i) {
-		struct syscallentry *entry;
+		struct syscallentry *entry = syscalls[i].entry;
+
+		if (entry == NULL)
+			continue;
 
-		entry = syscalls[i].entry;
 		outputstd("entrypoint %d %s : ", entry->number, entry->name);
 		show_state(entry->flags & ACTIVE);
 		if (entry->flags & AVOID_SYSCALL)
@@ -159,9 +168,10 @@ void display_enabled_syscalls_uniarch(void)
         unsigned int i;
 
 	for_each_syscall(i) {
-		struct syscallentry *entry;
+		struct syscallentry *entry = syscalls[i].entry;
 
-		entry = syscalls[i].entry;
+		if (entry == NULL)
+			continue;
 
 		if (entry->flags & ACTIVE)
 			output(0, "syscall %d:%s enabled.\n", i, entry->name);
diff --git a/tables.c b/tables.c
index 7d5d35b7d2fa..8d3f4d7d8a6e 100644
--- a/tables.c
+++ b/tables.c
@@ -211,6 +211,8 @@ static void check_syscall(struct syscallentry *entry)
 {
 	/* check that we have a name set. */
 #define CHECK(NUMARGS, ARGNUM, ARGTYPE, ARGNAME)		\
+	if (entry == NULL)					\
+		return;						\
 	if (entry->num_args > 0) {				\
 		if (entry->num_args > NUMARGS) {		\
 			if (entry->ARGNAME == NULL)  {		\
@@ -231,6 +233,8 @@ static void check_syscall(struct syscallentry *entry)
 	/* note: not enabled by default, because we haven't annotated everything yet. */
 #undef CHECK
 #define CHECK(NUMARGS, ARGNUM, ARGTYPE, ARGNAME)		\
+	if (entry == NULL)					\
+		return;						\
 	if (entry->num_args > 0) {				\
 		if (entry->num_args > NUMARGS) {		\
 			if (entry->ARGTYPE == ARG_UNDEFINED) {	\
@@ -379,6 +383,9 @@ static void show_unannotated_biarch(void)
 
 	for_each_32bit_syscall(i) {
 		entry = syscalls_32bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		count = 0;
 
 		for (j = 1; j <= entry->num_args; j++) {
@@ -415,6 +422,9 @@ static void show_unannotated_biarch(void)
 
 	for_each_64bit_syscall(i) {
 		entry = syscalls_64bit[i].entry;
+		if (entry == NULL)
+			continue;
+
 		count = 0;
 
 		for (j = 1; j <= entry->num_args; j++) {
@@ -469,18 +479,24 @@ void show_unannotated_args(void)
  */
 static struct syscalltable * copy_syscall_table(struct syscalltable *from, unsigned int nr)
 {
-	unsigned int n;
+	unsigned int n, m;
 	struct syscallentry *copy;
 
 	copy = alloc_shared(nr * sizeof(struct syscallentry));
 	if (copy == NULL)
 		exit(EXIT_FAILURE);
 
-	for (n = 0; n < nr; n++) {
-		memcpy(copy + n , from[n].entry, sizeof(struct syscallentry));
-		copy[n].number = n;
-		copy[n].active_number = 0;
-		from[n].entry = &copy[n];
+	for (n = 0, m = 0; n < nr; n++) {
+		struct syscallentry *entry = from[n].entry;
+
+		if (entry == NULL)
+			continue;
+
+		memcpy(copy + m , from[n].entry, sizeof(struct syscallentry));
+		copy[m].number = n;
+		copy[m].active_number = 0;
+		from[n].entry = &copy[m];
+		m++;
 	}
 	return from;
 }
