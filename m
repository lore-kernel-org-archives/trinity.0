From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Expected 0x
Date: Thu, 4 Jul 2013 00:28:02 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1307040023540.23758@vincent-weaver-1.um.maine.edu>
References: <20130703182141.GA13149@redhat.com> <alpine.DEB.2.10.1307031701440.14644@vincent-weaver-1.um.maine.edu> <20130703212941.GA26512@redhat.com> <alpine.DEB.2.10.1307032316420.13409@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1307032316420.13409@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

On Wed, 3 Jul 2013, Vince Weaver wrote:

> I'll see if I can figure out llvm, I've been wanting an excuse to look 
> into it.

well it turns out it was as simple as "apt-get install clang"
"make scan".  Too easy.

> The values that it is complaining about are gathered via a fscanf followed 
> by a strdup, so in theory if the fscanf fails (due to the file being 
> empty) or if strdup() fails (due to OOM) it is indeed possible the string 
> is garbage.  I can add handling for those conditions to see if it helps.

I was slightly off, the problem turned out to be if we fail at fopen()
we never got to the fscanf(), but we'd then still call parse_format()
with an uninitialized format_value.  So good catch by llvm.

The following should fix things.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/syscalls/perf_event_open.c b/syscalls/perf_event_open.c
index 5df6bed..0835de7 100644
--- a/syscalls/perf_event_open.c
+++ b/syscalls/perf_event_open.c
@@ -323,18 +323,19 @@ static int init_pmus(void) {
 					pmus[pmu_num].formats[format_num].value=
 						strdup(format_value);
 					fclose(fff);
-				}
-				parse_format(format_value,
+
+					parse_format(format_value,
 						&pmus[pmu_num].formats[format_num].field,
 						&pmus[pmu_num].formats[format_num].shift,
 						&pmus[pmu_num].formats[format_num].bits);
-				if (pmus[pmu_num].formats[format_num].bits==64) {
-					pmus[pmu_num].formats[format_num].mask=0xffffffffffffffffULL;
-				} else {
-					pmus[pmu_num].formats[format_num].mask=
-						(1ULL<<pmus[pmu_num].formats[format_num].bits)-1;
+					if (pmus[pmu_num].formats[format_num].bits==64) {
+						pmus[pmu_num].formats[format_num].mask=0xffffffffffffffffULL;
+					} else {
+						pmus[pmu_num].formats[format_num].mask=
+							(1ULL<<pmus[pmu_num].formats[format_num].bits)-1;
+					}
+					format_num++;
 				}
-				format_num++;
 			}
 			closedir(format_dir);
 		}
