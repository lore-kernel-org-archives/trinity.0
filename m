From: Vince Weaver <vincent.weaver@maine.edu>
Subject: [patch] fix divide by zero in random/taviso()
Date: Fri, 17 Jan 2014 15:41:58 -0500 (EST)
Message-ID: <alpine.DEB.2.10.1401171541490.6771@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401171519070.6751@vincent-weaver-1.um.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1401171519070.6751@vincent-weaver-1.um.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org


I'm not sure if this is the cleanest fix for the issue, but it seems to 
work for me.

In random.c the taviso() routine uses "rand() % rand()" which
can cause a floating point exception if rand() returns 0.
Add some tests to make sure that doesn't happen.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/random.c b/random.c
index 7def9ff..a71fcea 100644
--- a/random.c
+++ b/random.c
@@ -42,6 +42,7 @@ static unsigned long randbits(int limit)
 static unsigned long taviso(void)
 {
 	unsigned long r = 0;
+	unsigned long temp;
 
 	switch (rand() % 4) {
 	case 0:	r = rand() & rand();
@@ -51,10 +52,14 @@ static unsigned long taviso(void)
 #endif
 		break;
 
-	case 1:	r = rand() % rand();
+	case 1:	temp = rand();
+		r = rand();
+		if (!temp) r %= temp;
 #if __WORDSIZE == 64
 		r <<= 32;
-		r |= rand() % rand();
+
+		temp = rand();
+		if (!temp) r |= rand() % temp;
 #endif
 		break;
 
