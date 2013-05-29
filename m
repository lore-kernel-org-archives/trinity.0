From: Ingo Molnar <mingo@kernel.org>
Subject: Re: OOPS in perf_mmap_close()
Date: Wed, 29 May 2013 10:07:37 +0200
Message-ID: <20130529080737.GB24933@gmail.com>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu>
 <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu>
 <20130523152611.GE23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6TJJCcW9vjjMJwinBBCRZjQ9lO1VKtRE7S1hDU2tZdg=;
        b=hWo98O1eVHzmTyUX4p3PDL89WcVD++EKXYdlMSypWvsvZiitLSVBo8n7Mi8r/8Y54Z
         v4RPN9UuZg1LR1AuWcFCrzBiAUPuvhDKT1brZtWUQs3Tij99qvkDu4AQCGZmM5Vqi2GL
         CIk9dXPEFBnXtso8/b4vvape8Vv5d1DXiMg9/MZE+tQArzklO4fDccD+4XXQnrLMHTr1
         UafmuaQ/b32+w/URoSIZtF7CcqrTBI5gORYNuESzdZ6DsSMkvEa+tdDywF/ptAWeVyzn
         YvOKSYjc6qD4i6ceVvlXw5qa3MQAohlzUvCdk0s8k2GCswJ10UwU+aSpNbgW56wKCy1X
         K+1g==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org


* Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Tue, 28 May 2013, Peter Zijlstra wrote:
>  
> > Take 2.. :-)
> > 
> > Leaving the locked vs pinned debacle for another time. The below patch
> > survives many non-priv execution of the problem prog.
> 
> It looks like this is already in tip, [...]

Wanted to help out with testing it in parallel - even though it was not 
yet clear whether it's the full fix.

Since you are still seeing a leak I will hold on to it until it's fully 
fixed.

Thanks,

	Ingo
