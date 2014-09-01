From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: hang in creating the trinity-testfileX
Date: Mon, 01 Sep 2014 19:53:47 +0200
Message-ID: <5404B2AB.8080500@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

Trinity sometimes hangs infinitely in a KVM while trying to create the testfiles, eg .:

...
[main] fd[668] = timerfd
[main] fd[669] = fopen("trinity-testfile1", O_RDWR)
[main] fd[670] = fopen("trinity-testfile2", O_RDWR)


Ctrl-C works fortunately

-- 
Toralf
pgp key: 0076 E94E
