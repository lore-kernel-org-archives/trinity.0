From: David Sterba <dsterba@suse.cz>
Subject: Re: btrfs "possible irq lock inversion dependency detected"
Date: Tue, 18 Feb 2014 17:27:36 +0100
Message-ID: <20140218162736.GG16073@twin.jikos.cz>
References: <20140217200951.GB20312@optiplex>
 <4F3CC8F0-C37E-4448-AF65-796E643A301B@colorremedies.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F3CC8F0-C37E-4448-AF65-796E643A301B@colorremedies.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Murphy <lists@colorremedies.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, Dave Jones <davej@redhat.com>, trinity@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:14:34PM -0700, Chris Murphy wrote:
> Looks like this is the same thing previously report on Btrfs list with 3.14.0-rc1 here:
> https://bugzilla.redhat.com/show_bug.cgi?id=1062439
> 
> Which points to this:
> https://bugzilla.redhat.com/show_bug.cgi?id=1062833#c24
> 
> Which points to this patch:
> http://marc.info/?l=linux-netdev&m=139233546723342&q=raw

Thanks for the pointer, so it's not a btrfs bug.
