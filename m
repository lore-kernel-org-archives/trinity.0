From: Dave Jones <davej@redhat.com>
Subject: Re: exporting pmu data from perf_event_open.c
Date: Wed, 14 May 2014 11:43:26 -0400
Message-ID: <20140514154326.GA16439@redhat.com>
References: <alpine.DEB.2.10.1405131441100.24957@vincent-weaver-1.umelst.maine.edu>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405131441100.24957@vincent-weaver-1.umelst.maine.edu>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: trinity@vger.kernel.org

On Tue, May 13, 2014 at 02:51:35PM -0400, Vince Weaver wrote:
 
 > I just finished syncing perf_fuzzer against the Trinity 1.4 codebase.
 > 
 > It was a bit of a pain, but I guess still worth doing in order to
 > keep perf_event_open.c shared.
 > 
 > I was wondering if you'd consider a patch like the following.
 > It exports the perf_event_open() pmus structure, that way perf_fuzzer can 
 > pretty-print the pmu names.  It would save a lot of code duplication.

Sure, if it saves you work why not..

applied, with a munged changelog to change tenses :)

	Dave
