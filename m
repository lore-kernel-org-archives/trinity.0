From: Dan =?UTF-8?B?SG9yw6Fr?= <dan@danny.cz>
Subject: Re: [PATCH] load correct syscall table for s390 and s390x
Date: Sat, 1 Feb 2014 11:49:20 +0100
Message-ID: <20140201114920.540e582351769a861a96b630@danny.cz>
References: <1391249524-5384-1-git-send-email-dan@danny.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <1391249524-5384-1-git-send-email-dan@danny.cz>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: trinity@vger.kernel.org

On Sat,  1 Feb 2014 11:12:04 +0100
Dan Hor=C3=A1k <dan@danny.cz> wrote:

> The actual syscall table for s390/s390x must be loaded depending on
> the __s390x__ symbol.

a successful scratch build in Fedora with the patch applied
http://s390.koji.fedoraproject.org/koji/taskinfo?taskID=3D1346283


		Dan
