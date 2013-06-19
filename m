From: Sravan V Dodla <sravan@linux.vnet.ibm.com>
Subject: [PATCH] Removing arguments of KVM_S390_STORE_STATUS
Date: Wed, 19 Jun 2013 18:45:14 +0530
Message-ID: <1371647714.4704.9.camel@oc6144502753.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org

Removing unused arguments of KVM_S390_STORE_STATUS.

---
 ioctls/kvm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/ioctls/kvm.c b/ioctls/kvm.c
index 4620ca8..48322d4 100644
--- a/ioctls/kvm.c
+++ b/ioctls/kvm.c
@@ -87,8 +87,6 @@ static const struct ioctl kvm_ioctls[] = {
 	IOCTL(KVM_SET_VAPIC_ADDR),
 #if defined(__s390__)
 	IOCTL(KVM_S390_INTERRUPT),
-	IOCTL(KVM_S390_STORE_STATUS_NOADDR),
-	IOCTL(KVM_S390_STORE_STATUS_PREFIXED),
 	IOCTL(KVM_S390_STORE_STATUS),
 	IOCTL(KVM_S390_SET_INITIAL_PSW),
 	IOCTL(KVM_S390_INITIAL_RESET),
-- 
1.7.1

Regards,
-Sravan.
