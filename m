From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: endless loop open child logfiles
Date: Fri, 29 Aug 2014 21:39:59 +0200
Message-ID: <5400D70F.7040803@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

If a (small) file system is fullfilled, then there's an endless loop in opening logiles, tested with 4 childs in a KVM within a 97 MB big BTRFS file system created in a file in a ramdisk, commands are :


$> mkdir /mnt/ramdisk/btrfs; truncate -s 97M /mnt/ramdisk/btrfs.fs; /sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compress=lzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramdisk/btrfs"

$> D=/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3; mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99); do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 4 -N 100000 -V $D/t3/v1/v2; echo; echo " done"; echo; sleep 4; done


-- 
Toralf
pgp key: 0076 E94E
