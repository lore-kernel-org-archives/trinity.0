From: telnetgmike@gmail.com
Subject: How to read and analysis trinity log file?
Date: Thu, 16 Oct 2014 09:42:49 +0800
Message-ID: <0DC6EA8E-0DE3-45AD-875A-9D2974809F7B@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:content-type:content-transfer-encoding:subject:message-id:date
         :to:mime-version;
        bh=DSbc1fKV7iiF8Z2hmmK3P4Kkvwpi2mvyHpMoytyjSao=;
        b=kp4i8+ag8uAkFg686TStAMRmmQfY93esGDOtWR4VdTkQkJp4B/ZHe7olZcatKEVEvr
         18jbrHON30g8iCRSvOy7q54aG9bWoJdEIfhhvEFBujXzYtZ+ejaABRre0JUiZz3saA1y
         bpaO5sbQjhocN5AHXiwiwnegDTTsz/MKninZh96v3DeUfvdevn9A8rJby5z0sh5zRZ2o
         aG1XvHhvD1ZQ4sCOt4UlnlCcCnyfOdtPBf8nsf5Tfu7egvPC+EwiYgJfwncpCbIA0zl2
         obTXjy9i2uUXPKVzfR48DibHcGZqvEb1arqEDRg1eCHF4ZXVrXnkUSeGS8wNgc8sI1VM
         S9Dg==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: trinity@vger.kernel.org

I can use trinity fuzz the linux APIs, and I know where to find the log=
 file, but how to read and analysis the log contents?

[ 3057.388021] traps: trinity-c3[60706] trap divide error ip:4142aa sp:=
7fff6f4b1ad0 error:0 in trinity[400000+2c000]

if there=92s a log item in dmesg, and I can find the serial items from =
trinity-child3.log file, then how can I continue read and track the pro=
blem?
 