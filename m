From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: [child0:1694] <timed out>
Date: Thu, 14 Aug 2014 19:17:48 +0200
Message-ID: <53ECEF3C.3080604@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

With latest git tree I do get now a lot of lines like :

[child0:1694] <timed out>
[child0:1694] <timed out>
[child0:1694] <timed out>
[child1:1695] <timed out>
[child0:1694] <timed out>
[child0:1694] <timed out>
[child1:1695] <timed out>

for a command like this: MALLOC_CHECK_=2 trinity -C 2 -N 100000 -x mremap -q -V /tmp/victims/v1/v2

It is intended ?


-- 
Toralf
