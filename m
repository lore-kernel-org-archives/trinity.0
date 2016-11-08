From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] fix build when USE_BPF is not defined
Date: Tue, 8 Nov 2016 10:00:30 -0500
Message-ID: <20161108150030.jgsoi3sfrtap3jqr@codemonkey.org.uk>
References: <dc2c60882d0fe97a0c956dd856d74aa3347a3e5f.1478519712.git.jstancek@redhat.com>
 <20161107143434.k54git2ujrkzrwly@codemonkey.org.uk>
 <3ae384b5-2690-0711-3fdb-b674c8e69056@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ae384b5-2690-0711-3fdb-b674c8e69056@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Stancek <jstancek@redhat.com>
Cc: trinity@vger.kernel.org

On Tue, Nov 08, 2016 at 11:46:01AM +0100, Jan Stancek wrote:
 > On 11/07/2016 03:34 PM, Dave Jones wrote:
 > > I think it might be better if we wrap all of net/bpf.c in this ifdef,
 > > and then add additional ones wherever we call bpf_gen_filter.
 > > (Right now only two places iirc)
 > 
 > Attached is v2, that follows your suggestion.
 
 Close..
 
 > diff --git a/syscalls/bpf.c b/syscalls/bpf.c
 > index 476a2778d8a0..372ab6dc5376 100644
 > --- a/syscalls/bpf.c
 > +++ b/syscalls/bpf.c
 > @@ -29,9 +29,11 @@ static void bpf_prog_load(struct syscallrecord *rec)
 >  	attr->prog_type = RAND_ARRAY(bpf_prog_types);
 >  
 >  	switch (attr->prog_type) {
 > +#ifdef USE_BPF
 >  	case BPF_PROG_TYPE_SOCKET_FILTER:
 >  		bpf_gen_filter(&insns, &len);
 >  		break;
 > +#endif
 >  	default:
 >  		// this will go away when all the other cases are enumerated
 >  		insns = zmalloc(page_size);

This chunk isn't needed because the whole file is already wrapped.

	Dave
