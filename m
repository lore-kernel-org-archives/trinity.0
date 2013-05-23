From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: OOPS in perf_mmap_close()
Date: Wed, 22 May 2013 23:48:51 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


In case anyone cares, the Oops is happening here:

    1a56:       48 c1 e8 0c             shr    $0xc,%rax
    1a5a:       48 ff c0                inc    %rax
>   1a5d:       f0 48 29 45 60          lock sub %rax,0x60(%rbp)
    1a62:       49 8b 46 40             mov    0x40(%r14),%rax

Which maps to this in perf_mmap_close() in kernel/events/core.c:

                atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);

And "user" (%rbp) is RBP: 0000000000000000, hence the problem.

I'm having trouble tracking the problem back any further as the code is a 
bit covoluted and is not commented at all.

Vince
