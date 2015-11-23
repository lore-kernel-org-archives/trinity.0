From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: nouveau: iowrite32 oops & warning at
 drivers/gpu/drm/nouveau/nouveau_fence.c:198
Date: Mon, 23 Nov 2015 22:17:39 +0200
Message-ID: <CA+ydwtr670rK5kAAFkJ=BEMXAMWLHwim3754rVvqZaCdhh+4-Q@mail.gmail.com>
References: <CA+ydwtq3CT5iswJbWCBGN9_KqKANbaoeZdzvjm1fe9aiE=VQ-g@mail.gmail.com>
 <CAKb7Uvh+sGQJgEYb3SzVDH-YytX7WsU=EQnUEeZeWR-haHGdfA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
 h=mime-version:in-reply-to:references:date:message-id:subject:from:to
 :cc:content-type;
 bh=TTpDk+C1pyoBdeXBNgWNKe1aCJvbQEw/yttFG+N0D4o=;
 b=cCV0iSHuwpbSIhsP5CAM8hPEYVQK8iiHvXwqHnIZY0z85wABRmCdAAmKVcrX74uIf+
 UGtxevrZaz06wpMV2TN+bzazazOTbD4w3s946ezpqKXYohVE6HB1f3MlvZUUvbyOXn0x
 aAKsNLanrdXMKZ8R3GH6Ksia8JqM+jVJiFtw5gq/P25LZoHNc5gAgjcqKmJwHL//PhSh
 MmSOQucAyY1/liB4aDsjUuePhMUiPPR0tafciwPAcIbojHaYBYtGq0XovIY3yp14mi2B
 hXTJZPHA1Ep2+rLYhsaMN0yxPvGrITqlIYd5GmN27EuLxCevsTiWjmS/eXtjg3Ajpt9l
 evAg==
In-Reply-To: <CAKb7Uvh+sGQJgEYb3SzVDH-YytX7WsU=EQnUEeZeWR-haHGdfA@mail.gmail.com>
List-Id: <trinity.vger.kernel.org>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, trinity@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>, DRI Development <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>

MjAxNS0xMS0yMiAyMjo0OSBHTVQrMDI6MDAgSWxpYSBNaXJraW4gPGltaXJraW5AYWx1bS5taXQu
ZWR1PjoKPiBOb3Qgc3VyZSBpZiB0aGVzZSBhcHBseSBoZXJlIGJ1dCB0aGVyZSBhcmUgYSBjb3Vw
bGUgb2Ygb3V0c3RhbmRpbmcKPiBsb2NraW5nIGZpeGVzIGF2YWlsYWJsZSBpbgo+IGh0dHA6Ly9j
Z2l0LmZyZWVkZXNrdG9wLm9yZy9+ZGFya3RhbWEvbm91dmVhdS8gLS0gc3BlY2lmaWNhbGx5IHRo
ZXNlCj4gdHdvOgo+Cj4gaHR0cDovL2NnaXQuZnJlZWRlc2t0b3Aub3JnL35kYXJrdGFtYS9ub3V2
ZWF1L2NvbW1pdC8/aWQ9MmYzYTU2YWQwMTllMzc4YTM1MmU5Y2I3YTU1OWY0Nzg4MjZmMWE4Nwo+
IGh0dHA6Ly9jZ2l0LmZyZWVkZXNrdG9wLm9yZy9+ZGFya3RhbWEvbm91dmVhdS9jb21taXQvP2lk
PTQxNzliMTVjNmU5ZmNmYjI1M2U4MTFlNTQ3N2RlYmU0NmM4NGMzOTUKPgo+IE5vdCBzdXJlIGlm
IHRoZXkgYWZmZWN0IHRoaXMgcGFydGljdWxhciBpc3N1ZSwgYnV0IHRob3VnaHQgSSdkIHBvaW50
Cj4gaXQgb3V0LiBBcmUgeW91IGZ1enppbmcgd2l0aCBtdWx0aXBsZSB0aHJlYWRzLCBvciBqdXN0
IG9uZSBhdCBhIHRpbWU/Cj4gRG8geW91IGhhdmUgYSBicmFuY2ggc29tZXdoZXJlIHB1YmxpYyB3
aXRoIHRoZSBjaGFuZ2VzIHRvIGFkZCBub3V2ZWF1Cj4gaW9jdGwgc3VwcG9ydCB0byB0cmluaXR5
PwoKSGkhCgpJIGFwcGxpZWQgdGhvc2UgdHdvIG9uIHRvcCBvZiB2NC40LXJjMiwgYnV0IHRoZSBz
YW1lIHdhcm5pbmcgYW5kIG9vcHMKYXJlIHN0aWxsIGVhc2lseSByZXByb2R1Y2libGUuIEkgY2Fu
IHRlc3Qgd2l0aCBvbGRlciBrZXJuZWxzIGFuZC9vcgp0cnkgdG8gYmlzZWN0IHdoZW4gSSBoYXZl
IG1vcmUgdGltZSwgdW5sZXNzIGFueW9uZSBoYXMgYmV0dGVyIGlkZWFzLgoKSSdtIGFjdHVhbGx5
IHJ1bm5pbmcgdW5tb2RpZmllZCB0cmluaXR5LCBhbmQgZm9yIHRoaXMgcHVycG9zZSBvbmx5CmZ1
enppbmcgdGhlIGlvY3RsKCkgc3lzY2FsbCBmcm9tIG11bHRpcGxlIHByb2Nlc3NlcywgYW5kIG9w
ZW5pbmcgb25seQp0aGUgZmlsZXMgZnJvbSAvZGV2L2RyaS86CgokIC4vdHJpbml0eSAtcSAtbG9m
ZiAtQzIwIC1jIGlvY3RsIC1WIC9kZXYvZHJpLwoKVHJpbml0eSBrbm93cyBhYm91dCBhIGJ1bmNo
IG9mIERSTSBpb2N0bCBjb21tYW5kcywgYnV0IHRoZSByZXN0IG9mIHRoZQppb2N0bCBhcmd1bWVu
dHMgd2lsbCBiZSBnYXJiYWdlOgpodHRwczovL2dpdGh1Yi5jb20va2VybmVsc2xhY2tlci90cmlu
aXR5L2Jsb2IvbWFzdGVyL2lvY3Rscy9kcm0uYwoKVG9tbWkKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
