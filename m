From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] hw_breakpoint: Simplify list/idx mess in
 toggle_bp_slot() paths
Date: Sat, 15 Jun 2013 14:59:28 +0200
Message-ID: <20130615125926.GB1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
 <20130601194548.GB27149@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eQ4PXCl67fr7GCBUD1WQ9J4YHvSe4pQQk1RNaPe9gFc=;
        b=WhAIwEj4pD1Gts6EVp55L22Qh+ltP1QL6eEUVtISgqTPW5M5nS15oTRRIiIFIqpQBu
         H5nGUsv3ZxqYRtelaAT9ySjJ8rnZ+7J8w+WSjMgmrz8T0ZpgxRYR8M3TwxidBKJF3Tn3
         dXVagbhIpAZdp6pai5iwBYkoKwCSBW6v6ZRMH45YGmFjLR7XGmWcIFM9XSIMDPj/G5OZ
         mFM13tuC19neH2SDRSufEHEY1QkcOvfZQpoqam9OMoH/VtA+3ivlWUW5faiGese/abD6
         SU/QFvB5xn4EWQs8aYKn1kFrzIgRerPI6gWdYjRO5ijmCs9eZRueEsPGlyE7BCazkOxF
         SSFw==
Content-Disposition: inline
In-Reply-To: <20130601194548.GB27149@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sat, Jun 01, 2013 at 09:45:48PM +0200, Oleg Nesterov wrote:
> The enable/disable logic in toggle_bp_slot() is not symmetrical
> and imho very confusing. "old_count" in toggle_bp_task_slot() is
> actually new_count because this bp was already removed from the
> list.
> 
> Change toggle_bp_slot() to always call list_add/list_del after
> toggle_bp_task_slot(). This way old_idx is task_bp_pinned() and
> this entry should be decremented, new_idx is +/-weight and we
> need to increment this element. The code/logic looks obvious.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice :-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
