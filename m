From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH trinity] trinity: use Boehm-Demers-Weiser's garbage collecting
 memory allocator
Date: Sun, 26 May 2013 11:51:24 +0200
Message-ID: <51A1DB1C.7050301@redhat.com>
References: <1369511265-28552-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1369511265-28552-1-git-send-email-dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davej@redhat.com, trinity@vger.kernel.org

On 05/25/2013 09:47 PM, Daniel Borkmann wrote:
> trinity currently quite often does not care about freeing memory on
> its own that was fetched through malloc(). Therefore it can happen if
> trinity runs for quite a long time, that oom-killer gets invoked. So
> for now use the Boehm-Demers-Weiser's garbage collecting memory
> allocator as a malloc replacement to avoid such situations.
>
> In this patch, we wrap all BDW functions into bdw_* equivalents, so that
> we could later on still #ifdef something if we want to and replace all
> calls based on the build. Calling bdw_free() is still legimite, but the
> memory is reclaimed via bdw_gcollect(), which would solve trinity's
> memory management.
>
> Dependency that we need when building (in case people don't want
> additional libs, follow-up patches could still #ifdef bdw_* wrappers
> to the glibc functions):
>
>    Fedora: yum install gc-devel
>
>    Debian: apt-get install libgc-dev
>
> More information on Boehm-Demers-Weiser allocator can be found here:
>
>    http://www.hpl.hp.com/personal/Hans_Boehm/gc/
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Please ignore this for now, will send a further improved v2 soon.
