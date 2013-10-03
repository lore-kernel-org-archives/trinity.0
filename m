From: Dave Jones <davej@redhat.com>
Subject: Re: Patch suggestion - logs cleanup
Date: Wed, 2 Oct 2013 20:11:57 -0400
Message-ID: <20131003001157.GA17386@redhat.com>
References: <CAEGbLtsZfQXE1Qs+5ruEsJwaSdeJ0upeoW0qnEOrAk3RRdZ6YQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEGbLtsZfQXE1Qs+5ruEsJwaSdeJ0upeoW0qnEOrAk3RRdZ6YQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Wed, Oct 02, 2013 at 05:04:50PM -0700, Ildar Muslukhov wrote:
 > How about cleaning up source from all the printf and converting them
 > to the output? I am willing to do that, since would like to have more
 > control over logging and output.

yeah, worth doing. Careful though, some of the printf's happen before we've opened
the log files.

Sort of related: At some point I think debugf needs to log to a separate debug log file.

	Dave
