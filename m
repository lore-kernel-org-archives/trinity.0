From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Wed, 2 Oct 2013 16:48:30 -0400
Message-ID: <20131002204830.GA7803@redhat.com>
References: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
 <20131002151244.GA10872@redhat.com>
 <CAEGbLtv4wtaRuTVDPxpQcg0WWv2jDaa59vpX5MHTWe=gz-zBoQ@mail.gmail.com>
 <20131002164337.GA17276@redhat.com>
 <CAEGbLtuTi3BZffyGLahgGDVp2YhqWMPwY6VLUOBdnfnVzZDeQQ@mail.gmail.com>
 <20131002181537.GA30862@redhat.com>
 <CAEGbLttVfFEc0-LNGPYfFthQwx7j5ME38R8a4uCGa8NNWaxueQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLttVfFEc0-LNGPYfFthQwx7j5ME38R8a4uCGa8NNWaxueQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 02, 2013 at 01:44:44PM -0700, Ildar Muslukhov wrote:
 > That's what I though as well. However, just encountered segfaults on
 > x64 read syscall. Although this one might be legit.

in case you didn't realise, there's a few cases where we expect to segfault.

for eg, if we mprotect page_rand to PROT_NONE and then something tries to read it.
There's a whole bunch of similar gotchas. I've special cased the sanitise routines
of some syscalls to avoid this sort of thing, but there's a few cases where
a trinity child will corrupt itself. It then dies, and respawns, so I haven't really
worried too much about it.

	Dave
