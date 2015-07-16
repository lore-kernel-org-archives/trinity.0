From: Vinson Lee <vlee@twopensource.com>
Subject: "invalid open call: O_CREAT or O_TMPFILE without mode" errors
Date: Thu, 16 Jul 2015 16:38:21 -0700
Message-ID: <CAHTgTXVFGfR0an5DcQKKt7HGmUVWddogDquL-oNMHYA8zfpBAw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hi.

trinity stops running very soon after launch with invalid open call errors.

[main] Generating file descriptors
[main] Added 104 filenames from /dev
[main] Added 70615 filenames from /proc
[main] Added 29037 filenames from /sys
*** invalid open call: O_CREAT or O_TMPFILE without mode ***:
./trinity terminated

Cheers,
Vinson
