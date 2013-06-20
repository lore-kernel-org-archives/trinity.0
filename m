From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch 1/2] add init() function to struct syscall
Date: Wed, 19 Jun 2013 22:09:09 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org


While working on the perf_event_open() sysfs init problem, I was wondering
if it might be easier if we added the possibility of an init() routine
to each syscall structure.  That way trinity can support doing setup
before fuzzing begins.

Below is a quick patch implementing this, it seems to work but I still 
don't have the best grasp of trinity internals.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/syscall.h b/include/syscall.h
index ccbe436..a58a506 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -32,6 +32,7 @@ struct arglist {
 struct syscall {
 	void (*sanitise)(int childno);
 	void (*post)(int);
+	int (*init)(void);
 
 	unsigned int number;
 	const char name[80];
@@ -132,6 +133,7 @@ void deactivate_disabled_syscalls(void);
 void count_syscalls_enabled(void);
 void display_enabled_syscalls(void);
 void disable_non_net_syscalls(void);
+void init_syscalls(void);
 
 #define for_each_32bit_syscall(i) \
 	for (i = 0; i < max_nr_32bit_syscalls; i++)
diff --git a/tables.c b/tables.c
index 7be1ae9..d12b541 100644
--- a/tables.c
+++ b/tables.c
@@ -106,6 +106,35 @@ void count_syscalls_enabled(void)
 	}
 }
 
+void init_syscalls(void)
+{
+	unsigned int i;
+
+	if (biarch == TRUE) {
+		for_each_64bit_syscall(i) {
+			if (syscalls_64bit[i].entry->flags & ACTIVE)
+				if (syscalls_64bit[i].entry->init)
+					syscalls_64bit[i].entry->init();
+		}
+
+		for_each_32bit_syscall(i) {
+			if (syscalls_32bit[i].entry->flags & ACTIVE)
+				if (syscalls_32bit[i].entry->init)
+					syscalls_32bit[i].entry->init();
+		}
+
+	} else {
+
+		/* non-biarch */
+		for_each_syscall(i) {
+			if (syscalls[i].entry->flags & ACTIVE)
+				if (syscalls[i].entry->init)
+					syscalls[i].entry->init();
+		}
+	}
+}
+
+
 bool no_syscalls_enabled(void)
 {
 	unsigned int i;
diff --git a/trinity.c b/trinity.c
index 4b536c9..93e7819 100644
--- a/trinity.c
+++ b/trinity.c
@@ -183,6 +183,8 @@ int main(int argc, char* argv[])
 		goto out;
 	}
 
+	init_syscalls();
+
 	if (show_ioctl_list == TRUE) {
 		dump_ioctls();
 		goto out;
