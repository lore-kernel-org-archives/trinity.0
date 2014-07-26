From: Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH] net: add ipv4/ipv6 sctp support
Date: Sat, 26 Jul 2014 10:51:14 +0800
Message-ID: <CAPwn2JSbfzzU+wGmQvFeE8P6QJdGSnExqvChGtyAjSRgbsxB6Q@mail.gmail.com>
References: <1406262349-22533-1-git-send-email-liuhangbin@gmail.com>
	<53D22DBF.20701@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=O/gOCeRVNyNPxwQLhL3dYlB8XwcM89kgk2FIYdfEtGc=;
        b=UaWDN+NpPMlQoJTxiMJHtyuO9WlwXPGjYGdfcnR/nluMtHiDN1PHlN+YRP6MEpmpoF
         rwqG8Z2g0rO19vMHCVpwNmxGqeIQQw0KKKTckcBDV+s2YPyAhzx0ChtUchXWPQZNWD2i
         QlLGAV7Moy6VmPl8q6UamzNCQl8jy6TGALNbxYg5VOynrDMkQLfKoOOZWvwvAhxdPzg5
         nH+ucNFwuE84HROelAWTIKdsZied1VBtZMPF453pMpOCjJT+EoLX1o/WO6KdAyjnGjph
         nilFjsfHLcWCYTZg/2MZ958CWatLHOzN53GkxiprX7K8leY7SgRUu8IhgDmYAWnkBcUG
         QuEw==
In-Reply-To: <53D22DBF.20701@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Trinity <trinity@vger.kernel.org>

2014-07-25 18:13 GMT+08:00 Daniel Borkmann <dborkman@redhat.com>:
> Hi Hangbin,
>
>
> On 07/25/2014 06:25 AM, Hangbin Liu wrote:
>>
>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>> ---
>>   net/proto-ipv4.c | 20 ++++++++++++++------
>>   net/proto-ipv6.c | 21 ++++++++++++++++-----
>>   2 files changed, 30 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
>> index 8babe6d..5588518 100644
>> --- a/net/proto-ipv4.c
>> +++ b/net/proto-ipv4.c
>> @@ -97,22 +97,30 @@ void ipv4_gen_sockaddr(struct sockaddr **addr,
>> socklen_t *addrlen)
>>
>>   void inet_rand_socket(struct socket_triplet *st)
>>   {
>> -       switch (rand() % 3) {
>> -       case 0: st->type = SOCK_STREAM;     // TCP
>> +       switch (rand() % 4) {
>> +       case 0: st->type = SOCK_STREAM;     // TCP/SCTP
>> +               switch (rand() % 3) {
>> +               case 0: st->protocol = 0; break;
>> +               case 1: st->protocol = IPPROTO_TCP; break;
>> +               case 2: st->protocol = IPPROTO_SCTP; break;
>> +               default:break;
>> +               }
>
>
> I think it would be good for readability reasons to use
> the kernel coding style convention, but I'm not sure what
> Dave's preference is as the style is also present elsewhere.

I'm OK to change the code style, wait for Dave's response.

Thanks
Hangbin Liu
