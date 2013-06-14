From: Hangbin Liu <liuhangbin@gmail.com>
Subject: Should we enable ip_nonlocal_bind ?
Date: Fri, 14 Jun 2013 14:06:29 +0800
Message-ID: <CAPwn2JQb8aiOiiFTFw9ahpR=5r5vBsoB-cRLsbK+C7X1Tz=njw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=c6GvR5otf95mM3iAKqUKxSrrr23YLskJjiVaXdPIz2w=;
        b=XCPlQExlvghD+F3ypwApykKblC+zUn7Ci+EqaSdilLLJHHYb1Bc1HRCvF9MswZ13vj
         c/g3nmThF0Sf9NqlCjBCMKN8pFDkiE1XXvrCYd1sZf9djXfBtH8+8IXWT5Wb7qo+1QRV
         h78nAJbSl/Zzz5L8ZaHIu/nCk5sae8vFDwffsqbRboYTfNeP1DeGjiPWJQvSLuodNRF/
         IvM+TmjmBy8gr/uED6so4cZW4C/8aa4G5rRLuMS3mDHYFLkm08yzvUGcb3sR6HoH62NY
         q7ltbCvRnGDUmfdxNVMUw2qblJ0lRy/4H5qPz0MHMQwOrzRHQY65E2IW0M5x6+2ss3D/
         Ue9Q==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hi all,

As Linux disabled ip_nonlocal_bind by default, almost all socket bind
failed cause we use random IP address. So should we enable it before
running trinity ? If yes, where could we put it , scripts or main.c ?

Thanks
Hangbin Liu
