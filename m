From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Stuck in syscall 11:. Sending SIGKILL.
Date: Wed, 17 Apr 2013 22:25:36 +0200
Message-ID: <516F0540.7080003@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030008030601000508060109"
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org

This is a multi-part message in MIME format.
--------------030008030601000508060109
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

trinity forgot the name of syscall 11 (while running within a UML instance)

...
[watchdog] 21055 iterations. [F:16827 S:4223]
[watchdog] pid 2481 hasn't made progress in 30 seconds! (last:1366229784 now:1366229814 diff:30). Stuck in syscall 267:clock_nanosleep. Sending SIGKILL.
[watchdog] pid 2500 hasn't made progress in 30 seconds! (last:1366229804 now:1366229834 diff:30). Stuck in syscall 267:clock_nanosleep. Sending SIGKILL.
[watchdog] pid 2519 hasn't made progress in 30 seconds! (last:1366229816 now:1366229846 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[watchdog] pid 2522 hasn't made progress in 30 seconds! (last:1366229818 now:1366229848 diff:30). Stuck in syscall 11:. Sending SIGKILL.


Full log is attached. The command line was :
$> trinity --children 4 --victims \$W/victims -N 50000 --quiet  -x mremap -x mount -x add_key -x request_key -x keyctl


Just FWIW this is the content of the working directory :

$> ls -il /mnt/trinity/w/ /mnt/trinity/trinity.sh.log
251711 -rw-r--r-- 1 tfoerste users 7350 Apr 17 22:19 /mnt/trinity/trinity.sh.log

/mnt/trinity/w/:
total 2456
327204 lrwxrwxrwx  1 tfoerste users      3 Apr 17 22:16 ? -> ???
328625 lrwxrwxrwx  1 tfoerste users      4 Apr 17 22:16 ???@???@00M?00M?? -> ????
328624 lrwxrwxrwx  1 tfoerste users     31 Apr 17 22:16 (08@HPX`hpx???????????????? -> ??? (08@HPX`hpx????????????????
326391 lrwxrwxrwx  1 tfoerste users      1 Apr 17 22:16 d -> ?
326213 -rw-r--r--  1 tfoerste users 785884 Apr 17 22:19 trinity-child0.log
326214 -rw-r--r--  1 tfoerste users 461261 Apr 17 22:19 trinity-child1.log
326215 -rw-r--r--  1 tfoerste users 747794 Apr 17 22:19 trinity-child2.log
326216 -rw-r--r--  1 tfoerste users 499628 Apr 17 22:18 trinity-child3.log
326212 -rw-r--r--  1 tfoerste users  15924 Apr 17 22:19 trinity.log
328606 dr-s-wS-wT 83 tfoerste users   3580 Apr 17 22:17 victims


Unfortunately all log files of trinity itself vanished when I stopped
the trinity process (whcih itself was called from within a script).

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--------------030008030601000508060109
Content-Type: text/x-log;
 name="trinity.sh.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="trinity.sh.log"

Trinity v1.2pre  Dave Jones <davej@redhat.com>
[2477] Marking syscall mremap (163) as to be disabled.
[2477] Marking syscall mount (21) as to be disabled.
[2477] Marking syscall add_key (286) as to be disabled.
[2477] Marking syscall request_key (287) as to be disabled.
[2477] Marking syscall keyctl (288) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
Disabling syscalls marked as disabled by command line options
[2477] Marked syscall mount (21) as deactivated.
[2477] Marked syscall mremap (163) as deactivated.
[2477] Marked syscall add_key (286) as deactivated.
[2477] Marked syscall request_key (287) as deactivated.
[2477] Marked syscall keyctl (288) as deactivated.
[2477] Enabled 346 syscalls. Disabled 5 syscalls.
[2477] Started watchdog process, PID is 2478
[2479] Main thread is alive.
Generating file descriptors
Added 201 filenames from /mnt/n22/w/victims
[2479] Random reseed: 1663948433
acct (51) returned ENOSYS, marking as inactive.
mq_timedsend (279) returned ENOSYS, marking as inactive.
get_mempolicy (275) returned ENOSYS, marking as inactive.
set_mempolicy (276) returned ENOSYS, marking as inactive.
vm86old (113) returned ENOSYS, marking as inactive.
ioperm (101) returned ENOSYS, marking as inactive.
[2479] Random reseed: 391077887
[2479] Random reseed: 2103868207
vm86old (113) returned ENOSYS, marking as inactive.
perf_event_open (336) returned ENOSYS, marking as inactive.
mbind (274) returned ENOSYS, marking as inactive.
mq_notify (281) returned ENOSYS, marking as inactive.
lookup_dcookie (253) returned ENOSYS, marking as inactive.
init_module (128) returned ENOSYS, marking as inactive.
kexec_load (283) returned ENOSYS, marking as inactive.
mq_getsetattr (282) returned ENOSYS, marking as inactive.
vm86 (166) returned ENOSYS, marking as inactive.
[2479] Random reseed: 1675065832
ipc (117) returned ENOSYS, marking as inactive.
kcmp (349) returned ENOSYS, marking as inactive.
finit_module (350) returned ENOSYS, marking as inactive.
quotactl (131) returned ENOSYS, marking as inactive.
iopl (110) returned ENOSYS, marking as inactive.
move_pages (317) returned ENOSYS, marking as inactive.
migrate_pages (294) returned ENOSYS, marking as inactive.
mq_timedreceive (280) returned ENOSYS, marking as inactive.
set_robust_list (311) returned ENOSYS, marking as inactive.
mq_open (277) returned ENOSYS, marking as inactive.
mmap_pgoff (192) returned ENOSYS, marking as inactive.
delete_module (129) returned ENOSYS, marking as inactive.
nfsservctl (169) returned ENOSYS, marking as inactive.
set_robust_list (311) returned ENOSYS, marking as inactive.
[2479] Random reseed: 123616051
mq_unlink (278) returned ENOSYS, marking as inactive.
[2479] Random reseed: 1780432715
get_robust_list (312) returned ENOSYS, marking as inactive.
[2479] Random reseed: 1952349951
sysctl (149) returned ENOSYS, marking as inactive.
[2479] Random reseed: 800369131
[2479] Random reseed: 1716992474
[2479] Random reseed: 2114899454
[2479] Random reseed: 600696669
[2479] Random reseed: 1738932089
[2479] Random reseed: 575598580
[2479] Random reseed: 1257758329
[2479] Random reseed: 468434710
[2479] Random reseed: 1670119407
[2479] Random reseed: 1936654269
[2479] Random reseed: 558872525
[2479] Random reseed: 1393032651
[2479] Random reseed: 344969199
[2479] Random reseed: 757034615
[2479] Random reseed: 23787510
[2479] Random reseed: 1327489007
[2479] Random reseed: 1885331429
[2478] Watchdog is alive
[watchdog] 10796 iterations. [F:8603 S:2188]
[watchdog] 21055 iterations. [F:16827 S:4223]
[watchdog] pid 2481 hasn't made progress in 30 seconds! (last:1366229784 now:1366229814 diff:30). Stuck in syscall 267:clock_nanosleep. Sending SIGKILL.
[2479] Random reseed: 122005342
[2479] Random reseed: 682621950
[2479] Random reseed: 1816902015
[2479] Random reseed: 1894350074
[2479] Random reseed: 1326177958
[2479] Random reseed: 677904287
[2479] Random reseed: 1390837752
[2479] Random reseed: 1777840083
[2479] Random reseed: 114029754
[2479] Random reseed: 925335035
[2479] Random reseed: 274624510
[2479] Random reseed: 876013511
[2479] Random reseed: 1248795641
[2479] Random reseed: 1592618873
[2479] Random reseed: 1723268990
[2479] Random reseed: 1323432631
[watchdog] pid 2500 hasn't made progress in 30 seconds! (last:1366229804 now:1366229834 diff:30). Stuck in syscall 267:clock_nanosleep. Sending SIGKILL.
[2479] Random reseed: 1034550399
[watchdog] pid 2519 hasn't made progress in 30 seconds! (last:1366229816 now:1366229846 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 419424587
[2479] Random reseed: 132120447
[watchdog] pid 2522 hasn't made progress in 30 seconds! (last:1366229818 now:1366229848 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 948960973
[2479] Random reseed: 1170898940
[watchdog] pid 2506 hasn't made progress in 30 seconds! (last:1366229819 now:1366229849 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1103945701
[2479] Random reseed: 1827191665
[watchdog] pid 2523 hasn't made progress in 30 seconds! (last:1366229834 now:1366229864 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1594752483
[watchdog] pid 2525 hasn't made progress in 30 seconds! (last:1366229846 now:1366229876 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 922701519
[2479] Random reseed: 1300683601
[2479] Random reseed: 1641996031
[2479] Random reseed: 80608187
[watchdog] pid 2527 hasn't made progress in 30 seconds! (last:1366229848 now:1366229878 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 928952311
[2479] Random reseed: 1170116541
[watchdog] pid 2529 hasn't made progress in 30 seconds! (last:1366229851 now:1366229881 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 854117059
[2479] Random reseed: 201283515
[watchdog] pid 2530 hasn't made progress in 30 seconds! (last:1366229864 now:1366229894 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 204160991
[watchdog] pid 2536 hasn't made progress in 30 seconds! (last:1366229880 now:1366229910 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 445116259
[watchdog] pid 2537 hasn't made progress in 30 seconds! (last:1366229882 now:1366229912 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 786726826
[watchdog] 31074 iterations. [F:24848 S:6217]
[watchdog] pid 2538 hasn't made progress in 30 seconds! (last:1366229885 now:1366229915 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1794075103
[watchdog] pid 2539 hasn't made progress in 30 seconds! (last:1366229894 now:1366229924 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 873459006
[2479] Random reseed: 224131583
[2479] Random reseed: 1484750463
[2479] Random reseed: 347070331
[watchdog] pid 2540 hasn't made progress in 30 seconds! (last:1366229910 now:1366229940 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 42991479
[watchdog] pid 2541 hasn't made progress in 30 seconds! (last:1366229912 now:1366229942 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1456465919
[watchdog] pid 2542 hasn't made progress in 30 seconds! (last:1366229915 now:1366229945 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1676668861
[watchdog] pid 2546 hasn't made progress in 30 seconds! (last:1366229934 now:1366229964 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 279900126
[2479] Random reseed: 1060957813
[2479] Random reseed: 960815039
[watchdog] pid 2548 hasn't made progress in 30 seconds! (last:1366229942 now:1366229972 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1794881503
[2479] Random reseed: 1656740863
[2479] Random reseed: 1782448127
[2479] Random reseed: 187561723
[watchdog] pid 2549 hasn't made progress in 30 seconds! (last:1366229945 now:1366229975 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 1348459159
[2479] Random reseed: 231730655
[2479] Random reseed: 584040379
[watchdog] pid 2547 hasn't made progress in 30 seconds! (last:1366229949 now:1366229979 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 627039807
[watchdog] pid 2552 hasn't made progress in 30 seconds! (last:1366229971 now:1366230001 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 126351351
[watchdog] pid 2556 hasn't made progress in 30 seconds! (last:1366229973 now:1366230003 diff:30). Stuck in syscall 11:. Sending SIGKILL.
[2479] Random reseed: 180207613

--------------030008030601000508060109--
