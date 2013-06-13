From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH 4/4] trinity: use Boehm-Demers-Weiser's garbage collecting
 memory allocator
Date: Thu, 13 Jun 2013 21:57:36 +0300
Message-ID: <CA+ydwtrfNCfcbqb2GjgwZOaacChYjbkGD-nZH_gSjM5HWtS9fg@mail.gmail.com>
References: <cover.1370285968.git.dborkman@redhat.com>
	<1bdeb13f75006abc2d8ef622c7bf56f7627ad082.1370285968.git.dborkman@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=NYMQmEi2ctTQeyoCxjLb6/EBZDqwDBpg1jgsXRENh54=;
        b=WxZZd4yj2B9cWTvGbwAY5DNZgUKZGk6oGkoOLrxPkAp0B8Gy9eOKzNkLXyaxyCIz3L
         nQ4LxaAeQpJutUak6Y1h3qOZxxwlhv04tJ73JxSDLjVm7bA/1cGFK6ZOsfH40cl/7qWt
         +VV1AUlrEo85sw17oNJ41XUEX022KKJ5F065Ty4ZDORBA1W8nFzsfK8M/arO+9PDNbwp
         jZZMuwpwlNC98pig6u6qthMbyQxQSwAcPyHQ+fEV4HuUUzmZTa6z6XhKqe32o/6BsU7j
         /ImLM1VhIFo+9k00LBelH8cMbkjkpOF+gXoI2WD6tJMfAy7exofzCAXvzdnnkmrt2pVJ
         RgqQ==
In-Reply-To: <1bdeb13f75006abc2d8ef622c7bf56f7627ad082.1370285968.git.dborkman@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: trinity@vger.kernel.org, Dave Jones <davej@redhat.com>

2013/6/3 Daniel Borkmann <dborkman@redhat.com>:
> trinity currently quite often does not care about freeing memory on
> its own that was fetched through malloc(). Therefore it can happen if
> trinity runs for quite a long time, that oom-killer gets invoked. So
> for now use the Boehm-Demers-Weiser's garbage collecting memory
> allocator as a malloc replacement to avoid such situations.
>
> In this patch, we wrap all BDW functions into bdw_* equivalents, so that
> we could later on still #ifdef something if we want to and replace all
> calls based on the build. Calling bdw_free() is still legimite although
> not needed, but the memory is reclaimed automatically in the background
> or forced via bdw_gcollect(), which would solve trinity's memory
> management.
>
> Dependency that we need when building (in case people don't want
> additional libs, follow-up patches could still #ifdef bdw_* wrappers
> to the glibc functions):
>
>   Fedora: yum install gc-devel
>
>   Debian: apt-get install libgc-dev
>
> More information on Boehm-Demers-Weiser allocator can be found here:
>
>   http://www.hpl.hp.com/personal/Hans_Boehm/gc/
>
> Note that it is said that the performance is competitive with malloc(3),
> free(3) calls.

Thanks, tried this a bit.

Based on a quick test, the performance impact is not acceptable.

Vanilla trinity:

$ timeout --signal=SIGINT 60 ./trinity -q -l off -C20
[...]
Ran 109049 syscalls. Successes: 20726  Failures: 88323

Patch applied:

$ timeout --signal=SIGINT 60 ./trinity-gc -q -l off -C20
[...]
Ran 17385 syscalls. Successes: 3073  Failures: 14312

I'm also seeing some warnings printed:

Bad GET_MEM arg
Bad GET_MEM arg
[29301] Random reseed: 2845759031
Bad GET_MEM arg
msgrcv (70) returned ENOSYS, marking as inactive.
msgrcv (70) returned ENOSYS, marking as inactive.
msgrcv (70) returned ENOSYS, marking as inactive.
[29301] Random reseed: 382749635
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!
GC Warning: Out of Memory! Heap size: 2 MiB. Returning NULL!

Tommi
