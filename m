From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: perf,arm -- another (different) fuzzer oops
Date: Wed, 7 Aug 2013 22:03:42 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1308072157320.16962@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com> <5202D5B0.9020107@codeaurora.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-763390395-1375927430=:16962"
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <5202D5B0.9020107@codeaurora.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Vince Weaver <vincent.weaver@maine.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <Mark.Rutland@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, "trinity@vger.kernel.org" <trinity@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-763390395-1375927430=:16962
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Wed, 7 Aug 2013, Stephen Boyd wrote:

> Is config some really big value? It looks like config (or more
> specifically event->attr.config) is ecececec which is larger than 9
> (PERF_COUNT_HW_MAX). I'm fairly certain r4 is event->attr.type
> (PERF_TYPE_HARDWARE) and so we're out of bounds on that array access in
> armpmu_map_hw_event(). Does the below patch fix that?

Yes, it was big values in attr.config.  I managed to bisect down to a
simple test case, which is attached.  Oddly the test case has two events
before the oops happens; I should double check to make sure both are 
really necessary.

I'll try this patch and see if it fixes things, thanks.

Vince


--8323329-763390395-1375927430=:16962
Content-Type: TEXT/x-csrc; name=arm_perf_new_oops.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1308072203420.16962@vincent-weaver-1.um.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=arm_perf_new_oops.c

LyogbG9nX3RvX2NvZGUgb3V0cHV0IGZyb20gLi9uZXdfb29wcy5iaXNlY3Qx
NSAqLw0KLyogYnkgVmluY2UgV2VhdmVyIDx2aW5jZW50LndlYXZlciBfYXRf
IG1haW5lLmVkdSAqLw0KDQojaW5jbHVkZSA8c3RkaW8uaD4NCiNpbmNsdWRl
IDx1bmlzdGQuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNsdWRlIDxz
aWduYWwuaD4NCiNpbmNsdWRlIDxzeXMvbW1hbi5oPg0KI2luY2x1ZGUgPHN5
cy9zeXNjYWxsLmg+DQojaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQojaW5jbHVk
ZSA8c3lzL3ByY3RsLmg+DQojaW5jbHVkZSA8bGludXgvaHdfYnJlYWtwb2lu
dC5oPg0KI2luY2x1ZGUgPGxpbnV4L3BlcmZfZXZlbnQuaD4NCg0KaW50IGZk
WzEwMjRdOw0Kc3RydWN0IHBlcmZfZXZlbnRfYXR0ciBwZVsxMDI0XTsNCmNo
YXIgKm1tYXBfcmVzdWx0WzEwMjRdOw0KI2RlZmluZSBNQVhfUkVBRF9TSVpF
IDY1NTM2DQpzdGF0aWMgbG9uZyBsb25nIGRhdGFbTUFYX1JFQURfU0laRV07
DQoNCmludCBmb3JrZWRfcGlkOw0KDQppbnQgcGVyZl9ldmVudF9vcGVuKHN0
cnVjdCBwZXJmX2V2ZW50X2F0dHIgKmh3X2V2ZW50X3VwdHIsDQoJcGlkX3Qg
cGlkLCBpbnQgY3B1LCBpbnQgZ3JvdXBfZmQsIHVuc2lnbmVkIGxvbmcgZmxh
Z3MpIHsNCg0KCXJldHVybiBzeXNjYWxsKF9fTlJfcGVyZl9ldmVudF9vcGVu
LGh3X2V2ZW50X3VwdHIsIHBpZCwgY3B1LA0KCQlncm91cF9mZCwgZmxhZ3Mp
Ow0KfQ0KDQppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpIHsNCi8q
IDEgKi8NCg0KCW1lbXNldCgmcGVbMF0sMCxzaXplb2Yoc3RydWN0IHBlcmZf
ZXZlbnRfYXR0cikpOw0KCXBlWzBdLnR5cGU9UEVSRl9UWVBFX0hBUkRXQVJF
Ow0KCXBlWzBdLmNvbmZpZz0weDJjYzYxMDA2Ow0KCXBlWzBdLnNhbXBsZV90
eXBlPTA7IC8qIDAgKi8NCglwZVswXS5yZWFkX2Zvcm1hdD1QRVJGX0ZPUk1B
VF9UT1RBTF9USU1FX0VOQUJMRUR8UEVSRl9GT1JNQVRfVE9UQUxfVElNRV9S
VU5OSU5HfFBFUkZfRk9STUFUX0dST1VQOyAvKiBiICovDQoJcGVbMF0uZGlz
YWJsZWQ9MTsNCglwZVswXS5leGNsdXNpdmU9MTsNCglwZVswXS5leGNsdWRl
X2lkbGU9MTsNCglwZVswXS5jb21tPTE7DQoJcGVbMF0uaW5oZXJpdF9zdGF0
PTE7DQoJcGVbMF0uZW5hYmxlX29uX2V4ZWM9MTsNCglwZVswXS5wcmVjaXNl
X2lwPTA7IC8qIGFyYml0cmFyeSBza2lkICovDQoJcGVbMF0ubW1hcF9kYXRh
PTE7DQoJcGVbMF0uc2FtcGxlX2lkX2FsbD0xOw0KCXBlWzBdLmV4Y2x1ZGVf
aG9zdD0xOw0KCXBlWzBdLmV4Y2x1ZGVfZ3Vlc3Q9MTsNCglwZVswXS53YWtl
dXBfZXZlbnRzPTIxNDc0ODM2NDc7DQoJcGVbMF0uYnBfdHlwZT1IV19CUkVB
S1BPSU5UX0VNUFRZOw0KCXBlWzBdLmJyYW5jaF9zYW1wbGVfdHlwZT0yMTQ3
NDgzNjQ4VUxMOw0KDQoJZmRbMF09cGVyZl9ldmVudF9vcGVuKCZwZVswXSww
LDAsLTEsUEVSRl9GTEFHX0ZEX05PX0dST1VQIC8qMSovICk7DQoNCi8qIDIg
Ki8NCg0KCW1lbXNldCgmcGVbMV0sMCxzaXplb2Yoc3RydWN0IHBlcmZfZXZl
bnRfYXR0cikpOw0KCXBlWzFdLnR5cGU9UEVSRl9UWVBFX1JBVzsNCglwZVsx
XS5zaXplPTgwOw0KCXBlWzFdLmNvbmZpZz0weGI2YzhhZDk5Ow0KCXBlWzFd
LnNhbXBsZV90eXBlPTA7IC8qIDAgKi8NCglwZVsxXS5yZWFkX2Zvcm1hdD1Q
RVJGX0ZPUk1BVF9UT1RBTF9USU1FX0VOQUJMRUR8UEVSRl9GT1JNQVRfSUR8
MHg4MDAwMDAxMFVMTDsgLyogODAwMDAwMTUgKi8NCglwZVsxXS5pbmhlcml0
PTE7DQoJcGVbMV0uZXhjbHVkZV91c2VyPTE7DQoJcGVbMV0uZXhjbHVkZV9o
dj0xOw0KCXBlWzFdLm1tYXA9MTsNCglwZVsxXS5pbmhlcml0X3N0YXQ9MTsN
CglwZVsxXS50YXNrPTE7DQoJcGVbMV0ucHJlY2lzZV9pcD0zOyAvKiBtdXN0
IGhhdmUgemVybyBza2lkICovDQoJcGVbMV0uc2FtcGxlX2lkX2FsbD0xOw0K
CXBlWzFdLmV4Y2x1ZGVfZ3Vlc3Q9MTsNCglwZVsxXS53YWtldXBfZXZlbnRz
PTA7DQoJcGVbMV0uYnBfdHlwZT1IV19CUkVBS1BPSU5UX0VNUFRZOw0KDQoJ
ZmRbMV09cGVyZl9ldmVudF9vcGVuKCZwZVsxXSwwLDAsLTEsUEVSRl9GTEFH
X0ZEX05PX0dST1VQIC8qMSovICk7DQoNCgkvKiBSZXBsYXllZCAyIHN5c2Nh
bGxzICovDQoJcmV0dXJuIDA7DQp9DQo=

--8323329-763390395-1375927430=:16962--
