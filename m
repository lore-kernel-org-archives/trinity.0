From: "telnetgmike@gmail.com" <telnetgmike@gmail.com>
Subject: How to read and analysis trinity log file?
Date: Thu, 16 Oct 2014 09:39:12 +0800
Message-ID: <7D20CBCE-B72A-42DF-94FE-B10034EF1588@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:content-type:content-transfer-encoding:subject:message-id:date
         :to:mime-version;
        bh=DSbc1fKV7iiF8Z2hmmK3P4Kkvwpi2mvyHpMoytyjSao=;
        b=fzrOB9yEEhY+U5lk6Oo+/i3JX8jJpkn3xSNWq5+KC/HjGbzH1iP96xVyz+BPyJVnNt
         FHciiktZhA3jcyFbXUdUwVMEN9H/A7lETvixy3K89KMeL50yzejOnSlkbbHP/VT75+zD
         +wvQhIFAQMWGHky2D7Bv1ckJ4mtvYdYWHGW0AyDV0yrUhQb6lIdrFomoBry76uBOdtvb
         lScpZNA/JNJn38b7oS8cq3wQcbl5s4QJ7xDegOCMO2TkQBlX17N7yQiRW0+u6iIrzMmZ
         AyY8w2eIVgWXR1CN6BnAva7r/1VKkHG6ujWDHlp//qZBjjc62g56V18KGqWufneBfR2+
         8SnA==
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
 