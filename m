From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: HEAD of trinity broken on xc86
Date: Fri, 13 May 2016 21:34:17 +0200
Message-ID: <57362C39.2080703@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

Hi,

something between f2ecc0e9a94871ebd8f27daf390516d03a22fa1d and HEAD gives at a x86 chroot (Gentoo Linux) :

tfoerste@n22kvm-clone /mnt/ramdisk $ cd /mnt/ramdisk/; trinity -qqq -C4
Trinity 9  Dave Jones <davej@codemonkey.org.uk>
shm:0xb77a2000-0xc3d8ee84 (4 pages)
[main] Registered 13 fd providers.
Marking all syscalls as enabled.
[main] Enabled 380 syscalls. Disabled 0 syscalls.
[main] Using pid_max = 32768
Free memory: 2.86GB
Low on memory, disabling mmaping of 1GB pages
mmap failure

-- 
Toralf
PGP: C4EACDDE 0076E94E, OTR: 420E74C8 30246EE7
