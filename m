From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/3] hw_breakpoint: Simplify the "weight" usage in
 toggle_bp_slot() paths
Date: Sat, 15 Jun 2013 15:14:34 +0200
Message-ID: <20130615131432.GC1965@somewhere.redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu>
 <20130601194526.GA27149@redhat.com>
 <20130601194606.GC27149@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ueeKKnc2BqequjTQwrlQn8ttmgBobJPYVN7BPhRXwX8=;
        b=bWBfTKYOzVpZTHf3d3rED/Yg2j8eiPRJirkwWlwoo1sjKPf2E1WtN0/tAJEq2ZOWKT
         wa6qSYYN29qKX6o/jsYL+E++nOnsdq46w6NWMhc/4tNENJJOmtrY6QSTAZXSSZIsfFVv
         ZyxDtqGu4vR62flxP6xh8+Q30Zp791gviYzk7M6G2zvsPfKY7cxyBT4Et3d8k3jJsfOw
         z1LQzNc73rWXumqHkhtYHG0EnTinhOcpimtG0xbfNsU6Vgp43BrOhhlsUhlQYL0aYabW
         /kWxGFuqQmeriC33YH8bPRAmbO2qLO2TBorjgQWv8WPOtNTK2c6q6FP2o6t8yiCh0X0R
         z57Q==
Content-Disposition: inline
In-Reply-To: <20130601194606.GC27149@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>

On Sat, Jun 01, 2013 at 09:46:06PM +0200, Oleg Nesterov wrote:
> Change toggle_bp_slot() to make "weight" negative if !enable. This
> way we can always use "+ weight" without additional "if (enable)"
> check and toggle_bp_task_slot() no longer needs this arg.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
