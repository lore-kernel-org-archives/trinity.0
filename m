From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 2/2] hugetlb: rename hugepage_migration_support() to ..._supported()
Date: Fri, 30 May 2014 00:13:52 -0400
Message-ID: <1401423232-25198-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1401423232-25198-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1401423232-25198-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <5387f561.8983e50a.1ead.ffff85b1SMTPIN_ADDED_BROKEN@mx.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, trinity@vger.kernel.org

We already have a function named hugepage_supported(), and the similar
name hugepage_migration_support() is a bit unconfortable, so let's rename
it hugepage_migration_supported().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/hugetlb.h | 4 ++--
 mm/hugetlb.c            | 2 +-
 mm/migrate.c            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git v3.15-rc5.orig/include/linux/hugetlb.h v3.15-rc5/include/linux/hugetlb.h
index c9de64cf288d..9d35e514312b 100644
--- v3.15-rc5.orig/include/linux/hugetlb.h
+++ v3.15-rc5/include/linux/hugetlb.h
@@ -385,7 +385,7 @@ static inline pgoff_t basepage_index(struct page *page)
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
-static inline int hugepage_migration_support(struct hstate *h)
+static inline int hugepage_migration_supported(struct hstate *h)
 {
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	return huge_page_shift(h) == PMD_SHIFT;
@@ -441,7 +441,7 @@ static inline pgoff_t basepage_index(struct page *page)
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
-#define hugepage_migration_support(h)	0
+#define hugepage_migration_supported(h)	0
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
diff --git v3.15-rc5.orig/mm/hugetlb.c v3.15-rc5/mm/hugetlb.c
index ea42b584661a..83d936d12c1d 100644
--- v3.15-rc5.orig/mm/hugetlb.c
+++ v3.15-rc5/mm/hugetlb.c
@@ -545,7 +545,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
-	if (hugepages_treat_as_movable || hugepage_migration_support(h))
+	if (hugepages_treat_as_movable || hugepage_migration_supported(h))
 		return GFP_HIGHUSER_MOVABLE;
 	else
 		return GFP_HIGHUSER;
diff --git v3.15-rc5.orig/mm/migrate.c v3.15-rc5/mm/migrate.c
index bed48809e5d0..15b589ae6aaf 100644
--- v3.15-rc5.orig/mm/migrate.c
+++ v3.15-rc5/mm/migrate.c
@@ -1031,7 +1031,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_support(page_hstate(hpage))) {
+	if (!hugepage_migration_supported(page_hstate(hpage))) {
 		putback_active_hugepage(hpage);
 		return -ENOSYS;
 	}
-- 
1.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
