From: Dave Jones <davej@redhat.com>
Subject: Re: endless loop open child logfiles
Date: Fri, 29 Aug 2014 16:10:41 -0400
Message-ID: <20140829201041.GA2352@redhat.com>
References: <5400D70F.7040803@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5400D70F.7040803@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

On Fri, Aug 29, 2014 at 09:39:59PM +0200, Toralf F=F6rster wrote:
 > If a (small) file system is fullfilled, then there's an endless loop=
 in opening logiles, tested with 4 childs in a KVM within a 97 MB big B=
TRFS file system created in a file in a ramdisk, commands are :
 >=20
 >=20
 > $> mkdir /mnt/ramdisk/btrfs; truncate -s 97M /mnt/ramdisk/btrfs.fs; =
/sbin/mkfs.btrfs /mnt/ramdisk/btrfs.fs; sudo su -c "mount -o loop,compr=
ess=3Dlzo /mnt/ramdisk/btrfs.fs /mnt/ramdisk/btrfs; chmod 777 /mnt/ramd=
isk/btrfs"
 >=20
 > $> D=3D/mnt/ramdisk/btrfs; while [[ : ]]; do cd ~; sudo rm -rf $D/t3=
; mkdir $D/t3 || break; cd $D/t3; mkdir -p v1/v2; for i in $(seq 0 99);=
 do touch v1/v2/f$i; mkdir v1/v2/d$i; done; trinity -C 4 -N 100000 -V $=
D/t3/v1/v2; echo; echo " done"; echo; sleep 4; done

short on time right now, but try this..

	Dave

diff --git a/include/exit.h b/include/exit.h
index 948ecea02112..ebbaf98cfaac 100644
--- a/include/exit.h
+++ b/include/exit.h
@@ -19,8 +19,9 @@ enum exit_reasons {
 	EXIT_FD_INIT_FAILURE =3D 13,
 	EXIT_FORK_FAILURE =3D 14,
 	EXIT_LOCKING_CATASTROPHE =3D 15,
+	EXIT_LOGFILE_OPEN_ERROR =3D 16,
=20
-	NUM_EXIT_REASONS =3D 16
+	NUM_EXIT_REASONS =3D 17
 };
=20
 const char * decode_exit(void);
diff --git a/log.c b/log.c
index 22b72db86f3c..0ccd1ba45cc9 100644
--- a/log.c
+++ b/log.c
@@ -60,8 +60,10 @@ void open_child_logfile(struct childdata *child)
 	sprintf(logfilename, "trinity-child%u.log", child->num);
=20
 	child->logfile =3D open_logfile(logfilename);
-	if (!child->logfile)
+	if (!child->logfile) {
+		shm->exit_reason =3D EXIT_LOGFILE_OPEN_ERROR;
 		exit(EXIT_FAILURE);
+	}
=20
 	free(logfilename);
=20
diff --git a/main.c b/main.c
index 5541de09ae7e..ed3d02c0d4e5 100644
--- a/main.c
+++ b/main.c
@@ -295,6 +295,7 @@ static const char *reasons[NUM_EXIT_REASONS] =3D {
 	"Something happened during fd init.",
 	"fork() failure",
 	"some kind of locking catastrophe",
+	"error while opening logfiles",
 };
=20
 const char * decode_exit(void)
