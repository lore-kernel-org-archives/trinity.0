From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH 1/7] add random_pathstring()
Date: Tue, 17 Mar 2015 10:26:07 -0400
Message-ID: <20150317142607.GA17556@codemonkey.org.uk>
References: <1426537521-54786-1-git-send-email-tyson.w.smith@gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426537521-54786-1-git-send-email-tyson.w.smith@gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tyson.w.smith@gmail.com
Cc: trinity@vger.kernel.org, tysmith@motorola.com

On Mon, Mar 16, 2015 at 01:25:21PM -0700, tyson.w.smith@gmail.com wrote:
 > From: Tyson Smith <tyson.w.smith@gmail.com>
 > 
 > This will generate a path that will likely not exist but may
 > look somewhat valid or totally crazy depending on rand.

We kinda tried this before. It stressed the negative dentry code
a little (perhaps a little too much tbh), but never really found
anything interesting, and just caused trinity to crap garbage
filenames all over the tmp dir.

Not sure it's worth trying this again. If we do, we should
make it a lot less likely to happen, like 1 in a 100 or something.


 > +	switch(rand() % 5) {

Someone recently added a handy ONE_IN macro :)

 > +	case 0:
 > +		// single repeating random ASCII character
 > +		(void) memset(path, (rand() % 95) + 32, rand() % len);
 > +		path[len-1] = '\0';
 > +		break;
 > +	case 1:
 > +		// random ASCII characters 32(space) -> 126(~)
 > +		for (i=0; i < len; i++)
 > +			path[i] = (char) ((rand() % 95) + 32);
 > +		path[len-1] = '\0';
 > +		break;
 > +	case 2:
 > +		// random . or /
 > +		for (i=0; i < len; i++)
 > +			path[i] = RAND_BOOL() ? '.' : '/';
 > +		path[len-1] = '\0';
 > +		break;
 > +	case 3:
 > +		// format strings
 > +		for (i=0; i < (len - 2); i+=2) {
 > +			path[i] = '%';
 > +			path[i+1] = fmts[rand() % 3];
 > +		}
 > +		path[len-1] = '\0';
 > +		break;
 > +	case 4:
 > +		// junk
 > +		for (i=0; i < len; i++)
 > +			path[i] = (char) RAND_BYTE();
 > +		path[len-1] = '\0';
 > +		break;
 > +	}

This should probably just be a generate_rand_bytes() call,
with enhancements to that function if necessary.

	Dave
