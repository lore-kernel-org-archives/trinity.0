From: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [uml-devel] WARNING: at mm/mmap.c:2757 exit_mmap+0x161/0x170()
Date: Fri, 17 May 2013 14:22:28 +0200
Message-ID: <CAFLxGvxkOH91Ne59vzahDLkphBno2GYntsPf5DBAj7CeCjTivA@mail.gmail.com>
References: <518FB97A.5070907@gmx.de>
	<CAFLxGvzn+Q=D4vjTNuggSTnQKVp0QYLPoHmUwAVBcRbSmD3HWQ@mail.gmail.com>
	<518FBE6A.50605@gmx.de>
	<CAFLxGvyvRb+WD-eLBFnH5O-sXjUdtUkXbKzG6HFqgzm+x2LUow@mail.gmail.com>
	<CAFLxGvwEiE0dfw9Vju_Xg6mXkF_NH_OU_t7puPceYN42dphTLA@mail.gmail.com>
	<518FE33B.60701@gmx.de>
	<CAFLxGvyiKbbkPAG0h42y1fb=Z6YuboJPdyb+2Xk9Z2YYt7oryg@mail.gmail.com>
	<518FF354.7020408@gmx.de>
	<CAFLxGvxYjpt6X9MQF3Huh-Sqzm3CBMJAfGb_Qjpqu00iUzj=qg@mail.gmail.com>
	<518FFBA3.6000800@gmx.de>
	<CAFLxGvx+8wpBeF_TqOk3JKBEoADAS-NeatpJMuSVvaDhZNqE0g@mail.gmail.com>
	<CAFLxGvzSEY8iciEONkxNGeO6Lt5v4VcB2sF1XPcqLA=n8PUaAQ@mail.gmail.com>
	<51901400.4060302@gmx.de>
	<CAFLxGvx-saWcJ+JCubUBAVT70OSMZDYNETqiNijJgXeqCPwwUA@mail.gmail.com>
	<5193DCA7.1070708@gmx.de>
	<CAFLxGvxhDu6jVHZ0iOhjSBEfEY5JZRJ9xw0gxcduvuTR6BGOPg@mail.gmail.com>
	<5193E26E.90003@gmx.de>
	<CAFLxGvyggXx0grnef3RNPbyDq0scNjDJQ_h0=aRdbe_Aa-p-gQ@mail.gmail.com>
	<CAFLxGvz4Ru-TKb34_WE-EC7Z8SenR3HcrDfbpNeO1oOROpzk=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f46d040fa27454bc5604dce909ab
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=qOrrg+PHaRlHe0AvrzFCS4goOOo88aqwzNpCZvw3d3g=;
        b=Ga8eh5Z5PxUl1UfLH8WYIFRGEpXJUzjXmiPl09W2J5yILCi3B6nfWj4tcwobOshLtc
         3TE+61y4VYNEC3AeLWokkkqxWp0YetVPLvtREz92nSY0ZxDlmqBpzRGCOm+O8L5j7SYt
         3G6cjZ9/O0N17ZZ3KnPiU2tNWIHuDRr4Wh+HBgEfVRJW/62ZPTI6h79AqhIlC/IXyW0Z
         26ejx6Y7PN1197SlSvjBeu3XgYA6SSMYB1+1KPWOvmRXtOBixFUjZsrxJgnYaXKAst2Y
         4PXp9DLHEkfJLv6N9nhUygAVZrxVRkNale20xHhVrtv7yeq/EWFk2pbtDxgWFinLT2q3
         HOyw==
In-Reply-To: <CAFLxGvz4Ru-TKb34_WE-EC7Z8SenR3HcrDfbpNeO1oOROpzk=A@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: "user-mode-linux-devel@lists.sourceforge.net" <user-mode-linux-devel@lists.sourceforge.net>, trinity@vger.kernel.org

--f46d040fa27454bc5604dce909ab
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2013 at 12:00 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Wed, May 15, 2013 at 9:35 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Wed, May 15, 2013 at 9:30 PM, Toralf F=F6rster <toralf.foerster@gmx.d=
e> wrote:
>>> On 05/15/2013 09:11 PM, richard -rw- weinberger wrote:
>>>> On Wed, May 15, 2013 at 9:06 PM, Toralf F=F6rster <toralf.foerster@gmx=
.de> wrote:
>>>>> On 05/13/2013 09:12 AM, richard -rw- weinberger wrote:
>>>>>> This looks like another issue.
>>>>>> Are you testing process_vm_writev() with trinity?
>>>>>> Looks like it managed to overwrite the stub page of a process, which
>>>>>> is not good.
>>>>> nope, it is the mremap syscall.
>>>>>
>>>>> A command like
>>>>>
>>>>> $>trinity -c mremap -N 10
>>>>>
>>>>> immediately after starting a 32 bit Gentoo linux guest with current k=
ernel 3.10-rc1-... +
>>>>> strnlen + stub4 patch works, but later a
>>>>>
>>>>> $>trinity -c mremap -N 1000
>>>>>
>>>>> yields into
>>>>>
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel: Stub registers -
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   0 - 100000
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   1 - 300000
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   2 - 0
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   3 - 0
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   4 - 0
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   5 - 0
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   6 - 0
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   7 - 7b
>>>>> 2013-05-15T21:02:04.061+02:00 trinity kernel:   8 - 7b
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   9 - 0
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   10 - 33
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   11 - ffffffff
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   12 - 1000c3
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   13 - 73
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   14 - 10206
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   15 - 101028
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel:   16 - 7b
>>>>> 2013-05-15T21:02:04.065+02:00 trinity kernel: wait_stub_done : failed=
 to wait for SIGTRAP, pid =3D 15692, n =3D 15692, errno =3D 0, status =3D 0=
xb7f
>>>>>
>>>>> and now that process can't be killed - I had to stop the UML guest.
>>>>
>>>> Hmm, you've remapped the stub page and therefore the process broke.
>>>> I think it would make sense to kill the process in stead of writing
>>>> the "wait_stub_done ..." message.
>>>> Changing the stub page is as destructive than overwriting the stack.
>>>
>>> Unfortunately no trinity process can be killed as soon as that happen.
>>> Neither pgrep, pkill, nor "ps -efla" do return any result.
>>> Killing any of those processes by its pid won't work too.
>>
>> Hmm, not good.
>> I need to create me a reproducer for that.
>> I'm unsure what exactly is going on.
>
> Good news, I have a reproducer for the problem and found out what the
> root cause is.
> UML is unable to terminate the task with the broken skas page.
> A fix is on the way...

Toralf, can you please append the attached patch too?
It makes processes killable which corrupted their stub pages.

--
Thanks,
//richard

--f46d040fa27454bc5604dce909ab
Content-Type: application/octet-stream; name="wait_stub_done_fix.diff"
Content-Disposition: attachment; filename="wait_stub_done_fix.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgtc7ov60

ZGlmZiAtLWdpdCBhL2FyY2gvdW0vb3MtTGludXgvc2thcy9wcm9jZXNzLmMgYi9hcmNoL3VtL29z
LUxpbnV4L3NrYXMvcHJvY2Vzcy5jCmluZGV4IDQ2MjU5NDkuLjQ0MWU0YmEgMTAwNjQ0Ci0tLSBh
L2FyY2gvdW0vb3MtTGludXgvc2thcy9wcm9jZXNzLmMKKysrIGIvYXJjaC91bS9vcy1MaW51eC9z
a2FzL3Byb2Nlc3MuYwpAQCAtNTQsNyArNTQsNyBAQCBzdGF0aWMgaW50IHB0cmFjZV9kdW1wX3Jl
Z3MoaW50IHBpZCkKIAogdm9pZCB3YWl0X3N0dWJfZG9uZShpbnQgcGlkKQogewotCWludCBuLCBz
dGF0dXMsIGVycjsKKwlpbnQgbiwgc3RhdHVzLCBlcnIsIGJhZF9zdG9wID0gMDsKIAogCXdoaWxl
ICgxKSB7CiAJCUNBVENIX0VJTlRSKG4gPSB3YWl0cGlkKHBpZCwgJnN0YXR1cywgV1VOVFJBQ0VE
IHwgX19XQUxMKSk7CkBAIC03NCw2ICs3NCw4IEBAIHZvaWQgd2FpdF9zdHViX2RvbmUoaW50IHBp
ZCkKIAogCWlmICgoKDEgPDwgV1NUT1BTSUcoc3RhdHVzKSkgJiBTVFVCX0RPTkVfTUFTSykgIT0g
MCkKIAkJcmV0dXJuOworCWVsc2UKKwkJYmFkX3N0b3AgPSAxOwogCiBiYWRfd2FpdDoKIAllcnIg
PSBwdHJhY2VfZHVtcF9yZWdzKHBpZCk7CkBAIC04Myw3ICs4NSwxMCBAQCBiYWRfd2FpdDoKIAlw
cmludGsoVU1fS0VSTl9FUlIgIndhaXRfc3R1Yl9kb25lIDogZmFpbGVkIHRvIHdhaXQgZm9yIFNJ
R1RSQVAsICIKIAkgICAgICAgInBpZCA9ICVkLCBuID0gJWQsIGVycm5vID0gJWQsIHN0YXR1cyA9
IDB4JXhcbiIsIHBpZCwgbiwgZXJybm8sCiAJICAgICAgIHN0YXR1cyk7Ci0JZmF0YWxfc2lnc2Vn
digpOworCWlmIChiYWRfc3RvcCkKKwkJa2lsbChwaWQsIFNJR0tJTEwpOworCWVsc2UKKwkJZmF0
YWxfc2lnc2VndigpOwogfQogCiBleHRlcm4gdW5zaWduZWQgbG9uZyBjdXJyZW50X3N0dWJfc3Rh
Y2sodm9pZCk7Cg==
--f46d040fa27454bc5604dce909ab--
