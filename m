From: Dave Jones <davej@redhat.com>
Subject: Re: trinity: lots of corrupted double-linked list errors when run on
 x32
Date: Tue, 11 Feb 2014 12:13:59 -0500
Message-ID: <20140211171359.GA31222@redhat.com>
References: <alpine.DEB.2.10.1402061142030.17478@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402061142030.17478@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Thu, Feb 06, 2014 at 11:45:49AM -0500, Vince Weaver wrote:
 > 
 > I'm running trinity compiled for x32 (by adding -mx32 to the CFLAGS
 > and -static in the LDFLGAS as for some reason my debian system with x32 
 > libs installed gives "FATAL: kernel too old" if I try to run the 
 > dynamically linked version).
 > 
 > Anyway I think glibc is reporting these particular errors.  Should I try 
 > tracking them down?  Or is this normal when running trinity?
 > 
 > Vince
 > 
 > *** Error in `./trinity': corrupted double-linked list: 0x018c31f8 ***
 > *** Error in `./trinity': corrupted double-linked list: 0x01a68038 ***
 > *** Error in `./trinity': corrupted double-linked list: 0x0170a448 ***
 > *** Error in `./trinity': corrupted double-linked list: 0x01a0cd08 ***
 > *** Error in `./trinity': free(): invalid size: 0x01a150d0 ***

I've spotted a bunch of weird stuff lately, like core dumps in odd places (when run with -D)
(and gdb insisting it doesn't match the executable).  I think it started when
I added the mmap lists, but I've not nailed down exactly what's failing yet.

I'm looking into it, but haven't got a good feel for what's going wrong.

	Dave
