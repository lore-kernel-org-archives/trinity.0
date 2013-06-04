From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/3] use config.h in USE_* users
Date: Tue, 04 Jun 2013 11:50:47 +0200
Message-ID: <51ADB877.9050705@suse.cz>
References: <1370339304-26492-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        bh=jV7JnD8J1+FwyntqFK+bSJ3XxtYtYIeNY20BCiMBFZs=;
        b=1KcX61m7JHAbAKkeiAfUpbkP1hXPNX3t5L5Qh1pnBRmXH0mlHvhdNWs7pHW9czpN2l
         FD5FLwDrvb0mn6ji6BfQgpIhCKca1OnjPvnGu4E7T5ib17BR1yqwhvkq9WzmxQAiZkks
         NyL8hbPnEF/cXFxXFmnxb1JGdCdvUACHnQycsndl/b83VPIhxmiVXJjU41Ii/uy/dPHJ
         JmhH1WiBSJERMV2+AsUrQxUC2YQiBL26aGREcyN4mCPCa81u/u9x39JdwhCfk+rz77SU
         TN18LxGqfYFbVECRBhu4oh+h+CLr6Ok0cleNcQgz/YR9DS17eVwh86UQlP4h+SA9D9Fe
         XdDQ==
In-Reply-To: <1370339304-26492-1-git-send-email-jslaby@suse.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: davej@redhat.com
Cc: trinity@vger.kernel.org

Even if I apply those three, I still see:
syscalls/perf_event_open.c: In function 'setup_breakpoints':
syscalls/perf_event_open.c:237: error: 'struct perf_event_attr' has no
member named 'bp_type'
syscalls/perf_event_open.c:240: error: 'struct perf_event_attr' has no
member named 'bp_type'
syscalls/perf_event_open.c:243: error: 'struct perf_event_attr' has no
member named 'bp_type'
syscalls/perf_event_open.c:246: error: 'struct perf_event_attr' has no
member named 'bp_type'
syscalls/perf_event_open.c:249: error: 'struct perf_event_attr' has no
member named 'bp_type'
syscalls/perf_event_open.c:252: error: 'struct perf_event_attr' has no
member named 'bp_type'
syscalls/perf_event_open.c:259: error: 'struct perf_event_attr' has no
member named 'bp_addr'
syscalls/perf_event_open.c:263: error: 'struct perf_event_attr' has no
member named 'bp_len'
syscalls/perf_event_open.c:266: error: 'struct perf_event_attr' has no
member named 'bp_len'
syscalls/perf_event_open.c:269: error: 'struct perf_event_attr' has no
member named 'bp_len'
syscalls/perf_event_open.c:272: error: 'struct perf_event_attr' has no
member named 'bp_len'
syscalls/perf_event_open.c:275: error: 'struct perf_event_attr' has no
member named 'bp_len'
syscalls/perf_event_open.c: In function
'create_mostly_valid_counting_event':
syscalls/perf_event_open.c:377: error: 'struct perf_event_attr' has no
member named 'precise_ip'
syscalls/perf_event_open.c:378: error: 'struct perf_event_attr' has no
member named 'mmap_data'
syscalls/perf_event_open.c:379: error: 'struct perf_event_attr' has no
member named 'sample_id_all'
syscalls/perf_event_open.c:380: error: 'struct perf_event_attr' has no
member named 'exclude_host'
syscalls/perf_event_open.c:381: error: 'struct perf_event_attr' has no
member named 'exclude_guest'
syscalls/perf_event_open.c: In function
'create_mostly_valid_sampling_event':
syscalls/perf_event_open.c:428: error: 'struct perf_event_attr' has no
member named 'precise_ip'
syscalls/perf_event_open.c:429: error: 'struct perf_event_attr' has no
member named 'mmap_data'
syscalls/perf_event_open.c:430: error: 'struct perf_event_attr' has no
member named 'sample_id_all'
syscalls/perf_event_open.c:431: error: 'struct perf_event_attr' has no
member named 'exclude_host'
syscalls/perf_event_open.c:432: error: 'struct perf_event_attr' has no
member named 'exclude_guest'

and I have no idea how to fix those cleanly...

-- 
js
suse labs
