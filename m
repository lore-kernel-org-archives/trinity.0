From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: test processes are not all killed
Date: Wed, 2 Aug 2017 17:57:21 +0300
Message-ID: <CA+ydwtoYiyyyiBvmMOO9ELvipyTePA8E2hmeNsU=pbhymdKSrA@mail.gmail.com>
References: <20170801093813.nw3zj4nqb2jqpdtx@linux> <20170801153823.4z6nloqtnwnd3fe7@codemonkey.org.uk>
 <20170802030921.mwhtygus3oambllj@linux>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=WjWz5PBRIXgWNmBZh2yk9bXZfath9e0S7piu/gdhMXo=;
        b=hORLWtN9Ghpfunes4N6vUPar9kpYPbblgB5x6TKyTYqi/oThKY2c/fPU/i6ZrAyOG7
         uCeKp82kHd9tFowE+cPCiArgJzPiXKxBdNJFk2o5XH7AR/H5xMluL/9GUviTJjBsG5Wy
         UnxYlkWlbiu1Cl0V87JqEeF1jspLWKRFOn8YX58LyiMUklOG6H7HRNustQ8aBKHsWADD
         3ckFMYeAyiYsrhGhdB6AC6PGeaI7xhXrmSdyQeR3y4CGzZoLyG9CPNtUWuppD7TAfC0R
         gow+Tn32LkWBxlsornGjMU8GqMQNacAxKz42rgTwslIh6b+r4DIKyt82eXx75xtSG0UD
         tVLw==
In-Reply-To: <20170802030921.mwhtygus3oambllj@linux>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dai Xiang <xiangx.dai@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>, trinity@vger.kernel.org

2017-08-02 6:09 GMT+03:00 Dai Xiang <xiangx.dai@intel.com>:
> On Tue, Aug 01, 2017 at 11:38:23AM -0400, Dave Jones wrote:
>> On Tue, Aug 01, 2017 at 05:38:13PM +0800, Dai Xiang wrote:
>>  > Hi!
>>  > I use below cmds(with root permission) include trinity to test and find an interesting issue:
>>  >
>>  > cmd="trinity -q -q -l off -s $seed -x get_robust_list -x remap_file_pages -N 999999999"
>>  > cd /tmp
>>  > chroot --userspec nobody:nogroup / $cmd 2>&1 &
>>  > pid=$!
>>  > sleep 300s
>>  > kill -9 $pid

Hi,

"kill -9 $pid" only kills the main trinity pid, right?
So the watchdog and all the forked child processes will not get killed.

Maybe Dave knows better if the other trinity processes will kill
themselves if they get re-parented.

Perhaps you could do "killall -9 trinity" or something like that.

-Tommi
