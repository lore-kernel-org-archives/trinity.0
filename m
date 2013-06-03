From: Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH trinity v2, RFT] trinity: use Boehm-Demers-Weiser's
 garbage collecting memory allocator
Date: Mon, 3 Jun 2013 15:40:19 +0300
Message-ID: <CA+ydwtpdAR_GX7y1Pe0zqRFKhQMEwTXvvJXc1-P58FUxgu=mLA@mail.gmail.com>
References: <1369564593-18728-1-git-send-email-dborkman@redhat.com>
	<CA+ydwtrZKC+8UQA0gw_Qp9PffUT5wrzr3e+qnQnfyFc78zEKKQ@mail.gmail.com>
	<51AC83DF.5020203@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=wOEQbfHk4ilAytTIroWevQmKeqtQ9FH4Y9bk+tdcNXY=;
        b=wQLtjaS1X0y6Otz84obUiNnNaSxH1ZHGy0uEktWQyxspneZFyhJigLnuZ1MHXXJxc2
         Y2TTWVfmIHCvcehnIRzDO3oRfjkISKWSUwz4Y/fND8kdeQGlbCcCWpt0VJ75yE2pnW5B
         gPjuz0W+3tN1xjDU7RBDu6K/PuitLgukBZBAnVoZcg1zRZLJy9JYYALLqA+GELy9y52Z
         Irj9a0l4riweiJqBDlNVIHPSRZXIeEhwPuRAid0DakmMCO6Ac0+cRpSgx/PKL076+rCc
         5HQ16gyQNY0r09BkBiPSwM/rggVFiF1xe7q95HxzEfDSumr5aMzweI9V3v8Sgg83rq83
         lUsg==
In-Reply-To: <51AC83DF.5020203@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

2013/6/3 Daniel Borkmann <dborkman@redhat.com>:
> On 06/03/2013 08:25 AM, Tommi Rantala wrote:
>> 'line' is allocated implicitly by getline(), is it safe to bdw_free() it?
>
> True, thanks for catching! Not sure if we want to proceed with this patch or
> put it
> on hold for now? Let me know, if wished, I could send an update.

Dunno what Dave thinks, but IMO this seems pretty cool!

Did not have a chance to actually test this yet, would like to of
course see if there are any unforeseen performance or reliability
troubles.

So yes, please send an updated patch if you have time.

Tommi
