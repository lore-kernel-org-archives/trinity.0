From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: trinity: execve() returns 0?
Date: Mon, 12 Dec 2016 13:05:05 +0100
Message-ID: <4ce14b7f-a2bd-e99a-53c9-d80ae3ee27c5@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Jones <davej@codemonkey.org.uk>
Cc: trinity@vger.kernel.org

Hi Dave,

I'm debugging what seems to be a race between execve() and ioctl() (!),
and I noticed that the execve records in the trinity child logs indicate
that it's returning 0:

[child9:20816] [0] 
execve(name="/sys/devices/virtual/bdi/7:5/power/runtime_status", 
argv=0x2cd9b30, envp=0x2ca51e0) = 0
[child9:22112] [0] execve(name="/proc/134/net/pnresource", 
argv=0x2c57130, envp=0x2d01bd0) = 0
[child9:22678] [0] execve(name=".//proc/45/maps", argv=0x2ce5800, 
envp=0x2cfbb70) = 0
[child9:23754] [0] execve(name="/proc/1177/task/1177/net/ipx/socket", 
argv=0x2cf5b10, envp=0x2b431b0) = 0
[child9:23754] [1] 
execve(name="/sys/module/tcp_cubic/parameters/hystart", argv=0x2d1fe60, 
envp=0x2d24f50) = 0
[child9:27614] [0] execve(name="/proc/30/net/stat/rt_cache", 
argv=0x2cf5b10, envp=0x2d07cd0) = 0

I'm guessing this has something to do with the subchild code that
trinity uses (since execve() does not return on success), although I see
other execve calls that do return -1 as expected and I wouldn't expect
execve() on the above files to actually succeed, so I guess the question
is what does the = 0 mean?

Thanks,


Vegard
