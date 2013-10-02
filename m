From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Wed, 2 Oct 2013 14:15:37 -0400
Message-ID: <20131002181537.GA30862@redhat.com>
References: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
 <20131002151244.GA10872@redhat.com>
 <CAEGbLtv4wtaRuTVDPxpQcg0WWv2jDaa59vpX5MHTWe=gz-zBoQ@mail.gmail.com>
 <20131002164337.GA17276@redhat.com>
 <CAEGbLtuTi3BZffyGLahgGDVp2YhqWMPwY6VLUOBdnfnVzZDeQQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtuTi3BZffyGLahgGDVp2YhqWMPwY6VLUOBdnfnVzZDeQQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 02, 2013 at 11:12:21AM -0700, Ildar Muslukhov wrote:
 > I finally was able to reproduce that bug. In order to validate the
 > assumption that the "syscall32 fix" patch introduced that bug I pulled
 > the latest trinity source and removed the patch at question from the
 > source (gladly patch was small). And I am still getting segfault.
 > Thus, assumption that this patch introduced that bug looks less
 > probable now. Furthermore, if you run trinity with a single 32 bit
 > function (-c perf_event_open,32 for example) it runs just fine.
 > 
 > Several observations from my runs:
 > 1) Not all 32 bit calls end up in segfault.
 > 2) All segfaults are calls to 32 bit syscall.
 > 
 > Still digging into what causes this, will keep you posted.

This may have been why I had this..

// FIXME: I forgot why this got disabled. Revisit.
//                     if (rand() % 100 < 10)
//                             shm->do32bit[childno] = TRUE;

in choose_syscall_table.

Probably an old bug that I've never found time to dig into.

	Dave
