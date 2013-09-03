From: Helia Correia <helia.correia@linux.intel.com>
Subject: splice syscall runs endlessly, usage problem?
Date: Tue, 03 Sep 2013 10:48:42 +0200
Message-ID: <5225A26A.10403@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: trinity@vger.kernel.org

Hi,

I am getting to know how to use Trinity, and my last attempt was to run 
below command (on a Fedora 17 64 bits distribution):
trinity -c splice -C1 -D

My problem is that this command doesn't stop running by itself (started 
yesterday, was still running this morning so I interrupted it), and I 
don't understand why but guess this is not an expected behavior, am I 
right? What should I do to have it run normally (I mean, start and end 
up gracefully)?

Maybe I overlooked something but seems I couldn't find any documentation 
as regards to this aspect, as well as how much time it nearly takes to 
have Trinity run entirely, so any pointers would be highly appreciated.

Thank you and best regards,
Helia
