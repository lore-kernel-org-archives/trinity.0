From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v2] Fix 2.6.32 compiler errors
Date: Thu, 28 Mar 2013 18:32:42 -0400
Message-ID: <20130328223242.GA22490@redhat.com>
References: <515347F6.2080502@hp.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <515347F6.2080502@hp.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Brian Haley <brian.haley@hp.com>
Cc: trinity@vger.kernel.org

On Wed, Mar 27, 2013 at 03:26:46PM -0400, Brian Haley wrote:
 
 >  /* would use this, but the header uses DECLARE_BITMAP() from the kernel */
 >  /* #include <sound/emu10k1.h> */
 > @@ -205,6 +207,7 @@ static const struct ioctl sound_ioctls[] = {
 >  	{ .name = "SNDRV_EMU10K1_IOCTL_SINGLE_STEP", .request =
 > _IOC(_IOC_NONE,'H',0x83,0), },
 >  	{ .name = "SNDRV_EMU10K1_IOCTL_DBG_READ", .request =
 > _IOC(_IOC_NONE,'H',0x84,0), },

Word-wrapped.


 > diff --git a/syscalls/inotify_add_watch.c b/syscalls/inotify_add_watch.c
 > index 9c69fc7..35fb593 100644
 > --- a/syscalls/inotify_add_watch.c
 > +++ b/syscalls/inotify_add_watch.c
 > @@ -34,7 +34,9 @@ struct syscall syscall_inotify_add_watch = {
 >  			IN_IGNORED,
 >  			IN_ONLYDIR,
 >  			IN_DONT_FOLLOW,
 > +#ifdef IN_EXCL_UNLINK
 >  			IN_EXCL_UNLINK,
 > +#endif
 >  			IN_MASK_ADD,
 >  			IN_ISDIR,
 >  			IN_ONESHOT,

You can't do this, because the .num will be incorrect.
Add a dummy define to compat.h for it instead.

	Dave

