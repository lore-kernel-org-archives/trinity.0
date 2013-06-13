From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH 4/4] trinity: use Boehm-Demers-Weiser's garbage collecting
 memory allocator
Date: Thu, 13 Jun 2013 22:07:54 +0200
Message-ID: <51BA269A.2040404@redhat.com>
References: <cover.1370285968.git.dborkman@redhat.com> <1bdeb13f75006abc2d8ef622c7bf56f7627ad082.1370285968.git.dborkman@redhat.com> <CA+ydwtrfNCfcbqb2GjgwZOaacChYjbkGD-nZH_gSjM5HWtS9fg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CA+ydwtrfNCfcbqb2GjgwZOaacChYjbkGD-nZH_gSjM5HWtS9fg@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

On 06/13/2013 08:57 PM, Tommi Rantala wrote:
> 2013/6/3 Daniel Borkmann <dborkman@redhat.com>:
>> trinity currently quite often does not care about freeing memory on
>> its own that was fetched through malloc(). Therefore it can happen if
>> trinity runs for quite a long time, that oom-killer gets invoked. So
>> for now use the Boehm-Demers-Weiser's garbage collecting memory
>> allocator as a malloc replacement to avoid such situations.
>>
>> In this patch, we wrap all BDW functions into bdw_* equivalents, so that
>> we could later on still #ifdef something if we want to and replace all
>> calls based on the build. Calling bdw_free() is still legimite although
>> not needed, but the memory is reclaimed automatically in the background
>> or forced via bdw_gcollect(), which would solve trinity's memory
>> management.
>>
>> Dependency that we need when building (in case people don't want
>> additional libs, follow-up patches could still #ifdef bdw_* wrappers
>> to the glibc functions):
>>
>>    Fedora: yum install gc-devel
>>
>>    Debian: apt-get install libgc-dev
>>
>> More information on Boehm-Demers-Weiser allocator can be found here:
>>
>>    http://www.hpl.hp.com/personal/Hans_Boehm/gc/
>>
>> Note that it is said that the performance is competitive with malloc(3),
>> free(3) calls.
>
> Thanks, tried this a bit.
>
> Based on a quick test, the performance impact is not acceptable.
>
> Vanilla trinity:
>
> $ timeout --signal=SIGINT 60 ./trinity -q -l off -C20
> [...]
> Ran 109049 syscalls. Successes: 20726  Failures: 88323
>
> Patch applied:
>
> $ timeout --signal=SIGINT 60 ./trinity-gc -q -l off -C20
> [...]
> Ran 17385 syscalls. Successes: 3073  Failures: 14312

Thanks for testing Tommi !

This does not look good and opposes the claim of the authors
pretty much.

Then I agree that we should drop this, and solve it otherwise,
e.g. via callback handlers that do some cleanup if necessary.

Cheers,

Daniel
