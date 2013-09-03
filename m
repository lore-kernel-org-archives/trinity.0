From: Helia Correia <helia.correia@linux.intel.com>
Subject: Re: splice syscall runs endlessly, usage problem?
Date: Tue, 03 Sep 2013 18:51:12 +0200
Message-ID: <52261380.7080508@linux.intel.com>
References: <5225A26A.10403@linux.intel.com> <20130903163851.GA7397@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130903163851.GA7397@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On 09/03/2013 06:38 PM, Dave Jones wrote:
> On Tue, Sep 03, 2013 at 10:48:42AM +0200, Helia Correia wrote:
>   > Hi,
>   >
>   > I am getting to know how to use Trinity, and my last attempt was to run
>   > below command (on a Fedora 17 64 bits distribution):
>   > trinity -c splice -C1 -D
>   >
>   > My problem is that this command doesn't stop running by itself (started
>   > yesterday, was still running this morning so I interrupted it), and I
>   > don't understand why but guess this is not an expected behavior, am I
>   > right? What should I do to have it run normally (I mean, start and end
>   > up gracefully)?
>   >
>   > Maybe I overlooked something but seems I couldn't find any documentation
>   > as regards to this aspect, as well as how much time it nearly takes to
>   > have Trinity run entirely, so any pointers would be highly appreciated.
>
> It will run indefinitly unless you pass -N<number> (or unless it hits a kernel
> bug that taints the kernel).
>
> 	Dave
>
>
Hi Dave,

Thanks for your input, I will try that (and indeed, -N is mentioned in 
Trinity usage, my bad :)

Best regards,
Helia
