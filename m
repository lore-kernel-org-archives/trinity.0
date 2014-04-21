From: Dave Jones <davej@redhat.com>
Subject: Re: shouldn't the Makefile be adjusted after the rename of sockets.c
 to fd-sockets.c ?
Date: Mon, 21 Apr 2014 15:25:17 -0400
Message-ID: <20140421192517.GA24924@redhat.com>
References: <53556FAA.7090101@gmx.de>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53556FAA.7090101@gmx.de>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: trinity@vger.kernel.org

No, there's a wildcard rule that picks up everything named *.c

	Dave

