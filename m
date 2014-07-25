From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] net: add ipv4/ipv6 sctp support
Date: Fri, 25 Jul 2014 12:13:19 +0200
Message-ID: <53D22DBF.20701@redhat.com>
References: <1406262349-22533-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1406262349-22533-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Trinity <trinity@vger.kernel.org>

Hi Hangbin,

On 07/25/2014 06:25 AM, Hangbin Liu wrote:
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   net/proto-ipv4.c | 20 ++++++++++++++------
>   net/proto-ipv6.c | 21 ++++++++++++++++-----
>   2 files changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
> index 8babe6d..5588518 100644
> --- a/net/proto-ipv4.c
> +++ b/net/proto-ipv4.c
> @@ -97,22 +97,30 @@ void ipv4_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
>
>   void inet_rand_socket(struct socket_triplet *st)
>   {
> -	switch (rand() % 3) {
> -	case 0: st->type = SOCK_STREAM;     // TCP
> +	switch (rand() % 4) {
> +	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
> +		switch (rand() % 3) {
> +		case 0: st->protocol = 0; break;
> +		case 1: st->protocol = IPPROTO_TCP; break;
> +		case 2: st->protocol = IPPROTO_SCTP; break;
> +		default:break;
> +		}

I think it would be good for readability reasons to use
the kernel coding style convention, but I'm not sure what
Dave's preference is as the style is also present elsewhere.

Other than that, the patch looks good to me, thanks a lot
Hangbin!

Daniel

> +	case 1: st->type = SOCK_DGRAM;      // UDP
>   		if (rand_bool())
>   			st->protocol = 0;
>   		else
> -			st->protocol = IPPROTO_TCP;
> +			st->protocol = IPPROTO_UDP;
>   		break;
>
> -	case 1: st->type = SOCK_DGRAM;      // UDP
> +	case 2: st->type = SOCK_SEQPACKET;      // SCTP
>   		if (rand_bool())
>   			st->protocol = 0;
>   		else
> -			st->protocol = IPPROTO_UDP;
> +			st->protocol = IPPROTO_SCTP;
>   		break;
>
> -	case 2: st->type = SOCK_RAW;
> +	case 3: st->type = SOCK_RAW;
>   		st->protocol = rand() % PROTO_MAX;
>   		break;
>
> diff --git a/net/proto-ipv6.c b/net/proto-ipv6.c
> index 16bceb3..d094939 100644
> --- a/net/proto-ipv6.c
> +++ b/net/proto-ipv6.c
> @@ -29,10 +29,14 @@ void ipv6_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
>
>   void inet6_rand_socket(struct socket_triplet *st)
>   {
> -	switch (rand() % 3) {
> -	case 0: st->type = SOCK_STREAM;     // TCP
> -		st->protocol = 0;
> -		break;
> +	switch (rand() % 4) {
> +	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
> +		switch (rand() % 3) {
> +		case 0: st->protocol = 0; break;
> +		case 1: st->protocol = IPPROTO_TCP; break;
> +		case 2: st->protocol = IPPROTO_SCTP; break;
> +		default:break;
> +		}
>
>   	case 1: st->type = SOCK_DGRAM;      // UDP
>   		if (rand_bool())
> @@ -41,7 +45,14 @@ void inet6_rand_socket(struct socket_triplet *st)
>   			st->protocol = IPPROTO_UDP;
>   		break;
>
> -	case 2: st->type = SOCK_RAW;
> +	case 2: st->type = SOCK_SEQPACKET;      // SCTP
> +		if (rand_bool())
> +			st->protocol = 0;
> +		else
> +			st->protocol = IPPROTO_SCTP;
> +		break;
> +
> +	case 3: st->type = SOCK_RAW;
>   		st->protocol = rand() % PROTO_MAX;
>   		break;
>
>
