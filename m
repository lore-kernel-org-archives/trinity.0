From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH v2] net: add inet/inet6 rand_socket sctp support
Date: Fri, 01 Aug 2014 11:39:28 +0200
Message-ID: <53DB6050.1080203@redhat.com>
References: <1406858234-25290-1-git-send-email-liuhangbin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1406858234-25290-1-git-send-email-liuhangbin@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hangbin Liu <liuhangbin@gmail.com>
Cc: Trinity <trinity@vger.kernel.org>, davej@redhat.com

On 08/01/2014 03:57 AM, Hangbin Liu wrote:
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Daniel Borkmann <dborkman@redhat.com>

Thanks!

> ---
>   net/proto-ipv4.c | 30 +++++++++++++++++++++++-------
>   net/proto-ipv6.c | 31 +++++++++++++++++++++++++------
>   2 files changed, 48 insertions(+), 13 deletions(-)
>
> diff --git a/net/proto-ipv4.c b/net/proto-ipv4.c
> index 8babe6d..3e24b54 100644
> --- a/net/proto-ipv4.c
> +++ b/net/proto-ipv4.c
> @@ -97,13 +97,21 @@ void ipv4_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
>
>   void inet_rand_socket(struct socket_triplet *st)
>   {
> -	switch (rand() % 3) {
> -	case 0: st->type = SOCK_STREAM;     // TCP
> -		if (rand_bool())
> +	switch (rand() % 4) {
> +	case 0: st->type = SOCK_STREAM;     // TCP/SCTP
> +		switch (rand() % 3) {
> +		case 0:
>   			st->protocol = 0;
> -		else
> +			break;
> +		case 1:
>   			st->protocol = IPPROTO_TCP;
> -		break;
> +			break;
> +		case 2:
> +			st->protocol = IPPROTO_SCTP;
> +			break;
> +		default:
> +			break;
> +		}
>
>   	case 1: st->type = SOCK_DGRAM;      // UDP
>   		if (rand_bool())
> @@ -112,11 +120,19 @@ void inet_rand_socket(struct socket_triplet *st)
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
> -	default:break;
> +	default:
> +		break;
>   	}
>   }
>
> diff --git a/net/proto-ipv6.c b/net/proto-ipv6.c
> index 16bceb3..02bb373 100644
> --- a/net/proto-ipv6.c
> +++ b/net/proto-ipv6.c
> @@ -29,10 +29,21 @@ void ipv6_gen_sockaddr(struct sockaddr **addr, socklen_t *addrlen)
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
> +		case 0:
> +			st->protocol = 0;
> +			break;
> +		case 1:
> +			st->protocol = IPPROTO_TCP;
> +			break;
> +		case 2:
> +			st->protocol = IPPROTO_SCTP;
> +			break;
> +		default:
> +			break;
> +		}
>
>   	case 1: st->type = SOCK_DGRAM;      // UDP
>   		if (rand_bool())
> @@ -41,11 +52,19 @@ void inet6_rand_socket(struct socket_triplet *st)
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
> -	default:break;
> +	default:
> +		break;
>   	}
>   }
>
>
