From: Dave Jones <davej@redhat.com>
Subject: Re: have 3 entrypoints in trinity list on CentOS 6
Date: Fri, 23 Aug 2013 16:27:17 -0400
Message-ID: <20130823202717.GA27796@redhat.com>
References: <loom.20130814T100045-787@post.gmane.org>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <loom.20130814T100045-787@post.gmane.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frank H <houf99@gmail.com>
Cc: trinity@vger.kernel.org

On Wed, Aug 14, 2013 at 08:05:55AM +0000, Frank H wrote:
 > Hi All:
 > 
 > I'm beginner for Trinity tool, it's very good. Thanks a lot.
 > 
 > When try command ./trinity -L , got some syscalls have 3 entrypoint , e.g:

This is just a cosmetic thing.  Ignoring the 64bit variants:

 > 32-bit entrypoint 28 fstatfs : Enabled
 > 32-bit entrypoint 100 fstatfs : Enabled

This is actually fstatfs & fstatfs64

 > 32-bit entrypoint 109 uname : Enabled
 > 32-bit entrypoint 122 uname : Enabled

'olduname' & 'uname'
 
 > 32-bit entrypoint 187 sendfile : Enabled
 > 32-bit entrypoint 239 sendfile : Enabled

'sendfile' & 'sendfile64'

 > 32-bit entrypoint 82 select : Enabled AVOID
 > 32-bit entrypoint 142 select : Enabled AVOID
 
'select' & 'newselect'
 
Because trinity treats all these functions the same, rather than duplicate
everything twice, we re-use the same syscall structure for both entries.

	Dave
