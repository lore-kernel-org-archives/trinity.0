From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: aio: kernel BUG at fs/aio.c:646!
Date: Mon, 5 Aug 2013 12:08:28 -0400
Message-ID: <20130805160828.GH31864@kvack.org>
References: <51FFAF34.20200@oracle.com>
Mime-Version: 1.0
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <51FFAF34.20200@oracle.com>
Sender: owner-linux-aio@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: koverstreet@google.com, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, linux-aio@kvack.org, trinity@vger.kernel.org

Hi Sasha,

On Mon, Aug 05, 2013 at 09:57:08AM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next 
> kernel,
> I've stumbled on the following spew caused by a new BUG() added in "aio: fix
> io_destroy() regression by using call_rcu()".

I did some investigating, and it looks like there is a problem with 
db446a08c23d5475e6b08c87acca79ebb20f283c (aio: convert the ioctx list to 
table lookup v3).  Can you confirm if reverting this patch eliminates 
the BUG() you're hitting?  In my testing, I wasn't able to trigger the 
BUG(), but I was able to trip up slab corruption with debugging on.  
Thanks,

		-ben

...
> Thanks,
> Sasha

-- 
"Thought is the essence of where you are now."

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
