From: Sravan V Dodla <sravan@linux.vnet.ibm.com>
Subject: Re: Complie issues with trinity-2013-06-17 on s390
Date: Wed, 19 Jun 2013 14:06:49 +0530
Message-ID: <1371631009.4704.6.camel@oc6144502753.ibm.com>
References: <1371539246.4585.698.camel@oc6144502753.ibm.com>
	 <20130618153913.GA20496@redhat.com>
	 <1371620459.4704.4.camel@oc6144502753.ibm.com>
	 <1371623319.13340.3.camel@concordia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1371623319.13340.3.camel@concordia>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Wed, 2013-06-19 at 16:28 +1000, Michael Ellerman wrote:
> On Wed, 2013-06-19 at 11:10 +0530, Sravan V Dodla wrote:
> > On Tue, 2013-06-18 at 11:39 -0400, Dave Jones wrote:
> > > On Tue, Jun 18, 2013 at 12:37:26PM +0530, Sravan V Dodla wrote:
> > 
> > > Does this help ?
> > Thanks a lot Dave. That did help :)
> > Still compilation does not complete successfully. I'm seeing the
> > following issue on both ppc64 and s390x archs:
> 
> I have the following patch that I've been meaning to cleanup and send,
> it works for me on ppc64.
> 
Yes Michael, it worked for me on ppc64. Thank you.
I have also made the following changes to make it work for s390x, not
sure of the impact though!

--- kvm.c.orig	2013-06-19 14:04:37.814590066 +0530
+++ kvm.c	2013-06-19 14:04:43.306415094 +0530
@@ -87,8 +87,6 @@ static const struct ioctl kvm_ioctls[] =
 	IOCTL(KVM_SET_VAPIC_ADDR),
 #if defined(__s390__)
 	IOCTL(KVM_S390_INTERRUPT),
-	IOCTL(KVM_S390_STORE_STATUS_NOADDR),
-	IOCTL(KVM_S390_STORE_STATUS_PREFIXED),
 	IOCTL(KVM_S390_STORE_STATUS),
 	IOCTL(KVM_S390_SET_INITIAL_PSW),
 	IOCTL(KVM_S390_INITIAL_RESET),


> cheers
> 
> 
> diff --git a/include/compat.h b/include/compat.h
> index 20455f3..bba5560 100644
> --- a/include/compat.h
> +++ b/include/compat.h
> @@ -669,6 +669,42 @@ struct kvm_one_reg {
>  #define KVM_KVMCLOCK_CTRL         _IO(KVMIO,   0xad)
>  #endif
> 
> +#ifndef KVM_PPC_GET_SMMU_INFO
> +#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
> +
> +struct kvm_ppc_one_page_size {
> +	__u32 page_shift;	/* Page shift (or 0) */
> +	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
> +};
> +
> +struct kvm_ppc_one_seg_page_size {
> +	__u32 page_shift;	/* Base page shift of segment (or 0) */
> +	__u32 slb_enc;		/* SLB encoding for BookS */
> +	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
> +};
> +
> +struct kvm_ppc_smmu_info {
> +	__u64 flags;
> +	__u32 slb_size;
> +	__u32 pad;
> +	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
> +};
> +#define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
> +#endif
> +
> +#ifndef KVM_PPC_ALLOCATE_HTAB
> +#define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
> +#endif
> +
> +#ifndef KVM_PPC_GET_HTAB_FD
> +struct kvm_get_htab_fd {
> +	__u64	flags;
> +	__u64	start_index;
> +	__u64	reserved[2];
> +};
> +#define KVM_PPC_GET_HTAB_FD	  _IOW(KVMIO,  0xaa, struct kvm_get_htab_fd)
> +#endif
> +
>  #ifndef EM_ARM
>  #define EM_ARM                    40
>  #endif
> diff --git a/ioctls/kvm.c b/ioctls/kvm.c
> index 4620ca8..ffddee4 100644
> --- a/ioctls/kvm.c
> +++ b/ioctls/kvm.c
> @@ -12,7 +12,6 @@ static const struct ioctl kvm_ioctls[] = {
>  	IOCTL(KVM_SET_MEMORY_REGION),
>  	IOCTL(KVM_CREATE_VCPU),
>  	IOCTL(KVM_GET_DIRTY_LOG),
> -	IOCTL(KVM_SET_MEMORY_ALIAS),
>  	IOCTL(KVM_SET_NR_MMU_PAGES),
>  	IOCTL(KVM_GET_NR_MMU_PAGES),
>  	IOCTL(KVM_SET_USER_MEMORY_REGION),
> @@ -26,13 +25,10 @@ static const struct ioctl kvm_ioctls[] = {
>  	IOCTL(KVM_GET_IRQCHIP),
>  	IOCTL(KVM_SET_IRQCHIP),
>  	IOCTL(KVM_CREATE_PIT),
> -	IOCTL(KVM_GET_PIT),
> -	IOCTL(KVM_SET_PIT),
>  	IOCTL(KVM_IRQ_LINE_STATUS),
>  	IOCTL(KVM_REGISTER_COALESCED_MMIO),
>  	IOCTL(KVM_UNREGISTER_COALESCED_MMIO),
>  	IOCTL(KVM_ASSIGN_PCI_DEVICE),
> -	IOCTL(KVM_SET_GSI_ROUTING),
>  	IOCTL(KVM_ASSIGN_IRQ),
>  	IOCTL(KVM_ASSIGN_DEV_IRQ),
>  	IOCTL(KVM_REINJECT_CONTROL),
> @@ -44,16 +40,38 @@ static const struct ioctl kvm_ioctls[] = {
>  	IOCTL(KVM_CREATE_PIT2),
>  	IOCTL(KVM_SET_BOOT_CPU_ID),
>  	IOCTL(KVM_IOEVENTFD),
> -	IOCTL(KVM_XEN_HVM_CONFIG),
>  	IOCTL(KVM_SET_CLOCK),
>  	IOCTL(KVM_GET_CLOCK),
> -	IOCTL(KVM_GET_PIT2),
> -	IOCTL(KVM_SET_PIT2),
>  	IOCTL(KVM_PPC_GET_PVINFO),
>  	IOCTL(KVM_SET_TSC_KHZ),
>  	IOCTL(KVM_GET_TSC_KHZ),
>  	IOCTL(KVM_ASSIGN_SET_INTX_MASK),
>  	IOCTL(KVM_SIGNAL_MSI),
> +#ifdef X86
> +	IOCTL(KVM_SET_MEMORY_ALIAS),
> +	IOCTL(KVM_GET_PIT),
> +	IOCTL(KVM_SET_PIT),
> +	IOCTL(KVM_GET_PIT2),
> +	IOCTL(KVM_SET_PIT2),
> +	IOCTL(KVM_SET_GSI_ROUTING),
> +	IOCTL(KVM_XEN_HVM_CONFIG),
> +	IOCTL(KVM_GET_MSRS),
> +	IOCTL(KVM_SET_MSRS),
> +	IOCTL(KVM_SET_CPUID),
> +	IOCTL(KVM_GET_LAPIC),
> +	IOCTL(KVM_SET_LAPIC),
> +	IOCTL(KVM_SET_CPUID2),
> +	IOCTL(KVM_GET_CPUID2),
> +	IOCTL(KVM_X86_SET_MCE),
> +	IOCTL(KVM_GET_VCPU_EVENTS),
> +	IOCTL(KVM_SET_VCPU_EVENTS),
> +	IOCTL(KVM_GET_DEBUGREGS),
> +	IOCTL(KVM_SET_DEBUGREGS),
> +	IOCTL(KVM_GET_XSAVE),
> +	IOCTL(KVM_SET_XSAVE),
> +	IOCTL(KVM_GET_XCRS),
> +	IOCTL(KVM_SET_XCRS),
> +#endif
>  #if defined(__powerpc__)
>  	IOCTL(KVM_PPC_GET_SMMU_INFO),
>  	IOCTL(KVM_PPC_ALLOCATE_HTAB),
> @@ -73,16 +91,9 @@ static const struct ioctl kvm_ioctls[] = {
>  	IOCTL(KVM_TRANSLATE),
>  	IOCTL(KVM_INTERRUPT),
>  	IOCTL(KVM_DEBUG_GUEST),
> -	IOCTL(KVM_GET_MSRS),
> -	IOCTL(KVM_SET_MSRS),
> -	IOCTL(KVM_SET_CPUID),
>  	IOCTL(KVM_SET_SIGNAL_MASK),
>  	IOCTL(KVM_GET_FPU),
>  	IOCTL(KVM_SET_FPU),
> -	IOCTL(KVM_GET_LAPIC),
> -	IOCTL(KVM_SET_LAPIC),
> -	IOCTL(KVM_SET_CPUID2),
> -	IOCTL(KVM_GET_CPUID2),
>  	IOCTL(KVM_TPR_ACCESS_REPORTING),
>  	IOCTL(KVM_SET_VAPIC_ADDR),
>  #if defined(__s390__)
> @@ -99,18 +110,9 @@ static const struct ioctl kvm_ioctls[] = {
>  	IOCTL(KVM_SET_GUEST_DEBUG),
>  	IOCTL(KVM_X86_SETUP_MCE),
>  	IOCTL(KVM_X86_GET_MCE_CAP_SUPPORTED),
> -	IOCTL(KVM_X86_SET_MCE),
>  	IOCTL(KVM_IA64_VCPU_GET_STACK),
>  	IOCTL(KVM_IA64_VCPU_SET_STACK),
> -	IOCTL(KVM_GET_VCPU_EVENTS),
> -	IOCTL(KVM_SET_VCPU_EVENTS),
> -	IOCTL(KVM_GET_DEBUGREGS),
> -	IOCTL(KVM_SET_DEBUGREGS),
>  	IOCTL(KVM_ENABLE_CAP),
> -	IOCTL(KVM_GET_XSAVE),
> -	IOCTL(KVM_SET_XSAVE),
> -	IOCTL(KVM_GET_XCRS),
> -	IOCTL(KVM_SET_XCRS),
>  	IOCTL(KVM_DIRTY_TLB),
>  	IOCTL(KVM_GET_ONE_REG),
>  	IOCTL(KVM_SET_ONE_REG),

