From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Trinity for PA-RISC
Date: Tue, 22 Oct 2013 20:33:20 +0200
Message-ID: <3514559.IZDIRJtZo8@caliban.sf-tec.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart14139079.fXXPNjuzId"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: linux-parisc <linux-parisc@vger.kernel.org>
Cc: trinity@vger.kernel.org


--nextPart14139079.fXXPNjuzId
Content-Type: multipart/mixed; boundary="nextPart2108050.CCuy2rmY5f"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart2108050.CCuy2rmY5f
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi all,

out of boredom I did the first steps to port trinity to PA-RISC. The second 
patch is needed to get it compile, but since those headers are apparently not 
needed on other archs I suspect something is wrong with the PA-RISC headers. 
The implementation for some syscalls is missing, I just picked up what was 
available by default. Also everything currently is 32 bit. In contrast to what 
other archs do there currently is only a 32 bit userspace on PA-RISC, but 
there are many systems with a 64 bit userspace.

I have the hope that one of the usual suspects would use this to hammer on the 
kernel and fix the fallout. ;)

Eike
--nextPart2108050.CCuy2rmY5f
Content-Disposition: attachment; filename="0001-add-basic-information-for-PA-RISC-architecture.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-add-basic-information-for-PA-RISC-architecture.patch"

From 563bbaf50193df24f592f41f0c0306c32d2e457d Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Tue, 22 Oct 2013 18:39:48 +0200
Subject: [PATCH 1/2] add basic information for PA-RISC architecture

---
 include/arch-parisc.h     |  22 +++
 include/arch-syscalls.h   |   3 +
 include/arch.h            |   4 +
 include/syscalls-parisc.h | 347 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 376 insertions(+)
 create mode 100644 include/arch-parisc.h
 create mode 100644 include/syscalls-parisc.h

diff --git a/include/arch-parisc.h b/include/arch-parisc.h
new file mode 100644
index 0000000..757facf
--- /dev/null
+++ b/include/arch-parisc.h
@@ -0,0 +1,22 @@
+// FIXME: depends on kernel bit size, userspace is always 32 bit
+
+#define PAGE_OFFSET 0x10000000
+
+#if 0
+// for 64 bit
+#define PAGE_OFFSET 0x40000000
+#endif
+
+#define KERNEL_ADDR	0xa0000000	// FIXME: Placeholder
+#define MODULE_ADDR     0xa0000000L	// FIXME: Placeholder
+#define TASK_SIZE 0xa0000000	// FIXME: Placeholder
+
+#define PAGE_SHIFT 		12
+#define PTE_FILE_MAX_BITS	(32 - 11)
+
+#define PTRACE_GETREGS		0
+#define PTRACE_GETFPREGS	0
+#define PTRACE_SETREGS		0
+#define PTRACE_SETFPREGS	0
+
+#define SYSCALLS syscalls_parisc
diff --git a/include/arch-syscalls.h b/include/arch-syscalls.h
index b1cf265..22866f5 100644
--- a/include/arch-syscalls.h
+++ b/include/arch-syscalls.h
@@ -38,4 +38,7 @@
 #ifdef __aarch64__
 #include "syscalls-aarch64.h"
 #endif
+#ifdef __hppa__
+#include "syscalls-parisc.h"
+#endif
 #endif  /* _ARCH_SYSCALLS_H */
diff --git a/include/arch.h b/include/arch.h
index 1835204..fe91660 100644
--- a/include/arch.h
+++ b/include/arch.h
@@ -45,6 +45,10 @@
 #include "arch-aarch64.h"
 #endif
 
+#ifdef __hppa__
+#include "arch-parisc.h"
+#endif
+
 #ifndef SYSCALL_OFFSET
 #define SYSCALL_OFFSET 0
 #endif
diff --git a/include/syscalls-parisc.h b/include/syscalls-parisc.h
new file mode 100644
index 0000000..041d11e
--- /dev/null
+++ b/include/syscalls-parisc.h
@@ -0,0 +1,347 @@
+#ifndef _SYSCALLS_PARISC_H
+#define _SYSCALLS_PARISC_H 1
+
+/* Syscalls from arch/parisc/kernel/syscall_table.S as of 3.12-rc6 */
+
+#include "sanitise.h"
+#include "syscall.h"
+#include "syscalls/syscalls.h"
+
+struct syscalltable syscalls_parisc[] = {
+	{ .entry = &syscall_restart_syscall },
+	{ .entry = &syscall_exit },
+	{ .entry = &syscall_fork },	/* FIXME: fork_wrapper */
+	{ .entry = &syscall_read },
+	{ .entry = &syscall_write },
+	{ .entry = &syscall_open },
+	{ .entry = &syscall_close },
+	{ .entry = &syscall_waitpid },
+	{ .entry = &syscall_creat },
+	{ .entry = &syscall_link },
+	{ .entry = &syscall_unlink },
+	{ .entry = &syscall_execve },
+	{ .entry = &syscall_chdir },
+	{ .entry = &syscall_time },
+	{ .entry = &syscall_mknod },
+	{ .entry = &syscall_chmod },
+	{ .entry = &syscall_lchown },
+	{ .entry = &syscall_socket },
+	{ .entry = &syscall_newstat },
+	{ .entry = &syscall_lseek },
+	{ .entry = &syscall_getpid },
+	{ .entry = &syscall_mount },
+	{ .entry = &syscall_bind },
+	{ .entry = &syscall_setuid },
+	{ .entry = &syscall_getuid },
+	{ .entry = &syscall_stime },
+	{ .entry = &syscall_ptrace },
+	{ .entry = &syscall_alarm },
+	{ .entry = &syscall_newfstat },
+	{ .entry = &syscall_pause },
+	{ .entry = &syscall_utime },
+	{ .entry = &syscall_connect },
+	{ .entry = &syscall_listen },
+	{ .entry = &syscall_access },
+	{ .entry = &syscall_nice },
+	{ .entry = &syscall_accept },
+	{ .entry = &syscall_sync },
+	{ .entry = &syscall_kill },
+	{ .entry = &syscall_rename },
+	{ .entry = &syscall_mkdir },
+	{ .entry = &syscall_rmdir },
+	{ .entry = &syscall_dup },
+	{ .entry = &syscall_pipe },
+	{ .entry = &syscall_times },
+	{ .entry = &syscall_getsockname },
+	{ .entry = &syscall_brk },
+	{ .entry = &syscall_setgid },
+	{ .entry = &syscall_getgid },
+	{ .entry = &syscall_signal },
+	{ .entry = &syscall_geteuid },
+	{ .entry = &syscall_getegid },
+	{ .entry = &syscall_acct },
+	{ .entry = &syscall_umount },
+	{ .entry = &syscall_getpeername },
+	{ .entry = &syscall_ioctl },
+	{ .entry = &syscall_fcntl },
+	{ .entry = &syscall_socketpair },
+	{ .entry = &syscall_setpgid },
+	{ .entry = &syscall_send },
+	{ .entry = &syscall_newuname },
+	{ .entry = &syscall_umask },
+	{ .entry = &syscall_chroot },
+	{ .entry = &syscall_ustat },
+	{ .entry = &syscall_dup2 },
+	{ .entry = &syscall_getppid },
+	{ .entry = &syscall_getpgrp },
+	{ .entry = &syscall_setsid },
+	{ .entry = &syscall_pivot_root },
+	{ .entry = &syscall_sgetmask },
+	{ .entry = &syscall_ssetmask },
+	{ .entry = &syscall_setreuid },
+	{ .entry = &syscall_setregid },
+	{ .entry = &syscall_mincore },
+	{ .entry = &syscall_sigpending },
+	{ .entry = &syscall_sethostname },
+	{ .entry = &syscall_setrlimit },
+	{ .entry = &syscall_getrlimit },
+	{ .entry = &syscall_getrusage },
+	{ .entry = &syscall_gettimeofday },
+	{ .entry = &syscall_settimeofday },
+	{ .entry = &syscall_getgroups },
+	{ .entry = &syscall_setgroups },
+	{ .entry = &syscall_sendto },
+	{ .entry = &syscall_symlink },
+	{ .entry = &syscall_newlstat },
+	{ .entry = &syscall_readlink },
+	{ .entry = &syscall_ni_syscall },	/* was uselib */
+	{ .entry = &syscall_swapon },
+	{ .entry = &syscall_reboot },
+	{ .entry = &syscall_mmap2 },
+	{ .entry = &syscall_mmap },
+	{ .entry = &syscall_munmap },
+	{ .entry = &syscall_truncate },
+	{ .entry = &syscall_ftruncate },
+	{ .entry = &syscall_fchmod },
+	{ .entry = &syscall_fchown },
+	{ .entry = &syscall_getpriority },
+	{ .entry = &syscall_setpriority },
+	{ .entry = &syscall_recv },
+	{ .entry = &syscall_statfs },
+	{ .entry = &syscall_fstatfs },
+	{ .entry = &syscall_stat64 },
+	{ .entry = &syscall_ni_syscall },	/* was socketcall */
+	{ .entry = &syscall_syslog },
+	{ .entry = &syscall_setitimer },
+	{ .entry = &syscall_getitimer },
+	{ .entry = &syscall_capget },
+	{ .entry = &syscall_capset },
+	{ .entry = &syscall_pread64 },
+	{ .entry = &syscall_pwrite64 },
+	{ .entry = &syscall_getcwd },
+	{ .entry = &syscall_vhangup },
+	{ .entry = &syscall_fstat64 },
+	{ .entry = &syscall_vfork },
+	{ .entry = &syscall_wait4 },
+	{ .entry = &syscall_swapoff },
+	{ .entry = &syscall_sysinfo },
+	{ .entry = &syscall_shutdown },
+	{ .entry = &syscall_fsync },
+	{ .entry = &syscall_madvise },
+	{ .entry = &syscall_clone },
+	{ .entry = &syscall_setdomainname },
+	{ .entry = &syscall_sendfile },
+	{ .entry = &syscall_recvfrom },
+	{ .entry = &syscall_adjtimex },
+	{ .entry = &syscall_mprotect },
+	{ .entry = &syscall_sigprocmask },
+	{ .entry = &syscall_ni_syscall },	/* obsolete "create_module" syscall */
+	{ .entry = &syscall_init_module },
+	{ .entry = &syscall_delete_module },
+	{ .entry = &syscall_ni_syscall },	/* was get_kernel_syms */
+	{ .entry = &syscall_quotactl },
+	{ .entry = &syscall_getpgid },
+	{ .entry = &syscall_fchdir },
+	{ .entry = &syscall_bdflush },
+	{ .entry = &syscall_sysfs },
+	{ .entry = &syscall_personality },
+	{ .entry = &syscall_ni_syscall },	/* obsolete "afs" syscall */
+	{ .entry = &syscall_setfsuid },
+	{ .entry = &syscall_setfsgid },
+	{ .entry = &syscall_llseek },
+	{ .entry = &syscall_getdents },
+	{ .entry = &syscall_select },
+	{ .entry = &syscall_flock },
+	{ .entry = &syscall_msync },
+	{ .entry = &syscall_readv },
+	{ .entry = &syscall_writev },
+	{ .entry = &syscall_getsid },
+	{ .entry = &syscall_fdatasync },
+	{ .entry = &syscall_sysctl },
+	{ .entry = &syscall_mlock },
+	{ .entry = &syscall_munlock },
+	{ .entry = &syscall_mlockall },
+	{ .entry = &syscall_munlockall },
+	{ .entry = &syscall_sched_setparam },
+	{ .entry = &syscall_sched_getparam },
+	{ .entry = &syscall_sched_setscheduler },
+	{ .entry = &syscall_sched_getscheduler },
+	{ .entry = &syscall_sched_yield },
+	{ .entry = &syscall_sched_get_priority_max },
+	{ .entry = &syscall_sched_get_priority_min },
+	{ .entry = &syscall_sched_rr_get_interval },
+	{ .entry = &syscall_nanosleep },
+	{ .entry = &syscall_mremap },
+	{ .entry = &syscall_setresuid },
+	{ .entry = &syscall_getresuid },
+	{ .entry = &syscall_sigaltstack },
+	{ .entry = &syscall_ni_syscall },	/* obsolete "query_module" syscall */
+	{ .entry = &syscall_poll },
+	{ .entry = &syscall_ni_syscall },	/* was nfsserverctl */
+	{ .entry = &syscall_setresgid },
+	{ .entry = &syscall_getresgid },
+	{ .entry = &syscall_prctl },
+	{ .entry = &syscall_rt_sigreturn },
+	{ .entry = &syscall_rt_sigaction },
+	{ .entry = &syscall_rt_sigprocmask },
+	{ .entry = &syscall_rt_sigpending },
+	{ .entry = &syscall_rt_sigtimedwait },
+	{ .entry = &syscall_rt_sigqueueinfo },
+	{ .entry = &syscall_rt_sigsuspend },
+	{ .entry = &syscall_chown },
+	{ .entry = &syscall_setsockopt },
+	{ .entry = &syscall_getsockopt },
+	{ .entry = &syscall_sendmsg },
+	{ .entry = &syscall_recvmsg },
+	{ .entry = &syscall_semop },
+	{ .entry = &syscall_semget },
+	{ .entry = &syscall_semctl },
+	{ .entry = &syscall_msgsnd },
+	{ .entry = &syscall_msgrcv },
+	{ .entry = &syscall_msgget },
+	{ .entry = &syscall_msgctl },
+	{ .entry = &syscall_shmat },
+	{ .entry = &syscall_shmdt },
+	{ .entry = &syscall_shmget },
+	{ .entry = &syscall_shmctl },
+	{ .entry = &syscall_ni_syscall },	/* streams1 */
+	{ .entry = &syscall_ni_syscall },	/* streams2 */
+	{ .entry = &syscall_lstat64 },
+	{ .entry = &syscall_truncate64 },
+	{ .entry = &syscall_ftruncate64 },
+	{ .entry = &syscall_getdents64 },
+	{ .entry = &syscall_ni_syscall },	// FIXME: fcntl64
+	{ .entry = &syscall_ni_syscall },	/* obsolete "attrctl" syscall */
+	{ .entry = &syscall_ni_syscall },	/* obsolete "acl_get" syscall */
+	{ .entry = &syscall_ni_syscall },	/* obsolete "acl_set" syscall */
+	{ .entry = &syscall_gettid },
+	{ .entry = &syscall_readahead },
+	{ .entry = &syscall_tkill },
+	{ .entry = &syscall_sendfile64 },
+	{ .entry = &syscall_futex },
+	{ .entry = &syscall_sched_setaffinity },
+	{ .entry = &syscall_sched_getaffinity },
+	{ .entry = &syscall_ni_syscall },	/* set_thread_area */
+	{ .entry = &syscall_ni_syscall },	/* get_thread_area */
+	{ .entry = &syscall_io_setup },
+	{ .entry = &syscall_io_destroy },
+	{ .entry = &syscall_io_getevents },
+	{ .entry = &syscall_io_submit },
+	{ .entry = &syscall_io_cancel },
+	{ .entry = &syscall_ni_syscall },	/* FIXME alloc_hugepages */
+	{ .entry = &syscall_ni_syscall },	/* FIXME free_hugepages */
+	{ .entry = &syscall_exit_group },
+	{ .entry = &syscall_lookup_dcookie },
+	{ .entry = &syscall_epoll_create },
+	{ .entry = &syscall_epoll_ctl },
+	{ .entry = &syscall_epoll_wait },
+	{ .entry = &syscall_remap_file_pages },
+	{ .entry = &syscall_semtimedop },
+	{ .entry = &syscall_mq_open },
+	{ .entry = &syscall_mq_unlink },
+	{ .entry = &syscall_mq_timedsend },
+	{ .entry = &syscall_mq_timedreceive },
+	{ .entry = &syscall_mq_notify },
+	{ .entry = &syscall_mq_getsetattr },
+	{ .entry = &syscall_waitid },
+	{ .entry = &syscall_fadvise64_64 },
+	{ .entry = &syscall_set_tid_address },
+	{ .entry = &syscall_setxattr },
+	{ .entry = &syscall_lsetxattr },
+	{ .entry = &syscall_fsetxattr },
+	{ .entry = &syscall_getxattr },
+	{ .entry = &syscall_lgetxattr },
+	{ .entry = &syscall_fgetxattr },
+	{ .entry = &syscall_listxattr },
+	{ .entry = &syscall_llistxattr },
+	{ .entry = &syscall_flistxattr },
+	{ .entry = &syscall_removexattr },
+	{ .entry = &syscall_lremovexattr },
+	{ .entry = &syscall_fremovexattr },
+	{ .entry = &syscall_timer_create },
+	{ .entry = &syscall_timer_settime },
+	{ .entry = &syscall_timer_gettime },
+	{ .entry = &syscall_timer_getoverrun },
+	{ .entry = &syscall_timer_delete },
+	{ .entry = &syscall_clock_settime },
+	{ .entry = &syscall_clock_gettime },
+	{ .entry = &syscall_clock_getres },
+	{ .entry = &syscall_clock_nanosleep },
+	{ .entry = &syscall_tgkill },
+	{ .entry = &syscall_mbind },
+	{ .entry = &syscall_get_mempolicy },
+	{ .entry = &syscall_set_mempolicy },
+	{ .entry = &syscall_ni_syscall },	/* obsolete "vserver" syscall */
+	{ .entry = &syscall_add_key },
+	{ .entry = &syscall_request_key },
+	{ .entry = &syscall_keyctl },
+	{ .entry = &syscall_ioprio_set },
+	{ .entry = &syscall_ioprio_get },
+	{ .entry = &syscall_inotify_init },
+	{ .entry = &syscall_inotify_add_watch },
+	{ .entry = &syscall_inotify_rm_watch },
+	{ .entry = &syscall_migrate_pages },
+	{ .entry = &syscall_pselect6 },
+	{ .entry = &syscall_ppoll },
+	{ .entry = &syscall_openat },
+	{ .entry = &syscall_mkdirat },
+	{ .entry = &syscall_mknodat },
+	{ .entry = &syscall_fchownat },
+	{ .entry = &syscall_futimesat },
+	{ .entry = &syscall_fstatat64 },
+	{ .entry = &syscall_unlinkat },
+	{ .entry = &syscall_renameat },
+	{ .entry = &syscall_linkat },
+	{ .entry = &syscall_symlinkat },
+	{ .entry = &syscall_readlinkat },
+	{ .entry = &syscall_fchmodat },
+	{ .entry = &syscall_faccessat },
+	{ .entry = &syscall_unshare },
+	{ .entry = &syscall_set_robust_list },
+	{ .entry = &syscall_get_robust_list },
+	{ .entry = &syscall_splice },
+	{ .entry = &syscall_sync_file_range },
+	{ .entry = &syscall_tee },
+	{ .entry = &syscall_vmsplice },
+	{ .entry = &syscall_move_pages },
+	{ .entry = &syscall_getcpu },
+	{ .entry = &syscall_epoll_pwait },
+	{ .entry = &syscall_statfs64 },
+	{ .entry = &syscall_fstatfs64 },
+	{ .entry = &syscall_kexec_load },
+	{ .entry = &syscall_utimensat },
+	{ .entry = &syscall_signalfd },
+	{ .entry = &syscall_ni_syscall },	/* was timerfd */
+	{ .entry = &syscall_eventfd },
+	{ .entry = &syscall_fallocate },
+	{ .entry = &syscall_timerfd_create },
+	{ .entry = &syscall_timerfd_settime },
+	{ .entry = &syscall_timerfd_gettime },
+	{ .entry = &syscall_signalfd4 },
+	{ .entry = &syscall_eventfd2 },
+	{ .entry = &syscall_epoll_create1 },
+	{ .entry = &syscall_dup3 },
+	{ .entry = &syscall_pipe2 },
+	{ .entry = &syscall_inotify_init1 },
+	{ .entry = &syscall_preadv },
+	{ .entry = &syscall_pwritev },
+	{ .entry = &syscall_rt_tgsigqueueinfo },
+	{ .entry = &syscall_perf_event_open },
+	{ .entry = &syscall_recvmmsg },
+	{ .entry = &syscall_accept4 },
+	{ .entry = &syscall_prlimit64 },
+	{ .entry = &syscall_fanotify_init },
+	{ .entry = &syscall_fanotify_mark },
+	{ .entry = &syscall_clock_adjtime },
+	{ .entry = &syscall_name_to_handle_at },
+	{ .entry = &syscall_open_by_handle_at },
+	{ .entry = &syscall_syncfs },
+	{ .entry = &syscall_setns },
+	{ .entry = &syscall_sendmmsg },	/* obsolete "putpmsg" syscall */
+	{ .entry = &syscall_process_vm_readv },
+	{ .entry = &syscall_process_vm_writev },
+	{ .entry = &syscall_kcmp },
+	{ .entry = &syscall_finit_module },
+};
+
+#endif	/* _SYSCALLS_PARISC_H */
-- 
1.8.3.2


--nextPart2108050.CCuy2rmY5f
Content-Disposition: attachment; filename="0002-add-more-headers-to-fix-compile-on-PA-RISC.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-add-more-headers-to-fix-compile-on-PA-RISC.patch"

From 3bb732227732e7577fe3e7c37a46eb05bea63cdc Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Tue, 22 Oct 2013 18:42:32 +0200
Subject: [PATCH 2/2] add more headers to fix compile on PA-RISC

---
 syscalls/msgrcv.c | 1 +
 syscalls/msgsnd.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/syscalls/msgrcv.c b/syscalls/msgrcv.c
index 2200472..5585b99 100644
--- a/syscalls/msgrcv.c
+++ b/syscalls/msgrcv.c
@@ -1,6 +1,7 @@
 /*
  * SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz, long, msgtyp, int, msgflg)
  */
+#include <sys/types.h>
 #include <linux/msg.h>
 #include "compat.h"
 #include "sanitise.h"
diff --git a/syscalls/msgsnd.c b/syscalls/msgsnd.c
index 3e3a91d..9eaf3d6 100644
--- a/syscalls/msgsnd.c
+++ b/syscalls/msgsnd.c
@@ -1,6 +1,7 @@
 /*
  * SYSCALL_DEFINE4(msgsnd, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz, int, msgflg)
  */
+#include <sys/types.h>
 #include <linux/msg.h>
 #include "compat.h"
 #include "sanitise.h"
-- 
1.8.3.2


--nextPart2108050.CCuy2rmY5f--

--nextPart14139079.fXXPNjuzId
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlJmxPcACgkQXKSJPmm5/E5KKwCfX0vO5q0taqhWpauEyP7i4Qjp
r+EAmgNN8vdnl1lCPSOJXHiTKMEXZCJ9
=Q4po
-----END PGP SIGNATURE-----

--nextPart14139079.fXXPNjuzId--

