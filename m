From: Vinson Lee <vlee@twopensource.com>
Subject: "selinux_nlmsg_perm: unrecognized netlink message: protocol=0
 nlmsg_type=0 sclass=30" warning on Linux 3.18-rc3
Date: Tue, 4 Nov 2014 12:12:56 -0800
Message-ID: <CAHTgTXVyR3hoZDSp6QRTtJ9+cAuPXsPomfDBw0zisft=7H_7dA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Cc: trinity@vger.kernel.org

Hi.

trinity triggered this kernel warning in selinux_netlink_send on Linux 3.18-rc3.

------------[ cut here ]------------
WARNING: CPU: 8 PID: 53557 at security/selinux/hooks.c:4730
selinux_netlink_send+0x9e/0xfc()
selinux_nlmsg_perm: unrecognized netlink message: protocol=0
nlmsg_type=0 sclass=30
Modules linked in: af_key l2tp_ppp l2tp_netlink l2tp_core nfnetlink
can_bcm scsi_transport_iscsi can_raw can pppoe pppox ppp_generic slhc
netconsole configfs ipv6 dm_multipath scsi_dh video sbs sbshc acpi_pad
acpi_ipmi parport_pc lp parport tcp_diag inet_diag ipmi_devintf sg
mlx4_en ptp pps_core vxlan udp_tunnel ip6_udp_tunnel mlx4_core
iTCO_wdt iTCO_vendor_support dcdbas wmi ioatdma sb_edac hed i2c_i801
i2c_core microcode edac_core ipmi_si ipmi_msghandler lpc_ich mfd_core
shpchp dca ahci libahci libata sd_mod scsi_mod
CPU: 8 PID: 53557 Comm: trinity-c8 Not tainted 3.18.0-rc3 #1
 0000000000000009 ffff88104c153be8 ffffffff814daf56 00000000000000e5
 ffff88104c153c38 ffff88104c153c28 ffffffff8106010d ffffffff8142815f
 ffffffff8123431e 00000000ffffffea ffff8800770be800 0000000000000000
Call Trace:
 [<ffffffff814daf56>] dump_stack+0x46/0x58
 [<ffffffff8106010d>] warn_slowpath_common+0x81/0x9b
 [<ffffffff8142815f>] ? __alloc_skb+0x84/0x1b1
 [<ffffffff8123431e>] ? selinux_netlink_send+0x9e/0xfc
 [<ffffffff8106016d>] warn_slowpath_fmt+0x46/0x48
 [<ffffffff8123431e>] selinux_netlink_send+0x9e/0xfc
 [<ffffffff8123119b>] security_netlink_send+0x16/0x18
 [<ffffffff8145bf30>] netlink_sendmsg+0x570/0x630
 [<ffffffff81232aeb>] ? sock_has_perm+0x63/0x6a
 [<ffffffff8141ea6f>] __sock_sendmsg_nosec+0x25/0x27
 [<ffffffff81420252>] sock_aio_write+0xc6/0xdd
 [<ffffffff81233255>] ? file_has_perm+0x5d/0x81
 [<ffffffff8116835b>] do_sync_write+0x55/0x78
 [<ffffffff81168c8e>] vfs_write+0xbb/0x124
 [<ffffffff81169321>] SyS_write+0x44/0x78
 [<ffffffff814e26b9>] ia32_do_call+0x13/0x13
---[ end trace 9c4105cdf6c3f1b1 ]---

Cheers,
Vinson
