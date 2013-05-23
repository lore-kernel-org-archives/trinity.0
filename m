From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: OOPS in perf_mmap_close()
Date: Thu, 23 May 2013 11:47:17 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1305231144370.17701@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130523152611.GE23650@twins.programming.kicks-ass.net>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, trinity@vger.kernel.org

On Thu, 23 May 2013, Peter Zijlstra wrote:

> On Thu, May 23, 2013 at 10:10:36AM -0400, Vince Weaver wrote:
> > 
> > I can confirm your patch avoids the oops on my machine.
> > 
> > It does lead to interesting behavior if I run the sample program
> > multiple times (with added printfs):
> > 
> > vince@core2:~$ ./perf_mmap_close_bug 
> > mmap1=0x7f06a6e90000
> > mmap2=0x7f06a6e7f000
> > vince@core2:~$ ./perf_mmap_close_bug 
> > mmap1=0x7f878a138000
> > mmap2=0x7f878a127000
> > vince@core2:~$ ./perf_mmap_close_bug 
> > mmap1=0xffffffffffffffff
> > Error opening fd2 Invalid argument
> > 
> > and then it never successfully completes again.  Is this unexpected 
> > behavior?  
> 
> Sounds weird to me, I'll see if I can reproduce/understand.
> 

I don't know if it's related, but even with 3.10-rc2 with your patch 
applied and running the fuzzer a bit the system eventually becomes 
unstable and oopsing like mad, but in non-perf related ways.  hmmm.

I've set up a serial console and maybe I can get some better messages.

Vince

[ 1188.896010] kernel BUG at mm/slab.c:3005!                                    
[ 1188.896010] invalid opcode: 0000 [#1] SMP                                    
[ 1188.896010] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs locn
[ 1188.896010] CPU: 1 PID: 3406 Comm: sudo Not tainted 3.10.0-rc2 #3            
[ 1188.896010] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 1188.896010] task: ffff880116726770 ti: ffff880117564000 task.ti: ffff88011750
[ 1188.896010] RIP: 0010:[<ffffffff810e9c16>]  [<ffffffff810e9c16>] ____cache_a0
[ 1188.896010] RSP: 0018:ffff880117565e88  EFLAGS: 00010096                     
[ 1188.896010] RAX: ffff880119dbf748 RBX: ffff88011974c200 RCX: 0000000000000007
[ 1188.896010] RDX: 000000000000001e RSI: 0000000000000000 RDI: 0000000000000000
[ 1188.896010] RBP: ffff880119dbf740 R08: ffff880117834c00 R09: ffff880117832000
[ 1188.896010] R10: 00007fffb1360440 R11: 0000000000000246 R12: ffff880119c92a40
[ 1188.896010] R13: 0000000000000000 R14: ffff880117834c00 R15: 0000000000000010
[ 1188.896010] FS:  00007f1339467800(0000) GS:ffff88011fc80000(0000) knlGS:00000
[ 1188.896010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                
[ 1188.896010] CR2: 00007f133898a040 CR3: 00000001176ab000 CR4: 00000000000407e0
[ 1188.896010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1188.896010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1188.896010] Stack:                                                           
[ 1188.896010]  0000000000000001 000080d000000000 ffff880117941c80 ffff880119c90
[ 1188.896010]  00000000000080d0 0000000000000246 00000000000080d0 00007fffb1360
[ 1188.896010]  ffffffff810eace7 ffff880117941c80 00000000000003e8 0000000000000
[ 1188.896010] Call Trace:                                                      
[ 1188.896010]  [<ffffffff810eace7>] ? kmem_cache_alloc+0x47/0xf8               
[ 1188.896010]  [<ffffffff8103abb6>] ? alloc_uid+0x5c/0xee                      
[ 1188.896010]  [<ffffffff8103efda>] ? set_user+0xd/0x70                        
[ 1188.896010]  [<ffffffff81040529>] ? SyS_setresuid+0xb6/0x113                 
[ 1188.896010]  [<ffffffff81369b92>] ? system_call_fastpath+0x16/0x1b           
[ 1188.896010] Code: 20 48 8b 5d 28 48 8d 55 28 c7 45 60 01 00 00 00 48 39 d3 7 
[ 1188.896010] RIP  [<ffffffff810e9c16>] ____cache_alloc+0x11c/0x290            
[ 1188.896010]  RSP <ffff880117565e88>                                          
[ 1188.896010] ---[ end trace a14ae9e1a2282660 ]---                             
[ 1192.279580] ------------[ cut here ]------------                             
[ 1192.279580] WARNING: at kernel/watchdog.c:245 watchdog_overflow_callback+0x7)
[ 1192.279580] Watchdog detected hard LOCKUP on cpu 1                           
[ 1192.279580] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs locn
[ 1192.279580] CPU: 1 PID: 24 Comm: kworker/1:1 Tainted: G      D      3.10.0-r3
[ 1192.279580] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[ 1192.279580] Workqueue: events cache_reap                                     
[ 1192.279580]  0000000000000000 ffffffff8102e205 ffff88011fc87d00 ffff88011a220
[ 1192.279580]  ffff88011fc87d50 ffff88011fc87de0 ffff88011fc87ef8 ffffffff81020
[ 1192.279580]  ffffffff814ecec5 0000000000000020 ffff88011fc87d60 ffff88011fc80
[ 1192.279580] Call Trace:                                                      
[ 1192.279580]  <NMI>  [<ffffffff8102e205>] ? warn_slowpath_common+0x5b/0x70    
[ 1192.279580]  [<ffffffff8102e2b0>] ? warn_slowpath_fmt+0x47/0x49              
[ 1192.279580]  [<ffffffff8108a920>] ? watchdog_overflow_callback+0x7e/0x9d     
[ 1192.279580]  [<ffffffff810ad1f8>] ? __perf_event_overflow+0x12c/0x1ae        
[ 1192.279580]  [<ffffffff810ab29b>] ? perf_event_update_userpage+0x12/0xbd     
[ 1192.279580]  [<ffffffff81011f41>] ? intel_pmu_handle_irq+0x242/0x2aa         
[ 1192.279580]  [<ffffffff81365a21>] ? nmi_handle.isra.0+0x3c/0x5a              
[ 1192.279580]  [<ffffffff81365adc>] ? do_nmi+0x9d/0x2ab                        
[ 1192.279580]  [<ffffffff813652b7>] ? end_repeat_nmi+0x1e/0x2e                 
[ 1192.279580]  [<ffffffff810704c6>] ? do_raw_spin_lock+0x15/0x1b               
[ 1192.279580]  [<ffffffff810704c6>] ? do_raw_spin_lock+0x15/0x1b               
[ 1192.279580]  [<ffffffff810704c6>] ? do_raw_spin_lock+0x15/0x1b               
[ 1192.279580]  <<EOE>>  [<ffffffff810e944e>] ? drain_array+0x46/0xc1           
[ 1192.279580]  [<ffffffff810e967d>] ? cache_reap+0xba/0x1b5                    
[ 1192.279580]  [<ffffffff81044e68>] ? process_one_work+0x18b/0x287             
[ 1192.279580]  [<ffffffff8104530d>] ? worker_thread+0x121/0x1e7                
[ 1192.279580]  [<ffffffff810451ec>] ? rescuer_thread+0x265/0x265               
[ 1192.279580]  [<ffffffff810496be>] ? kthread+0x7d/0x85                        
[ 1192.279580]  [<ffffffff81049641>] ? __kthread_parkme+0x59/0x59               
[ 1192.279580]  [<ffffffff81369aec>] ? ret_from_fork+0x7c/0xb0                  
[ 1192.279580]  [<ffffffff81049641>] ? __kthread_parkme+0x59/0x59               
[ 1192.279580] ---[ end trace a14ae9e1a2282661 ]---                             
