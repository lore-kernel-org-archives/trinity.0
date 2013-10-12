From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: [RFC] specify multiple victims directories
Date: Sat, 12 Oct 2013 20:18:14 +0200
Message-ID: <52599266.9080907@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: trinity@vger.kernel.org

Currently I can specify 1 directory which is usually a NFS share.
But that means that I'm just able to test 1 NFS version at a time.
Specifying multiple NFS directories would allow to mix NFS v[234[.[12]]=
]
calls together.

Symlinking into 1 directory and giving thats name to trinity is not a
solution b/c those symlinks would be mangeld by trinity itself soon.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
