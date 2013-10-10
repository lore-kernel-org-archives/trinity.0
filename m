From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 3/6] refactored output function
Date: Thu, 10 Oct 2013 14:20:37 -0400
Message-ID: <20131010182037.GA7939@redhat.com>
References: <1381267615-9826-1-git-send-email-ildarm@google.com>
 <1381267615-9826-3-git-send-email-ildarm@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381267615-9826-3-git-send-email-ildarm@google.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
content-type: text/plain
To: Ildar Muslukhov <ildarm@google.com>
Cc: trinity@vger.kernel.org

Since applying this patch, coverity is picking up an out of bounds write.
It looks like it can't happen, but I'm wondering why this code was
done this way..

hand-editted diff for clarity:

 >  	/* copy buffer, sans ANSI codes */
 >  	len = strlen(outputbuf);
 > -	for (i = 0, j = 0; i < len; i++) {
 > +	for (i = 0, j = 0; (i < len) && (i + 2 < BUFSIZE) && (j < BUFSIZE); i++) {
 >  		if (outputbuf[i] == '') {
 >  			if (outputbuf[i + 2] == '1')
 >  				i += 6;	// ANSI_COLOUR
 >  			else
 >  				i += 3;	// ANSI_RESET
 >  		} else {
 >  			monobuf[j] = outputbuf[i];
 >  			j++;
 >    		}
 >  	}
 >  	monobuf[j] = '\0';

What's the intent behind this ?
It seems redundant, as everything seems to work fine without this change.

	Dave
