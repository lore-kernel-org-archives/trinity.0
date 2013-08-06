From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH aio-next] aio: fix error handling and rcu usage in "convert
 the ioctx list to table lookup v3"
Date: Tue, 06 Aug 2013 17:57:32 -0400
Message-ID: <5201714C.8000100@oracle.com>
References: <51FFAF34.20200@oracle.com> <20130805160828.GH31864@kvack.org> <20130805172032.GI31864@kvack.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20130805172032.GI31864@kvack.org>
Sender: owner-linux-aio@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, linux-aio@kvack.org, trinity@vger.kernel.org

On 08/05/2013 01:20 PM, Benjamin LaHaise wrote:
> On Mon, Aug 05, 2013 at 12:08:28PM -0400, Benjamin LaHaise wrote:
>> Hi Sasha,
>>
>> On Mon, Aug 05, 2013 at 09:57:08AM -0400, Sasha Levin wrote:
>>> Hi all,
>>>
>>> While fuzzing with trinity inside a KVM tools guest running latest -next
>>> kernel,
>>> I've stumbled on the following spew caused by a new BUG() added in "aio: fix
>>> io_destroy() regression by using call_rcu()".
>>
>> I did some investigating, and it looks like there is a problem with
>> db446a08c23d5475e6b08c87acca79ebb20f283c (aio: convert the ioctx list to
>> table lookup v3).  Can you confirm if reverting this patch eliminates
>> the BUG() you're hitting?  In my testing, I wasn't able to trigger the
>> BUG(), but I was able to trip up slab corruption with debugging on.
>
> And here is a patch that should fix the problems introduced in the table
> lookup patch without reverting.  I will add this to the aio-next.git tree.
> This bug is not present in Linus' tree.

[snip]

Old error is gone, but now seeing this, which seems related.

         ctx = table->table[id];
         if (ctx->user_id == ctx_id) { <--- here
                 percpu_ref_get(&ctx->users);
                 ret = ctx;
         }

[  542.182026] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[  542.183221] IP: [<ffffffff812ef78d>] lookup_ioctx+0x8d/0xe0
[  542.183956] PGD 1b6e69067 PUD 1b6e6a067 PMD 0
[  542.184593] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  542.185394] Modules linked in:
[  542.185866] CPU: 2 PID: 22471 Comm: trinity-child36 Tainted: G        W 
3.11.0-rc4-next-20130806-sasha-00002-gb144a3f #3977
[  542.187428] task: ffff88020bc40000 ti: ffff8801b6e7e000 task.ti: ffff8801b6e7e000
[  542.188384] RIP: 0010:[<ffffffff812ef78d>]  [<ffffffff812ef78d>] lookup_ioctx+0x8d/0xe0
[  542.189408] RSP: 0018:ffff8801b6e7ff18  EFLAGS: 00010297
[  542.190015] RAX: ffff88020a64a1b0 RBX: 00000000007f866d RCX: 0000000000000000
[  542.190015] RDX: 0000000000000000 RSI: ffff88020bc40950 RDI: 0000000000000282
[  542.190015] RBP: ffff8801b6e7ff48 R08: 0000000000000000 R09: 0000000000000000
[  542.190015] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88020bffc000
[  542.190015] R13: 0000000000000000 R14: 0000000000000000 R15: 8000000000008000
[  542.190015] FS:  00007fa96f2b8700(0000) GS:ffff880224a00000(0000) knlGS:0000000000000000
[  542.190015] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  542.190015] CR2: 0000000000000001 CR3: 00000001b6e68000 CR4: 00000000000006e0
[  542.190015] Stack:
[  542.190015]  ffffffff812ef747 ffffffff81074268 00000000007f866d 0000000000000678
[  542.190015]  00007fa96f2b86a8 00007fff70fb7170 ffff8801b6e7ff78 ffffffff812f1103
[  542.190015]  8000000000008000 00007fff70fb7170 00007fa96f2b86a8 00000000007f866d
[  542.190015] Call Trace:
[  542.190015]  [<ffffffff812ef747>] ? lookup_ioctx+0x47/0xe0
[  542.202270]  [<ffffffff81074268>] ? syscall_trace_enter+0x28/0x230
[  542.202270]  [<ffffffff812f1103>] SyS_io_destroy+0x13/0x110
[  542.202270]  [<ffffffff840a3e2c>] tracesys+0xdd/0xe2
[  542.202270] Code: 02 00 00 00 48 c7 c7 e0 65 a6 85 e8 7e 7c ea ff 49 8b 84 24 80 04 00 00 48 85 
c0 74 21 44 3b 68 10 73 1b 45 89 ed 4e 8b 74 e8 18 <49> 39 5e 38 75 0d 4c 89 f7 e8 c5 fe ff ff eb 06 
0f 1f 00 45 31
[  542.202270] RIP  [<ffffffff812ef78d>] lookup_ioctx+0x8d/0xe0
[  542.202270]  RSP <ffff8801b6e7ff18>
[  542.202270] CR2: 0000000000000038


Thanks,
Sasha

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
