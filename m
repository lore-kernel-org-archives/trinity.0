From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: BUG: soft lockup for a user mode linux image
Date: Wed, 02 Oct 2013 20:31:25 +0200
Message-ID: <524C667D.702@gmx.de>
References: <524C6643.2040209@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090301050601080804050205"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <524C6643.2040209@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: trinity@vger.kernel.org
Cc: UML devel <user-mode-linux-devel@lists.sourceforge.net>

This is a multi-part message in MIME format.
--------------090301050601080804050205
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

(resend - now with attached files)

Running trinity (1 process, no victim files, just "$>trinity -C1) for a longer time 
within a 32 bit user mode linux image with a recent git kernel (host: 3.11.3 guest 3.12-rc3-g...)
yields into this konsole message :

 * Starting local
net.core.warnings = 0                                                                         [ ok ]
BUG: soft lockup - CPU#0 stuck for 23s! [trinity-child0:2031]


and at the host t1 of the "linux"-processes eats all CPU cycles at 1 CPU core.
2 subsequent made back traces made with

$> sudo gdb /home/tfoerste/devel/linux/linux 28144 -n -batch -ex bt

shows nearly a similar position around __get_user_pages() - both are attached.

I'm not surprised that trinity harms a systems - I'm just wondering whether this particular picture is
expected or if it points to an issue.


FWIW the last lines of trinity log were :


[2031] [94] setsid() = 2031
[2031] [95] setresgid(rgid=0xffff33e3, egid=0xffffff93, sgid=0x22000040) = -1 (Operation not permitted)
[2031] [96] vmsplice(fd=5, iov=0x85501e0, nr_segs=300, flags=9) = 0x3000
[2031] [97] setresuid(ruid=0x80549193, euid=0xc61041e0, suid=0xff19b6fa) = -1 (Operation not permitted)
[2031] [98] setpriority(which=0xff010000, who=0xf3737373, niceval=0x8088960c) = -1 (Invalid argument)
[2031] [99] socketcall(call=1, args=0x8550200) = -1 (Address family not supported by protocol)
[2031] [100] access(filename="�", mode=2017) = -1 (Invalid argument)
[2031] [101] getgroups(gidsetsize=0, grouplist=0x80d0000[page_rand]) = 3
[2031] [102] msync(start=0xc0100220, len=0, flags=3) = -1 (Invalid argument)
[2031] [103] sigpending(set=0x40025000) = 0
[2031] [104] signalfd4(ufd=383, user_mask=1, sizemask=0xa4200000, flags=0x80800) = -1 (Invalid argument)
[2031] [105] sendfile(out_fd=383, in_fd=382, offset=0, count=4096) = -1 (Invalid argument)
[2031] [106] fanotify_mark(fanotify_fd=382, flags=5, mask=0x8000023, dfd=382, pathname="/proc/1092/task/1092/fdinfo/68") = -1 (Invalid argument)
[2031] [107] wait4(upid=1, stat_addr=4, options=0xd761979b, ru=8) = -1 (Invalid argument)
[2031] [108] sigpending(set=0x80ca000[page_zeros]) = 0
[2031] [109] setresuid(ruid=0xefffd6fc, euid=0x1bf4c92f, suid=0xffff2e33) = -1 (Operation not permitted)
[2031] [110] munlock(addr=0x40025000, len=34) = 0
[2031] [111] timer_delete(timer_id=0xffffffdc) = -1 (Invalid argument)
[2031] [112] sched_get_priority_max(policy=0x10000040) = -1 (Invalid argument)
[2031] [113] syslog(type=0xc1000000, buf=1, len=0x82a5) = -1 (Operation not permitted)
[2031] [114] setpriority(which=0xc4c806c6, who=0xffffff01, niceval=0xffff0682) = -1 (Invalid argument)
[2031] [115] getgroups16(gidsetsize=0xfffe, grouplist=1) = -1 (Bad address)
[2031] [116] rename(oldname=4, newname=8) = -1 (Bad address)
[2031] [117] inotify_init() = 654
[2031] [118] getgid() = 100
[2031] [119] fstatat64(dfd=382, filename="/sys/devices/virtual/net/sit0/duplex", statbuf=0, flag=0xb545d727) = -1 (Invalid argument)
[2031] [120] unlinkat(dfd=382, pathname="/proc/sys/net/ipv4/neigh/default/retrans_time", flag=0xc00ef76) = -1 (Invalid argument)
[2031] [121] timerfd_create(clockid=0, flags=0) = 655
[2031] [122] munlock(addr=4, len=0x3fff) = -1 (Cannot allocate memory)
[2031] [123] fremovexattr(fd=382, name=0) = -1 (Bad address)
[2031] [124] sched_get_priority_min(policy=0xff58bfef) = -1 (Invalid argument)
[2031] [125] mq_timedreceive(mqdes=397, u_msg_ptr=4, msg_len=5245, u_msg_prio=0xc0100220, u_abs_timeout=0xc0100220) = -1 (Bad address)
[2031] [126] chdir(filename="/proc/116/net/ptype") = -1 (Not a directory)
[2031] [127] ssetmask(newmask=0x88000092) = 0
[2031] [128] statfs(pathname="/proc/6/mounts", buf=0) = -1 (Bad address)
[2031] [129] fchown16(fd=397, user=104, group=0x94100000) = -1 (Operation not permitted)
[2031] [130] fchdir(fd=397) = -1 (Not a directory)
[2031] [131] mkdir(pathname="/proc/1092/task/1092/fdinfo/316", mode=525) = -1 (File exists)
[2031] [132] fsetxattr(fd=386, name=0x856f158, value=0x8571160, size=0, flags=0) = -1 (Numerical result out of range)
[2031] [133] io_setup(nr_events=4095, ctxp=0x40266000) ^CKilled by signal 2.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3



--------------090301050601080804050205
Content-Type: text/plain; charset=UTF-8;
 name="1"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="1"

MHgwODI5NDllNCBpbiBudW1iZXIgKGJ1Zj0weDQzNGRmYjIxICIvS1xiXDIyNVwwMzZgXGJc
MjQzXktcYlwyNDNeS1xiRFwzNzNNQ1wyMTBcMjQ3XHRcYiIsIGVuZD0weDQzNGRmYjIyICJL
XGJcMjI1XDAzNmBcYlwyNDNeS1xiXDI0M15LXGJEXDM3M01DXDIxMFwyNDdcdFxiIiwgbnVt
PTU5NzY5OTc1MjI2ODM2Mjk0Niwgc3BlYz0uLi4pIGF0IGxpYi92c3ByaW50Zi5jOjM4MQoz
ODEJY2hhciAqbnVtYmVyKGNoYXIgKmJ1ZiwgY2hhciAqZW5kLCB1bnNpZ25lZCBsb25nIGxv
bmcgbnVtLAojMCAgMHgwODI5NDllNCBpbiBudW1iZXIgKGJ1Zj0weDQzNGRmYjIxICIvS1xi
XDIyNVwwMzZgXGJcMjQzXktcYlwyNDNeS1xiRFwzNzNNQ1wyMTBcMjQ3XHRcYiIsIGVuZD0w
eDQzNGRmYjIyICJLXGJcMjI1XDAzNmBcYlwyNDNeS1xiXDI0M15LXGJEXDM3M01DXDIxMFwy
NDdcdFxiIiwgbnVtPTU5NzY5OTc1MjI2ODM2Mjk0Niwgc3BlYz0uLi4pIGF0IGxpYi92c3By
aW50Zi5jOjM4MQojMSAgMHgwODI5NWVmNyBpbiB2c25wcmludGYgKGJ1Zj0weDQzNGRmYjFj
ICIrMHg1Mi9LXGJcMjI1XDAzNmBcYlwyNDNeS1xiXDI0M15LXGJEXDM3M01DXDIxMFwyNDdc
dFxiIiwgc2l6ZT0yMTQ3NDgzNjQ3LCBmbXQ9MHg4NGI3NGMyICIiLCBhcmdzPTB4NDM0ZGZh
ZDAgIlx0XDM3M01DIikgYXQgbGliL3ZzcHJpbnRmLmM6MTc0MAojMiAgMHgwODI5NjU0NyBp
biBzcHJpbnRmIChidWY9MHg0MzRkZmIyMiAiS1xiXDIyNVwwMzZgXGJcMjQzXktcYlwyNDNe
S1xiRFwzNzNNQ1wyMTBcMjQ3XHRcYiIsIGZtdD0weDQzNGRmYjIyICJLXGJcMjI1XDAzNmBc
YlwyNDNeS1xiXDI0M15LXGJEXDM3M01DXDIxMFwyNDdcdFxiIikgYXQgbGliL3ZzcHJpbnRm
LmM6MTg3NQojMyAgMHgwODBiNzZjZiBpbiBfX3NwcmludF9zeW1ib2wgKGJ1ZmZlcj0weDQz
NGRmYjA5ICJpb19zY2hlZHVsZV90aW1lb3V0KzB4NTIvS1xiXDIyNVwwMzZgXGJcMjQzXktc
YlwyNDNeS1xiRFwzNzNNQ1wyMTBcMjQ3XHRcYiIsIGFkZHJlc3M9MzI3NjY2NzY3NSwgc3lt
Ym9sX29mZnNldD0xLCBhZGRfb2Zmc2V0PTEpIGF0IGtlcm5lbC9rYWxsc3ltcy5jOjM3NAoj
NCAgMHgwODBiNzgxYSBpbiBzcHJpbnRfc3ltYm9sIChidWZmZXI9MHg0MzRkZmIwOSAiaW9f
c2NoZWR1bGVfdGltZW91dCsweDUyL0tcYlwyMjVcMDM2YFxiXDI0M15LXGJcMjQzXktcYkRc
MzczTUNcMjEwXDI0N1x0XGIiLCBhZGRyZXNzPTEzODUwMzAxMCkgYXQga2VybmVsL2thbGxz
eW1zLmM6Mzk1CiM1ICAweDA4MGI3ODdmIGluIF9fcHJpbnRfc3ltYm9sIChmbXQ9MHg0MzRk
ZmIyMiAiS1xiXDIyNVwwMzZgXGJcMjQzXktcYlwyNDNeS1xiRFwzNzNNQ1wyMTBcMjQ3XHRc
YiIsIGFkZHJlc3M9MTEyOTE4NDAzNCkgYXQga2VybmVsL2thbGxzeW1zLmM6NDQwCiM2ICAw
eDA4MDc4MjAwIGluIHByaW50X3N5bWJvbCAoZm10PTxvcHRpbWl6ZWQgb3V0PiwgYWRkcj08
b3B0aW1pemVkIG91dD4pIGF0IGluY2x1ZGUvbGludXgva2FsbHN5bXMuaDoxMTkKIzcgIHBy
aW50X2NvbnRleHRfc3RhY2sgKGVicD08b3B0aW1pemVkIG91dD4sIHRpbmZvPTxvcHRpbWl6
ZWQgb3V0Piwgc3RhY2s9PG9wdGltaXplZCBvdXQ+KSBhdCBhcmNoL3g4Ni91bS9zeXNycV8z
Mi5jOjU0CiM4ICBzaG93X3RyYWNlICh0YXNrPTB4NDM0ZGZmZmQsIHN0YWNrPTB4NDM0ZGZj
NDQpIGF0IGFyY2gveDg2L3VtL3N5c3JxXzMyLmM6OTUKIzkgIDB4MDgwNWZiNmYgaW4gc2hv
d19zdGFjayAodGFzaz0weDAsIGVzcD0weDQzNGRmYzQ0KSBhdCBhcmNoL3VtL2tlcm5lbC9z
eXNycS5jOjY1CiMxMCAweDA4NDEzYWU2IGluIF9fZHVtcF9zdGFjayAoKSBhdCBsaWIvZHVt
cF9zdGFjay5jOjE1CiMxMSBkdW1wX3N0YWNrICgpIGF0IGxpYi9kdW1wX3N0YWNrLmM6NjAK
IzEyIDB4MDg0MTQ5ODEgaW4gc2NoZWR1bGVfdGltZW91dCAodGltZW91dD0tNDAyOCkgYXQg
a2VybmVsL3RpbWVyLmM6MTQ2MAojMTMgMHgwODQxNjM2MiBpbiBpb19zY2hlZHVsZV90aW1l
b3V0ICh0aW1lb3V0PTExMjkxODQwMzQpIGF0IGtlcm5lbC9zY2hlZC9jb3JlLmM6Mzk5Mgoj
MTQgMHgwODQxMWMzMSBpbiBiYWxhbmNlX2RpcnR5X3BhZ2VzIChwYWdlc19kaXJ0aWVkPTE3
LCBtYXBwaW5nPTxvcHRpbWl6ZWQgb3V0PikgYXQgbW0vcGFnZS13cml0ZWJhY2suYzoxNTE5
CiMxNSAweDA4MGQxY2U0IGluIGJhbGFuY2VfZGlydHlfcGFnZXNfcmF0ZWxpbWl0ZWQgKG1h
cHBpbmc9MHg2MCkgYXQgbW0vcGFnZS13cml0ZWJhY2suYzoxNjUzCiMxNiAweDA4MGUyZDBj
IGluIF9fZG9fZmF1bHQgKG1tPTB4NDdmMjQ0MDAsIHZtYT0weDQ0MjA5NWQ4LCBhZGRyZXNz
PTEwODA0NTEwNzIsIHBtZD0weDQzNGRmYjIyLCBwZ29mZj0xMTI5MTg0MDM0LCBmbGFncz0x
MTU1MDExNDE2LCBvcmlnX3B0ZT08aW5jb21wbGV0ZSB0eXBlPikgYXQgbW0vbWVtb3J5LmM6
MzQ1MgojMTcgMHgwODBlNTI4NiBpbiBkb19ub25saW5lYXJfZmF1bHQgKG9yaWdfcHRlPS4u
LiwgZmxhZ3M9PG9wdGltaXplZCBvdXQ+LCBwbWQ9PG9wdGltaXplZCBvdXQ+LCBhZGRyZXNz
PTxvcHRpbWl6ZWQgb3V0Piwgdm1hPTxvcHRpbWl6ZWQgb3V0PiwgbW09PG9wdGltaXplZCBv
dXQ+LCBwYWdlX3RhYmxlPTxvcHRpbWl6ZWQgb3V0PikgYXQgbW0vbWVtb3J5LmM6MzUxOAoj
MTggaGFuZGxlX3B0ZV9mYXVsdCAoZmxhZ3M9PG9wdGltaXplZCBvdXQ+LCBwbWQ9PG9wdGlt
aXplZCBvdXQ+LCBwdGU9PG9wdGltaXplZCBvdXQ+LCBhZGRyZXNzPTxvcHRpbWl6ZWQgb3V0
Piwgdm1hPTxvcHRpbWl6ZWQgb3V0PiwgbW09PG9wdGltaXplZCBvdXQ+KSBhdCBtbS9tZW1v
cnkuYzozNzE3CiMxOSBfX2hhbmRsZV9tbV9mYXVsdCAoZmxhZ3M9PG9wdGltaXplZCBvdXQ+
LCBhZGRyZXNzPTxvcHRpbWl6ZWQgb3V0Piwgdm1hPTxvcHRpbWl6ZWQgb3V0PiwgbW09PG9w
dGltaXplZCBvdXQ+KSBhdCBtbS9tZW1vcnkuYzozODQ1CiMyMCBoYW5kbGVfbW1fZmF1bHQg
KG1tPTB4NDdmMjQ0MDAsIHZtYT0weDQ0MjA5NWQ4LCBhZGRyZXNzPTEwODA0NTEwNzIsIGZs
YWdzPTEpIGF0IG1tL21lbW9yeS5jOjM4NjgKIzIxIDB4MDgwZTVhMDcgaW4gX19nZXRfdXNl
cl9wYWdlcyAodHNrPTB4NDZlMjM2MDAsIG1tPTB4NDdmMjQ0MDAsIHN0YXJ0PTEwODA0NTEw
NzIsIG5yX3BhZ2VzPTY1LCBndXBfZmxhZ3M9NTE5LCBwYWdlcz0weDQ2ZjM0ZDIwLCB2bWFz
PTB4MCwgbm9uYmxvY2tpbmc9MHgwKSBhdCBtbS9tZW1vcnkuYzoxODIyCiMyMiAweDA4MGU1
Y2MzIGluIGdldF91c2VyX3BhZ2VzICh0c2s9MHg0MzRkZmIyMiwgbW09MHg0MzRkZmIyMiwg
c3RhcnQ9MTEyOTE4NDAzNCwgbnJfcGFnZXM9MTEyOTE4NDAzNCwgd3JpdGU9MSwgZm9yY2U9
MCwgcGFnZXM9MHhjMzRkZmIxYiwgdm1hcz0weDYwKSBhdCBtbS9tZW1vcnkuYzoyMDE5CiMy
MyAweDA4MTQwY2NlIGluIGFpb19zZXR1cF9yaW5nIChjdHg9PG9wdGltaXplZCBvdXQ+KSBh
dCBmcy9haW8uYzozMTcKIzI0IGlvY3R4X2FsbG9jIChucl9ldmVudHM9PG9wdGltaXplZCBv
dXQ+KSBhdCBmcy9haW8uYzo1ODIKIzI1IFNZU0NfaW9fc2V0dXAgKGN0eHA9PG9wdGltaXpl
ZCBvdXQ+LCBucl9ldmVudHM9PG9wdGltaXplZCBvdXQ+KSBhdCBmcy9haW8uYzoxMTAwCiMy
NiBTeVNfaW9fc2V0dXAgKG5yX2V2ZW50cz00MDk1LCBjdHhwPTEwNzYyNTY3NjgpIGF0IGZz
L2Fpby5jOjEwODMKIzI3IDB4MDgwNjE5YzIgaW4gaGFuZGxlX3N5c2NhbGwgKHI9MHg0NmUy
MzdkNCkgYXQgYXJjaC91bS9rZXJuZWwvc2thcy9zeXNjYWxsLmM6MzUKIzI4IDB4MDgwNzNm
MmQgaW4gaGFuZGxlX3RyYXAgKGxvY2FsX3VzaW5nX3N5c2VtdT08b3B0aW1pemVkIG91dD4s
IHJlZ3M9PG9wdGltaXplZCBvdXQ+LCBwaWQ9PG9wdGltaXplZCBvdXQ+KSBhdCBhcmNoL3Vt
L29zLUxpbnV4L3NrYXMvcHJvY2Vzcy5jOjE5OAojMjkgdXNlcnNwYWNlIChyZWdzPTB4NDZl
MjM3ZDQpIGF0IGFyY2gvdW0vb3MtTGludXgvc2thcy9wcm9jZXNzLmM6NDMxCiMzMCAweDA4
MDVlNmFjIGluIGZvcmtfaGFuZGxlciAoKSBhdCBhcmNoL3VtL2tlcm5lbC9wcm9jZXNzLmM6
MTYwCiMzMSAweDAwMDAwMDAwIGluID8/ICgpCg==
--------------090301050601080804050205
Content-Type: text/plain; charset=UTF-8;
 name="2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="2"

Zm9ybWF0X2RlY29kZSAoZm10PTB4ODRiNzRiOCAiKyUjbHgvJSNseCIsIHNwZWM9MHg0MzRk
ZmE4YykgYXQgbGliL3ZzcHJpbnRmLmM6MTM3NQoxMzc1CQlpZiAoc3BlYy0+dHlwZSA9PSBG
T1JNQVRfVFlQRV9XSURUSCkgewojMCAgZm9ybWF0X2RlY29kZSAoZm10PTB4ODRiNzRiOCAi
KyUjbHgvJSNseCIsIHNwZWM9MHg0MzRkZmE4YykgYXQgbGliL3ZzcHJpbnRmLmM6MTM3NQoj
MSAgMHgwODI5NWI4MiBpbiB2c25wcmludGYgKGJ1Zj0weDQzNGRmYjE5ICIiLCBzaXplPTIx
NDc0ODM2NDcsIGZtdD0weDg0Yjc0YjggIislI2x4LyUjbHgiLCBhcmdzPTB4NDM0ZGZhYzgg
IkEiKSBhdCBsaWIvdnNwcmludGYuYzoxNjE1CiMyICAweDA4Mjk2NTQ3IGluIHNwcmludGYg
KGJ1Zj0weDg0Yjc0YjggIislI2x4LyUjbHgiLCBmbXQ9MHg4NGI3NGI4ICIrJSNseC8lI2x4
IikgYXQgbGliL3ZzcHJpbnRmLmM6MTg3NQojMyAgMHgwODBiNzZjZiBpbiBfX3NwcmludF9z
eW1ib2wgKGJ1ZmZlcj0weDQzNGRmYjA5ICJzY2hlZHVsZV90aW1lb3V0IiwgYWRkcmVzcz0x
MTI5MTgzODg0LCBzeW1ib2xfb2Zmc2V0PTEsIGFkZF9vZmZzZXQ9MSkgYXQga2VybmVsL2th
bGxzeW1zLmM6Mzc0CiM0ICAweDA4MGI3ODFhIGluIHNwcmludF9zeW1ib2wgKGJ1ZmZlcj0w
eDQzNGRmYjA5ICJzY2hlZHVsZV90aW1lb3V0IiwgYWRkcmVzcz0xMzg0OTYzODUpIGF0IGtl
cm5lbC9rYWxsc3ltcy5jOjM5NQojNSAgMHgwODBiNzg3ZiBpbiBfX3ByaW50X3N5bWJvbCAo
Zm10PTB4ODRiNzRiOCAiKyUjbHgvJSNseCIsIGFkZHJlc3M9MTM5MTYyODA4KSBhdCBrZXJu
ZWwva2FsbHN5bXMuYzo0NDAKIzYgIDB4MDgwNzgyMDAgaW4gcHJpbnRfc3ltYm9sIChmbXQ9
PG9wdGltaXplZCBvdXQ+LCBhZGRyPTxvcHRpbWl6ZWQgb3V0PikgYXQgaW5jbHVkZS9saW51
eC9rYWxsc3ltcy5oOjExOQojNyAgcHJpbnRfY29udGV4dF9zdGFjayAoZWJwPTxvcHRpbWl6
ZWQgb3V0PiwgdGluZm89PG9wdGltaXplZCBvdXQ+LCBzdGFjaz08b3B0aW1pemVkIG91dD4p
IGF0IGFyY2gveDg2L3VtL3N5c3JxXzMyLmM6NTQKIzggIHNob3dfdHJhY2UgKHRhc2s9MHg0
MzRkZmZmZCwgc3RhY2s9MHg0MzRkZmM0NCkgYXQgYXJjaC94ODYvdW0vc3lzcnFfMzIuYzo5
NQojOSAgMHgwODA1ZmI2ZiBpbiBzaG93X3N0YWNrICh0YXNrPTB4MCwgZXNwPTB4NDM0ZGZj
NDQpIGF0IGFyY2gvdW0va2VybmVsL3N5c3JxLmM6NjUKIzEwIDB4MDg0MTNhZTYgaW4gX19k
dW1wX3N0YWNrICgpIGF0IGxpYi9kdW1wX3N0YWNrLmM6MTUKIzExIGR1bXBfc3RhY2sgKCkg
YXQgbGliL2R1bXBfc3RhY2suYzo2MAojMTIgMHgwODQxNDk4MSBpbiBzY2hlZHVsZV90aW1l
b3V0ICh0aW1lb3V0PS00MDI4KSBhdCBrZXJuZWwvdGltZXIuYzoxNDYwCiMxMyAweDA4NDE2
MzYyIGluIGlvX3NjaGVkdWxlX3RpbWVvdXQgKHRpbWVvdXQ9MTM5MTYyODA4KSBhdCBrZXJu
ZWwvc2NoZWQvY29yZS5jOjM5OTIKIzE0IDB4MDg0MTFjMzEgaW4gYmFsYW5jZV9kaXJ0eV9w
YWdlcyAocGFnZXNfZGlydGllZD0xNywgbWFwcGluZz08b3B0aW1pemVkIG91dD4pIGF0IG1t
L3BhZ2Utd3JpdGViYWNrLmM6MTUxOQojMTUgMHgwODBkMWNlNCBpbiBiYWxhbmNlX2RpcnR5
X3BhZ2VzX3JhdGVsaW1pdGVkIChtYXBwaW5nPTB4MTEpIGF0IG1tL3BhZ2Utd3JpdGViYWNr
LmM6MTY1MwojMTYgMHgwODBlMmQwYyBpbiBfX2RvX2ZhdWx0IChtbT0weDQ3ZjI0NDAwLCB2
bWE9MHg0NDIwOTVkOCwgYWRkcmVzcz0xMDgwNDUxMDcyLCBwbWQ9MHg4NGI3NGI4LCBwZ29m
Zj0xMzkxNjI4MDgsIGZsYWdzPTExNTUwMTE0MTYsIG9yaWdfcHRlPTxpbmNvbXBsZXRlIHR5
cGU+KSBhdCBtbS9tZW1vcnkuYzozNDUyCiMxNyAweDA4MGU1Mjg2IGluIGRvX25vbmxpbmVh
cl9mYXVsdCAob3JpZ19wdGU9Li4uLCBmbGFncz08b3B0aW1pemVkIG91dD4sIHBtZD08b3B0
aW1pemVkIG91dD4sIGFkZHJlc3M9PG9wdGltaXplZCBvdXQ+LCB2bWE9PG9wdGltaXplZCBv
dXQ+LCBtbT08b3B0aW1pemVkIG91dD4sIHBhZ2VfdGFibGU9PG9wdGltaXplZCBvdXQ+KSBh
dCBtbS9tZW1vcnkuYzozNTE4CiMxOCBoYW5kbGVfcHRlX2ZhdWx0IChmbGFncz08b3B0aW1p
emVkIG91dD4sIHBtZD08b3B0aW1pemVkIG91dD4sIHB0ZT08b3B0aW1pemVkIG91dD4sIGFk
ZHJlc3M9PG9wdGltaXplZCBvdXQ+LCB2bWE9PG9wdGltaXplZCBvdXQ+LCBtbT08b3B0aW1p
emVkIG91dD4pIGF0IG1tL21lbW9yeS5jOjM3MTcKIzE5IF9faGFuZGxlX21tX2ZhdWx0IChm
bGFncz08b3B0aW1pemVkIG91dD4sIGFkZHJlc3M9PG9wdGltaXplZCBvdXQ+LCB2bWE9PG9w
dGltaXplZCBvdXQ+LCBtbT08b3B0aW1pemVkIG91dD4pIGF0IG1tL21lbW9yeS5jOjM4NDUK
IzIwIGhhbmRsZV9tbV9mYXVsdCAobW09MHg0N2YyNDQwMCwgdm1hPTB4NDQyMDk1ZDgsIGFk
ZHJlc3M9MTA4MDQ1MTA3MiwgZmxhZ3M9MSkgYXQgbW0vbWVtb3J5LmM6Mzg2OAojMjEgMHgw
ODBlNWEwNyBpbiBfX2dldF91c2VyX3BhZ2VzICh0c2s9MHg0NmUyMzYwMCwgbW09MHg0N2Yy
NDQwMCwgc3RhcnQ9MTA4MDQ1MTA3MiwgbnJfcGFnZXM9NjUsIGd1cF9mbGFncz01MTksIHBh
Z2VzPTB4NDZmMzRkMjAsIHZtYXM9MHgwLCBub25ibG9ja2luZz0weDApIGF0IG1tL21lbW9y
eS5jOjE4MjIKIzIyIDB4MDgwZTVjYzMgaW4gZ2V0X3VzZXJfcGFnZXMgKHRzaz0weDg0Yjc0
YjgsIG1tPTB4ODRiNzRiOCwgc3RhcnQ9MTM5MTYyODA4LCBucl9wYWdlcz0xMzkxNjI4MDgs
IHdyaXRlPTEsIGZvcmNlPTAsIHBhZ2VzPTB4NDM0ZGZhOGMsIHZtYXM9MHgxMSkgYXQgbW0v
bWVtb3J5LmM6MjAxOQojMjMgMHgwODE0MGNjZSBpbiBhaW9fc2V0dXBfcmluZyAoY3R4PTxv
cHRpbWl6ZWQgb3V0PikgYXQgZnMvYWlvLmM6MzE3CiMyNCBpb2N0eF9hbGxvYyAobnJfZXZl
bnRzPTxvcHRpbWl6ZWQgb3V0PikgYXQgZnMvYWlvLmM6NTgyCiMyNSBTWVNDX2lvX3NldHVw
IChjdHhwPTxvcHRpbWl6ZWQgb3V0PiwgbnJfZXZlbnRzPTxvcHRpbWl6ZWQgb3V0PikgYXQg
ZnMvYWlvLmM6MTEwMAojMjYgU3lTX2lvX3NldHVwIChucl9ldmVudHM9NDA5NSwgY3R4cD0x
MDc2MjU2NzY4KSBhdCBmcy9haW8uYzoxMDgzCiMyNyAweDA4MDYxOWMyIGluIGhhbmRsZV9z
eXNjYWxsIChyPTB4NDZlMjM3ZDQpIGF0IGFyY2gvdW0va2VybmVsL3NrYXMvc3lzY2FsbC5j
OjM1CiMyOCAweDA4MDczZjJkIGluIGhhbmRsZV90cmFwIChsb2NhbF91c2luZ19zeXNlbXU9
PG9wdGltaXplZCBvdXQ+LCByZWdzPTxvcHRpbWl6ZWQgb3V0PiwgcGlkPTxvcHRpbWl6ZWQg
b3V0PikgYXQgYXJjaC91bS9vcy1MaW51eC9za2FzL3Byb2Nlc3MuYzoxOTgKIzI5IHVzZXJz
cGFjZSAocmVncz0weDQ2ZTIzN2Q0KSBhdCBhcmNoL3VtL29zLUxpbnV4L3NrYXMvcHJvY2Vz
cy5jOjQzMQojMzAgMHgwODA1ZTZhYyBpbiBmb3JrX2hhbmRsZXIgKCkgYXQgYXJjaC91bS9r
ZXJuZWwvcHJvY2Vzcy5jOjE2MAojMzEgMHgwMDAwMDAwMCBpbiA/PyAoKQo=
--------------090301050601080804050205--
