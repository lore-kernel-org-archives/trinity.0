From: Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH aio-next] aio: fix error handling and rcu usage in "convert the ioctx list to table lookup v3"
Date: Mon, 5 Aug 2013 13:20:32 -0400
Message-ID: <20130805172032.GI31864@kvack.org>
References: <51FFAF34.20200@oracle.com> <20130805160828.GH31864@kvack.org>
Mime-Version: 1.0
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20130805160828.GH31864@kvack.org>
Sender: owner-linux-aio@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kent Overstreet <kmo@daterainc.com>, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>, linux-aio@kvack.org, trinity@vger.kernel.org

On Mon, Aug 05, 2013 at 12:08:28PM -0400, Benjamin LaHaise wrote:
> Hi Sasha,
> 
> On Mon, Aug 05, 2013 at 09:57:08AM -0400, Sasha Levin wrote:
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest running latest -next 
> > kernel,
> > I've stumbled on the following spew caused by a new BUG() added in "aio: fix
> > io_destroy() regression by using call_rcu()".
> 
> I did some investigating, and it looks like there is a problem with 
> db446a08c23d5475e6b08c87acca79ebb20f283c (aio: convert the ioctx list to 
> table lookup v3).  Can you confirm if reverting this patch eliminates 
> the BUG() you're hitting?  In my testing, I wasn't able to trigger the 
> BUG(), but I was able to trip up slab corruption with debugging on.  

And here is a patch that should fix the problems introduced in the table 
lookup patch without reverting.  I will add this to the aio-next.git tree.  
This bug is not present in Linus' tree.

		-ben

 aio.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 588aff9..3bc068c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -475,7 +475,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 	struct aio_ring *ring;
 
 	spin_lock(&mm->ioctx_lock);
-	table = rcu_dereference(mm->ioctx_table);
+	table = mm->ioctx_table;
 
 	while (1) {
 		if (table)
@@ -503,7 +503,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 		table->nr = new_nr;
 
 		spin_lock(&mm->ioctx_lock);
-		old = rcu_dereference(mm->ioctx_table);
+		old = mm->ioctx_table;
 
 		if (!old) {
 			rcu_assign_pointer(mm->ioctx_table, table);
@@ -579,10 +579,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	if (ctx->req_batch < 1)
 		ctx->req_batch = 1;
 
-	err = ioctx_add_table(ctx, mm);
-	if (err)
-		goto out_cleanup_noerr;
-
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > (aio_max_nr * 2UL) ||
@@ -595,13 +591,18 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	percpu_ref_get(&ctx->users); /* io_setup() will drop this ref */
 
+	err = ioctx_add_table(ctx, mm);
+	if (err)
+		goto out_cleanup_put;
+
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		 ctx, ctx->user_id, mm, ctx->nr_events);
 	return ctx;
 
+out_cleanup_put:
+	percpu_ref_put(&ctx->users);
 out_cleanup:
 	err = -EAGAIN;
-out_cleanup_noerr:
 	aio_free_ring(ctx);
 out_freepcpu:
 	free_percpu(ctx->cpu);
@@ -626,7 +627,7 @@ static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
 		struct kioctx_table *table;
 
 		spin_lock(&mm->ioctx_lock);
-		table = rcu_dereference(mm->ioctx_table);
+		table = mm->ioctx_table;
 
 		WARN_ON(ctx != table->table[ctx->id]);
 		table->table[ctx->id] = NULL;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
