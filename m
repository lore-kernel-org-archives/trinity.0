From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Make the keyring cycle detector ignore other keyrings of the same name
Date: Tue, 04 Mar 2014 16:10:49 +0000
Message-ID: <15425.1393949449@warthog.procyon.org.uk>
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, tt.rantala@gmail.com, keyrings@linux-nfs.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, trinity@vger.kernel.org, Dave Jones <davej@redhat.com>


This fixes CVE-2014-0102.

The following command sequence produces an oops:

	keyctl new_session
	i=`keyctl newring _ses @s`
	keyctl link @s $i

The problem is that search_nested_keyrings() sees two keyrings that have
matching type and description, so keyring_compare_object() returns true.
s_n_k() then passes the key to the iterator function -
keyring_detect_cycle_iterator() - which *should* check to see whether this is
the keyring of interest, not just one with the same name.

Because assoc_array_find() will return one and only one match, I assumed that
the iterator function would only see an exact match or never be called - but
the iterator isn't only called from assoc_array_find()...

The oops looks something like this:

	kernel BUG at /data/fs/linux-2.6-fscache/security/keys/keyring.c:1003!
	invalid opcode: 0000 [#1] SMP
	...
	RIP: 0010:[<ffffffff811d39c3>] keyring_detect_cycle_iterator+0xe/0x1f
	...
	Stack:
	...
	Call Trace:
	 [<ffffffff811d3706>] search_nested_keyrings+0x76/0x2aa
	 [<ffffffff810fa7f4>] ? kmem_cache_alloc_trace+0xdd/0x159
	 [<ffffffff81235669>] ? assoc_array_insert+0xab/0x929
	 [<ffffffff811e226d>] ? selinux_key_permission+0x2d/0x2f
	 [<ffffffff811dc94c>] ? security_key_permission+0x11/0x13
	 [<ffffffff811d3e36>] __key_link_check_live_key+0x50/0x5f
	 [<ffffffff811d39b5>] ? keyring_describe+0x7b/0x7b
	 [<ffffffff811d3f2b>] key_link+0x4e/0x85
	 [<ffffffff811d463a>] keyctl_keyring_link+0x60/0x81
	 [<ffffffff811d553d>] SyS_keyctl+0x65/0xe4
	 [<ffffffff81452edb>] tracesys+0xdd/0xe2

The fix is to make keyring_detect_cycle_iterator() check that the key it has
is the key it was actually looking for rather than calling BUG_ON().

A testcase has been included in the keyutils testsuite for this:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/commit/?id=891f3365d07f1996778ade0e3428f01878a1790b

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index d46cbc5e335e..2fb2576dc644 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1000,7 +1000,11 @@ static int keyring_detect_cycle_iterator(const void *object,
 
 	kenter("{%d}", key->serial);
 
-	BUG_ON(key != ctx->match_data);
+	/* We might get a keyring with matching index-key that is nonetheless a
+	 * different keyring. */
+	if (key != ctx->match_data)
+		return 0;
+
 	ctx->result = ERR_PTR(-EDEADLK);
 	return 1;
 }
