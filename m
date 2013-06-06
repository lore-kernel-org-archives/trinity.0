From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] syscalls: use sizeof instead of hard code define
Date: Thu, 06 Jun 2013 17:23:01 +0200
Message-ID: <51B0A955.8060300@redhat.com>
References: <cover.1370285968.git.dborkman@redhat.com> <1bdeb13f75006abc2d8ef622c7bf56f7627ad082.1370285968.git.dborkman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1bdeb13f75006abc2d8ef622c7bf56f7627ad082.1370285968.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: trinity@vger.kernel.org

There's ARRAY_SIZE(x) in include/trinity.h for this purpose. Please
send a v2 with using this instead of hard-coding.

Thanks,

Daniel
