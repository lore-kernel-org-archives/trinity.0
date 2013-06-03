From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH trinity v2, RFT] trinity: use Boehm-Demers-Weiser's garbage
 collecting memory allocator
Date: Mon, 03 Jun 2013 20:11:01 +0200
Message-ID: <51ACDC35.1090708@redhat.com>
References: <1369564593-18728-1-git-send-email-dborkman@redhat.com> <CA+ydwtrZKC+8UQA0gw_Qp9PffUT5wrzr3e+qnQnfyFc78zEKKQ@mail.gmail.com> <51AC83DF.5020203@redhat.com> <CA+ydwtpdAR_GX7y1Pe0zqRFKhQMEwTXvvJXc1-P58FUxgu=mLA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CA+ydwtpdAR_GX7y1Pe0zqRFKhQMEwTXvvJXc1-P58FUxgu=mLA@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On 06/03/2013 02:40 PM, Tommi Rantala wrote:
> 2013/6/3 Daniel Borkmann <dborkman@redhat.com>:
>> On 06/03/2013 08:25 AM, Tommi Rantala wrote:
>>> 'line' is allocated implicitly by getline(), is it safe to bdw_free() it?
>>
>> True, thanks for catching! Not sure if we want to proceed with this patch or
>> put it
>> on hold for now? Let me know, if wished, I could send an update.
>
> Dunno what Dave thinks, but IMO this seems pretty cool!
>
> Did not have a chance to actually test this yet, would like to of
> course see if there are any unforeseen performance or reliability
> troubles.
>
> So yes, please send an updated patch if you have time.

Ok, will submit v3 tonight, together with the other 3 patches you need before
applying this one.
