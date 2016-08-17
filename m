From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] perf_event_open fix unexpected char warning
Date: Wed, 17 Aug 2016 13:14:20 -0400 (EDT)
Message-ID: <alpine.DEB.2.20.1608171311370.14822@macbook-air>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maine.edu; s=google;
        h=from:date:to:subject:message-id:user-agent:mime-version;
        bh=7/PRix1dEgFvaHCXRw4zALFeK6Km5axArphKDvvZBMM=;
        b=EhhCDhgI//fvRger0kQ60TCRRxaTTt3G8uaRskJ0jxXoEtrSfL3NgYlUBOef5G5IsV
         khM1SWtvlswXHcG+4TY+FQGlggipfvnHYvtKN8nfoUFtBVBZtf8gAcIXPRQaMU4yievk
         35j2LqwyhHHD39uZRL4pFWvw22zTJLu2x8hEU=
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


The perf_event_open code parses some files under /sys
There are some hex values there, traditionally these were all lowercase
but on RaspberryPi2 machines for whatever reason they use uppercase.
    
This led to warnings like this:
    
    Unexpected char A
    Unexpected char D
    Unexpected char D
    Unexpected char B

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index dd434bb..e299765 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -245,16 +245,20 @@ static int parse_generic(int pmu, const char *value,
 				if (value[ptr]==0) break;
 				if (value[ptr]==',') break;
 				if (! ( ((value[ptr]>='0') && (value[ptr]<='9'))
-                   			|| ((value[ptr]>='a') && (value[ptr]<='f'))) ) {
+					|| ((value[ptr]>='a') && (value[ptr]<='f'))
+					|| ((value[ptr]>='A') && (value[ptr]<='F'))) ) {
 					outputerr("Unexpected char %c\n", value[ptr]);
 				}
 				temp*=base;
 				if ((value[ptr]>='0') && (value[ptr]<='9')) {
 					temp+=value[ptr]-'0';
 				}
-				else {
+				else if ((value[ptr]>='a') && (value[ptr]<='f')) {
 					temp+=(value[ptr]-'a')+10;
 				}
+				else {
+					temp+=(value[ptr]-'A')+10;
+				}
 				i++;
 				ptr++;
 			}
