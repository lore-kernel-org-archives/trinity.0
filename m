From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] hugetlb: restrict hugepage_migration_support() to x86_64
 (Re: BUG at mm/memory.c:1489!)
Date: Thu, 29 May 2014 18:52:11 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1405291851001.27151@eggly.anvils>
References: <1401265922.3355.4.camel@concordia> <alpine.LSU.2.11.1405281712310.7156@eggly.anvils> <1401353983.4930.15.camel@concordia> <1401388474-mqnis5cp@n-horiguchi@ah.jp.nec.com> <1401413716.29324.2.camel@concordia>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=s9YulZLNDaynGiNvkzfS8qZAQESW8G+fqpG09rYTDok=;
        b=ZoPXk7UsxslK4sCHuVuiNhmz66YoTdiJRFbYe+HGDtoY9QeGx7PPBwvEv1LGneouwB
         BiU9LAsUjauC1CuZsIIn8PRg5rUG+VZXKU8RFEvmHFvm7UuSAOWU069XewIN0gVY7TU/
         oMjKz/58xw2W5oqDB+HxwyAIH29eI4Og8Ja7RtbFTIhQTwg4ZIY/8L1m57Py1odPVFGR
         RavlLGAf0+BKshLFu7peQ9tHyaSyXU75/6ETm0lEwisG0Fk0cE/UahDoOh7jdVOTck1d
         /ttpDY4+nITjdEhEMiT7HZmXHjRUVfeb1W7rpQSMAac88HTx+I/7nXY4+YUY/4LteSks
         XTKA==
In-Reply-To: <1401413716.29324.2.camel@concordia>
Sender: owner-linux-mm@kvack.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, trinity@vger.kernel.org

On Fri, 30 May 2014, Michael Ellerman wrote:
> 
> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> index 3c1b968..f230a97 100644
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -175,6 +175,12 @@ static inline int vma_migratable(struct vm_area_struct *vma)
>  {
>         if (vma->vm_flags & (VM_IO | VM_PFNMAP))
>                 return 0;
> +
> +#ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> +       if (vma->vm_flags & VM_HUGETLB)
> +               return 0;
> +#endif
> +
>         /*
>          * Migration allocates pages in the highest zone. If we cannot
>          * do so then migration (at least from node to node) is not

That's right, thanks.

> 
> 
> Which seems to be what Hugh was referring to in his mail - correct me if I'm
> wrong Hugh.
> 
> With your patch and the above hunk I can run trinity happily for a while,
> whereas without it crashes almost immediately.
> 
> So with the above hunk you can add my tested-by.
> 
> cheers

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
