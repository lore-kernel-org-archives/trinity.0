From: Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [patch] perf_event_open enable sysfs exported events
Date: Wed, 19 Jun 2013 15:29:42 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1306191519560.28737@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306110026180.26761@vincent-weaver-1.um.maine.edu> <CA+ydwtr7eTOjtzWumr998TcxqhmX_M30aW99S=DF6mOwNURL=w@mail.gmail.com> <alpine.DEB.2.10.1306131555210.24106@vincent-weaver-1.um.maine.edu> <20130619152722.GA22109@redhat.com>
 <alpine.DEB.2.10.1306191232170.27743@vincent-weaver-1.um.maine.edu> <20130619163841.GA22483@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <20130619163841.GA22483@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>, trinity@vger.kernel.org

On Wed, 19 Jun 2013, Dave Jones wrote:

>  > > I'm puzzled why I'm seeing opendir() fail with -ENOMEM when there's gigabytes
>  > > of free memory available.  Likewise, getting -EAGAIN seems.. weird.

OK, I've been able to reproduce this but having trouble explaining what I 
see.  

(as a side-note, should gdb work with trinity?  I couldn't
get breakpoints to work, in the end I had to add a long sleep in 
init_pmus() and then attach by pid)

So init_pmus() does this:

  dir=opendir("/sys/bus/event_source/devices");

Which glibc converts to something like this:

  fd = openat_not_cancel_3 (dfd, name, flags);
  DIR *dirp = (DIR *) malloc (sizeof (DIR) + allocation);

Where "sizeof (DIR) + allocation" appears to be 32,808 bytes.

When this works, you get an strace output like this:

openat(AT_FDCWD, "/sys/bus/event_source/devices", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 3
getdents(3, /* 6 entries */, 32768)     = 168
...


But in the failure case you get this, where the malloc() starts trying to 
allocate hundreds of megabytes or RAM and fails?

openat(AT_FDCWD, "/sys/bus/event_source/devices", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 658
brk(0x1a7c000)              = 0x1a54000
mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 67108864, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 67108864, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
brk(0x1a76000)              = 0x1a54000
mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 67108864, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
mmap(NULL, 67108864, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0) = -1 EAGAIN (Resource temporarily unavailable)
close(658)                  = 0
write(2, "Unable to opendir /sys/bus/event"..., 83Unable to opendir /sys/bus/event_source/devices : Resource temporarily unavailable) = 83


Weird.  Should I try to track this down more, or is this something 
expected to happen when malloc() is involved?

It's tricky to debug because the malloc() runs fine from inside of gdb.

Also I'm noticing that I might need some locking around the init_pmus() 
call as there's a chance the trinity children might try to call into it at 
the same time.

Vince
