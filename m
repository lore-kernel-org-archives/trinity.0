From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: Complie issues with trinity-2013-06-17 on s390
Date: Wed, 19 Jun 2013 19:06:38 +1000
Message-ID: <1371632798.13340.7.camel@concordia>
References: <1371539246.4585.698.camel@oc6144502753.ibm.com>
	 <20130618153913.GA20496@redhat.com>
	 <1371620459.4704.4.camel@oc6144502753.ibm.com>
	 <1371623319.13340.3.camel@concordia>
	 <1371631009.4704.6.camel@oc6144502753.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1371631009.4704.6.camel@oc6144502753.ibm.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sravan V Dodla <sravan@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On Wed, 2013-06-19 at 14:06 +0530, Sravan V Dodla wrote:
> On Wed, 2013-06-19 at 16:28 +1000, Michael Ellerman wrote:
> > On Wed, 2013-06-19 at 11:10 +0530, Sravan V Dodla wrote:
> > > On Tue, 2013-06-18 at 11:39 -0400, Dave Jones wrote:
> > > > On Tue, Jun 18, 2013 at 12:37:26PM +0530, Sravan V Dodla wrote:
> > > 
> > > > Does this help ?
> > > Thanks a lot Dave. That did help :)
> > > Still compilation does not complete successfully. I'm seeing the
> > > following issue on both ppc64 and s390x archs:
> > 
> > I have the following patch that I've been meaning to cleanup and send,
> > it works for me on ppc64.

> Yes Michael, it worked for me on ppc64. Thank you.

OK, see the two patches I sent to the list.


> I have also made the following changes to make it work for s390x, not
> sure of the impact though!

>--- kvm.c.orig	2013-06-19 14:04:37.814590066 +0530
> +++ kvm.c	2013-06-19 14:04:43.306415094 +0530
> @@ -87,8 +87,6 @@ static const struct ioctl kvm_ioctls[] =
>  	IOCTL(KVM_SET_VAPIC_ADDR),
>  #if defined(__s390__)
>  	IOCTL(KVM_S390_INTERRUPT),
> -	IOCTL(KVM_S390_STORE_STATUS_NOADDR),
> -	IOCTL(KVM_S390_STORE_STATUS_PREFIXED),
>  	IOCTL(KVM_S390_STORE_STATUS),
>  	IOCTL(KVM_S390_SET_INITIAL_PSW),
>  	IOCTL(KVM_S390_INITIAL_RESET),
> 

That looks correct. They are not actually ioctls, they are meant to be
used as arguments to the KVM_S390_STORE_STATUS ioctl. So I think that's
just a cut-and-paste bug in kvm.c.

You should send it as a proper patch.

cheers

