From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: git issue
Date: Wed, 1 Jul 2015 15:37:48 +0200
Message-ID: <5593ED2C.50705@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

got today :

$ cd ~/devel/trinity; git pull                       
U       blockdevs.c
U       debug.c
U       rand/random-pathname.c
U       rand/random.c
U       shm.c
U       tools/analyze-sockets.c
U       uid.c
Pull is not possible because you have unmerged files.
Please, fix them up in the work tree, and then use 'git add/rm <file>'
as appropriate to mark resolution and make a commit.


tfoerste@t44 ~/devel/trinity $ git diff

tfoerste@t44 ~/devel/trinity $ git status
On branch master
Your branch and 'origin/master' have diverged,
and have 3702 and 3711 different commits each, respectively.
  (use "git pull" to merge the remote branch into yours)
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

        both added:      blockdevs.c
        both added:      debug.c
        both added:      rand/random-pathname.c
        both added:      rand/random.c
        both added:      shm.c
        both added:      tools/analyze-sockets.c
        both added:      uid.c

no changes added to commit (use "git add" and/or "git commit -a")

tfoerste@t44 ~/devel/trinity $ git diff | patch -R
patch: **** Only garbage was found in the patch input.

tfoerste@t44 ~/devel/trinity $ git diff
tfoerste@t44 ~/devel/trinity $

/me ownders how to solve this - I did not edit loally files AFAICT

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
