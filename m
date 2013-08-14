From: Frank H <houf99@gmail.com>
Subject: have 3 entrypoints in trinity list on CentOS 6
Date: Wed, 14 Aug 2013 08:05:55 +0000 (UTC)
Message-ID: <loom.20130814T100045-787@post.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

Hi All:

I'm beginner for Trinity tool, it's very good. Thanks a lot.

When try command ./trinity -L , got some syscalls have 3 entrypoint , e.g:
32-bit entrypoint 28 fstatfs : Enabled
32-bit entrypoint 100 fstatfs : Enabled
64-bit entrypoint 138 fstatfs : Enabled
...
32-bit entrypoint 109 uname : Enabled
32-bit entrypoint 122 uname : Enabled
64-bit entrypoint 63 uname : Enabled
...
32-bit entrypoint 187 sendfile : Enabled
32-bit entrypoint 239 sendfile : Enabled
64-bit entrypoint 40 sendfile : Enabled
...
32-bit entrypoint 82 select : Enabled AVOID
32-bit entrypoint 142 select : Enabled AVOID
64-bit entrypoint 23 select : Enabled AVOID
...
32-bit entrypoint 76 getrlimit : Enabled
32-bit entrypoint 191 getrlimit : Enabled
64-bit entrypoint 97 getrlimit : Enabled
...

And seems only two of them syscalls are using in testing; I'm using "Latest
release is v1.2, released on Jul 22nd 2013" on CentOS6.4, not sure it's my
test bed issue, please help to check.

Thanks.
Frank

