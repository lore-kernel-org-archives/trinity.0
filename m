From: Dave Jones <davej@redhat.com>
Subject: Re: trinity: lots of free(): invalid pointer
Date: Mon, 20 Jan 2014 16:37:59 -0500
Message-ID: <20140120213759.GA11834@redhat.com>
References: <52D70DC5.8070104@suse.cz>
 <20140117190932.GA4300@redhat.com>
 <52DD799F.7090403@suse.cz>
 <52DD7E2E.7000307@suse.cz>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52DD7E2E.7000307@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: trinity@vger.kernel.org

On Mon, Jan 20, 2014 at 08:51:10PM +0100, Jiri Slaby wrote:
 
 > (gdb) l * 0x410fa4
 > 0x410fa4 is in post_modify_ldt (syscalls/modify_ldt.c:62).
 > 57
 > 58              ptr = (void *) shm->scratch[childno];
 > 59
 > 60              if (ptr != NULL)
 > 61                      free(ptr);
 > 62      }
 > 63
 > 64      struct syscallentry syscall_modify_ldt = {
 > 65              .name = "modify_ldt",
 > 66              .num_args = 3,
 > 

That syscall should probably be marked as AVOID for now, as it's pretty easy
to completely screw up the LDT and segv. We'll need to be a bit more
creative to make it actually find bugs.
 
	Dave
