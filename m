From: Vinson Lee <vlee@freedesktop.org>
Subject: WARNING: at kernel/signal.c:2955 do_rt_tgsigqueueinfo
Date: Mon, 12 Aug 2013 14:00:06 -0700
Message-ID: <CACKvgLEK6G3aF=cFgtTjRLavV4FaFaJGbsOFNKDey57_02H0jQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:date:message-id:subject:from:to:content-type;
        bh=V0PMxFdrtGo3b7WZFC0koriOvLQdltQ13f59RTk6Ak4=;
        b=CaQ1dWs0YOxn/DiTGSfUjQWh7uU3k/V5/HCm2XiP9KKVQlNnvEFf8yXlWTUaq7s2st
         E2qn4jlzu9ilIOR4vvfcCkwpjUCcfoiId3dwL48nYBA2NaVRO1aQLTbNFweEKxFI8+Xh
         +tv+t0HCQ+BVqxJYvywhjwRe5fL27mww0xYxoMnlGibB7DT8/NGHHOFB0ljfBHBe7KqM
         9YGfsf2zMvK4DCKf1xW9hNOUiG1IT+rKnyRI2pfYDIfp8aDIRnbNJvJFzJ8Op4LTBupx
         YwVlOVCDSw4St4MMTjfHkFM4+KC6asfWs4i6cjqWVf2mE+WwKehzzX6V4l6YZjO3sprb
         UWpQ==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hi.

trinity triggered this kernel warning on Linux 3.4.55. It doesn't look
like a real kernel bug. Maybe this can be avoided in trinity?

[236919.099412] ------------[ cut here ]------------
[236919.120920] WARNING: at kernel/signal.c:2955
do_rt_tgsigqueueinfo+0x42/0x5c()
[236919.160215] Modules linked in: bridge stp scsi_transport_iscsi
nfnetlink ipt_ULOG tun ip6_queue ip_queue fuse can_bcm microcode sctp
libcrc32c can_raw l2tp_ppp l2tp_netlink l2tp_core can af_802154 rds
atm decnet af_key pppoe pppox ppp_generic slhc ipx p8022 p8023
appletalk psnap llc phonet netconsole configfs cpufreq_ondemand
acpi_cpufreq freq_table mperf bonding ipv6 ppdev parport_pc lp parport
tcp_diag inet_diag ipmi_si ipmi_devintf ipmi_msghandler hed dcdbas
joydev coretemp crc32c_intel ghash_clmulni_intel pcspkr i2c_i801
i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma igb dca wmi [last
unloaded: microcode]
[236919.350287] Pid: 32778, comm: trinity-child1 Not tainted 3.4.55 #1
[236919.378480] Call Trace:
[236919.387951]  [<ffffffff8104920c>] warn_slowpath_common+0x85/0x9d
[236919.408632]  [<ffffffff8104923e>] warn_slowpath_null+0x1a/0x1c
[236919.428645]  [<ffffffff810591eb>] do_rt_tgsigqueueinfo+0x42/0x5c
[236919.448474]  [<ffffffff81059257>] sys_rt_tgsigqueueinfo+0x52/0x5f
[236919.468761]  [<ffffffff814df4a9>] system_call_fastpath+0x16/0x1b
[236919.488736] ---[ end trace 6b2ad461ac6cbd87 ]---

kernel/signal.c
  2944  long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
siginfo_t *info)
  2945  {
  2946          /* This is only valid for single tasks */
  2947          if (pid <= 0 || tgid <= 0)
  2948                  return -EINVAL;
  2949
  2950          /* Not even root can pretend to send signals from the kernel.
  2951           * Nor can they impersonate a kill()/tgkill(), which
adds source info.
  2952           */
  2953          if (info->si_code >= 0 || info->si_code == SI_TKILL) {
  2954                  /* We used to allow any < 0 si_code */
  2955                  WARN_ON_ONCE(info->si_code < 0);
  2956                  return -EPERM;
  2957          }
  2958          info->si_signo = sig;
  2959
  2960          return do_send_specific(tgid, pid, sig, info);
  2961  }

Cheers,
Vinson
