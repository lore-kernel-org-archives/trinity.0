From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: BUG!: unreachable!
Date: Wed, 01 Oct 2014 19:42:28 +0200
Message-ID: <542C3D04.4030503@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

JJust FWIW with current git tree of trinity I run into this :

[child2:30294] <timed out>
[child2:30294] <timed out>
BUG!: unreachable!

BUG!: 9
BUG!: [30306] generate-args.c:fill_arg:367
[child3:30301] <timed out>
[child3:30301] <timed out>
[child3:30316] <timed out>
BUG!: unreachable!

BUG!: 9
BUG!: [30316] generate-args.c:fill_arg:367
[child0:30306] trinity(show_backtrace+0x32) [0x80551f2]


but I must admit this around the same time where the oom killer killed few tasks within the 32 bit KVM machine whre trintiy was fuzzying the kernel.

-- 
Toralf
pgp key: 0076 E94E
