From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch 2/2] make perf_event_open() use init routine
Date: Wed, 19 Jun 2013 22:10:54 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306192209240.5613@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1306192205300.5613@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org


This makes the perf_event_open() syscall use the new init functionality.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 909b807..ad3e903 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -672,7 +671,6 @@ static long long random_event_config(__u32 *event_type, __u64 *config1)
 		break;
 
 	case PERF_TYPE_READ_FROM_SYSFS:
-		if (pmus==NULL) init_pmus();
 		config = random_sysfs_config(event_type,config1);
 		break;
 
@@ -1091,5 +1089,6 @@ struct syscall syscall_perf_event_open = {
 		},
 	},
 	.sanitise = sanitise_perf_event_open,
+	.init = init_pmus,
 	.flags = NEED_ALARM,
 };
