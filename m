From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] wire up support for the Alpha architecture
Date: Mon, 14 Oct 2013 16:43:39 +0100
Message-ID: <20131014154338.GL10491@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1309101335200.30015@vincent-weaver-1.um.maine.edu>
 <20131010232132.GA27157@redhat.com>
 <alpine.DEB.2.10.1310102235240.11534@vincent-weaver-1.um.maine.edu>
 <20131011110419.GG14732@mudshark.cambridge.arm.com>
 <20131014150952.GH10491@mudshark.cambridge.arm.com>
 <20131014153916.GA8779@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131014153916.GA8779@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

On Mon, Oct 14, 2013 at 04:39:16PM +0100, Dave Jones wrote:
> On Mon, Oct 14, 2013 at 04:09:52PM +0100, Will Deacon wrote:
> 
>  > Crikey, Alpha's syscall table is a right mess.
> 
> I don't know anything about alpha, but does the kernel actually
> implement those OSF syscalls ? If not, it's unlikely we're going to
> implement them in trinity, so we could probably do the same thing we did on ia64, and
> 
> #define SYSCALL_OFFSET 300 and skip all those ni_syscall entries.
> 
> Or am I missing something ?

Well, fork() is still syscall number 2, for example. I don't think we can
tidy this up with a simple offset unfortunately :(

Will
