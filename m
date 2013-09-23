From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fixed several FIXME items, removed unnecessary search
 over syscall names.
Date: Mon, 23 Sep 2013 09:35:34 -0400
Message-ID: <20130923133534.GA8971@redhat.com>
References: <alpine.DEB.2.02.1309201553510.393@ildarm-linux.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309201553510.393@ildarm-linux.kir.corp.google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Fri, Sep 20, 2013 at 04:05:02PM -0700, Ildar Muslukhov wrote:
 > 
 > Hello everyone,
 > 
 > This isn't small patch but most of it was to remove silly loop in the 
 > child_random_syscalls function. The way I did it is by introducing an 
 > array of activated syscalls, which contains an index of the syscall in the 
 > syscalltable(32/64). This way we do not loop, just select one that is 
 > active and proceed.
 > 
 > Also, improved toggle_syscall functions (for biarch and not) by removing 
 > search by name as much as possible, thus, no need for loopup_name function 
 > anymore.
 > 
 > Furthermore, instead of commented out section of code (abbriviated with 
 > FIXME) that never selected 32 bit version of syscall if a 64 bit version 
 > existed I added a parameter to control this selection (more in README 
 > file). By default the chances will be 50/50, but one can control it.
 > 
 > Finally, cleaned up some areas (e.g., got rid of COLOR_ARG macro, by 
 > converting it to a function) and fixed one bug with wrong variable being 
 > used.

These need breaking up into separate patches.

	Dave
