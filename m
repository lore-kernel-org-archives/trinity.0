From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: "selinux_nlmsg_perm: unrecognized netlink message: protocol=0
 nlmsg_type=0 sclass=30" warning on Linux 3.18-rc3
Date: Wed, 05 Nov 2014 15:51:52 -0500
Message-ID: <545A8DE8.1010106@tycho.nsa.gov>
References: <CAHTgTXVyR3hoZDSp6QRTtJ9+cAuPXsPomfDBw0zisft=7H_7dA@mail.gmail.com> <1588252.T4atn8E9DE@sifl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1588252.T4atn8E9DE@sifl>
Sender: linux-security-module-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Moore <paul@paul-moore.com>, Vinson Lee <vlee@twopensource.com>
Cc: Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, trinity@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>

On 11/05/2014 03:48 PM, Paul Moore wrote:
> On Tuesday, November 04, 2014 12:12:56 PM Vinson Lee wrote:
>> Hi.
>>
>> trinity triggered this kernel warning in selinux_netlink_send on Linux
>> 3.18-rc3.
> 
> It looks like trinity sent a bogus netlink message to the kernel and SELinux 
> responded as I would expect it to, with a WARN_ONCE() message.  Thank you for 
> your help in testing, but I don't see a problem here that needs to be 
> resolved.

I guess the only thing new here is that this message used to be directed
to the audit system via audit_log() and was changed to use WARN_ONCE().
 Why was that change made (the change description gives no rationale)?
Is this an appropriate use of WARN_ONCE()?

> 
>> ------------[ cut here ]------------
>> WARNING: CPU: 8 PID: 53557 at security/selinux/hooks.c:4730
>> selinux_netlink_send+0x9e/0xfc()
>> selinux_nlmsg_perm: unrecognized netlink message: protocol=0
>> nlmsg_type=0 sclass=30
>> Modules linked in: af_key l2tp_ppp l2tp_netlink l2tp_core nfnetlink
>> can_bcm scsi_transport_iscsi can_raw can pppoe pppox ppp_generic slhc
>> netconsole configfs ipv6 dm_multipath scsi_dh video sbs sbshc acpi_pad
>> acpi_ipmi parport_pc lp parport tcp_diag inet_diag ipmi_devintf sg
>> mlx4_en ptp pps_core vxlan udp_tunnel ip6_udp_tunnel mlx4_core
>> iTCO_wdt iTCO_vendor_support dcdbas wmi ioatdma sb_edac hed i2c_i801
>> i2c_core microcode edac_core ipmi_si ipmi_msghandler lpc_ich mfd_core
>> shpchp dca ahci libahci libata sd_mod scsi_mod
>> CPU: 8 PID: 53557 Comm: trinity-c8 Not tainted 3.18.0-rc3 #1
>>  0000000000000009 ffff88104c153be8 ffffffff814daf56 00000000000000e5
>>  ffff88104c153c38 ffff88104c153c28 ffffffff8106010d ffffffff8142815f
>>  ffffffff8123431e 00000000ffffffea ffff8800770be800 0000000000000000
>> Call Trace:
>>  [<ffffffff814daf56>] dump_stack+0x46/0x58
>>  [<ffffffff8106010d>] warn_slowpath_common+0x81/0x9b
>>  [<ffffffff8142815f>] ? __alloc_skb+0x84/0x1b1
>>  [<ffffffff8123431e>] ? selinux_netlink_send+0x9e/0xfc
>>  [<ffffffff8106016d>] warn_slowpath_fmt+0x46/0x48
>>  [<ffffffff8123431e>] selinux_netlink_send+0x9e/0xfc
>>  [<ffffffff8123119b>] security_netlink_send+0x16/0x18
>>  [<ffffffff8145bf30>] netlink_sendmsg+0x570/0x630
>>  [<ffffffff81232aeb>] ? sock_has_perm+0x63/0x6a
>>  [<ffffffff8141ea6f>] __sock_sendmsg_nosec+0x25/0x27
>>  [<ffffffff81420252>] sock_aio_write+0xc6/0xdd
>>  [<ffffffff81233255>] ? file_has_perm+0x5d/0x81
>>  [<ffffffff8116835b>] do_sync_write+0x55/0x78
>>  [<ffffffff81168c8e>] vfs_write+0xbb/0x124
>>  [<ffffffff81169321>] SyS_write+0x44/0x78
>>  [<ffffffff814e26b9>] ia32_do_call+0x13/0x13
>> ---[ end trace 9c4105cdf6c3f1b1 ]---
>>
>> Cheers,
>> Vinson
> 

