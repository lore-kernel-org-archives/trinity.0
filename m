From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 5/6] added bufferless logging functions for syscall
 pamaters
Date: Wed, 9 Oct 2013 12:27:25 -0400
Message-ID: <20131009162725.GB2821@redhat.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
 <1381267615-9826-5-git-send-email-ildarm@google.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381267615-9826-5-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

On Tue, Oct 08, 2013 at 02:26:54PM -0700, Ildar Muslukhov wrote:

 > +static void output_arg(unsigned int call, unsigned int argnum, const char *name, unsigned long oldreg, unsigned long reg, int type, FILE *fd, bool mono)
 > +{
 > +}
 > +

uh, what ?
 
 > +
 > +static void output_syscall_prefix_to_fd(const unsigned int childno, const pid_t pid, const unsigned int syscallno, FILE *fd, bool mono)
 > +{
 > +	fprintf(fd, "[child%d:%d] [%ld] %s", childno, pid, shm->child_syscall_count[childno],
 > +			(shm->do32bit[childno] == TRUE) ? "[32BIT] " : "");
 > +
 > +	if (syscallno > max_nr_syscalls)
 > +		fprintf(fd, "%u", syscallno);
 > +	else
 > +		fprintf(fd, "%s", syscalls[syscallno].entry->name);
 > +
 > +	CRESETFD
 > +	fprintf(fd, "(");
 > +	output_arg(syscallno, 1, syscalls[syscallno].entry->arg1name, shm->previous_a1[childno], shm->a1[childno],
 > +			syscalls[syscallno].entry->arg1type, fd, mono);
 > +	output_arg(syscallno, 2, syscalls[syscallno].entry->arg2name, shm->previous_a2[childno], shm->a2[childno],
 > +			syscalls[syscallno].entry->arg2type, fd, mono);
 > +	output_arg(syscallno, 3, syscalls[syscallno].entry->arg3name, shm->previous_a3[childno], shm->a3[childno],
 > +			syscalls[syscallno].entry->arg3type, fd, mono);
 > +	output_arg(syscallno, 4, syscalls[syscallno].entry->arg4name, shm->previous_a4[childno], shm->a4[childno],
 > +			syscalls[syscallno].entry->arg4type, fd, mono);
 > +	output_arg(syscallno, 5, syscalls[syscallno].entry->arg5name, shm->previous_a5[childno], shm->a5[childno],
 > +			syscalls[syscallno].entry->arg5type, fd, mono);
 > +	output_arg(syscallno, 6, syscalls[syscallno].entry->arg6name, shm->previous_a6[childno], shm->a6[childno],
 > +			syscalls[syscallno].entry->arg6type, fd, mono);
 > +	CRESETFD
 > +	fprintf(fd, ") ");
 > +}


	Dave
