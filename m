From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH trinity] net: add generation of semi-random BPF filters
Date: Thu, 16 May 2013 18:03:33 +0200
Message-ID: <51950355.7090602@redhat.com>
References: <1368698056-411-1-git-send-email-dborkman@redhat.com> <20130516135547.GA7393@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130516135547.GA7393@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 05/16/2013 03:55 PM, Dave Jones wrote:
> On Thu, May 16, 2013 at 11:54:16AM +0200, Daniel Borkmann wrote:
>   > BPF filters are used in networking and in application sand-boxing
>   > and even have a arch-dependant JIT compiler in the kernel, so add
>   > a more detailed semi-random BPF generator.
>   >
>   > Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>   > ---
>   >  Compile-tested only!
>
> Very nice.
>
> merged and pushed.

Thanks, just for the record, in case someone might need this e.g. when
trinity hits here ... in the kernel source tree under tools/net/ is a
BPF JIT disassembler.

> thanks,
>
> 	Dave
>
