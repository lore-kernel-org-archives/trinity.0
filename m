From: Ildar Muslukhov <ildarm@google.com>
Subject: Patch suggestion - logs cleanup
Date: Wed, 2 Oct 2013 17:04:50 -0700
Message-ID: <CAEGbLtsZfQXE1Qs+5ruEsJwaSdeJ0upeoW0qnEOrAk3RRdZ6YQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=VZKQJxIjlvwamZVloBD137zGYR1ImoRLkUvEr7OX28c=;
        b=jTd5mDAqicV+UNWikI7BxRHdCX/EkjE3OxlyvzcNcPKevZqfBjudCjcGPfJw1p+2Nz
         yCRIsZO7fQhzEX2lwfgmjD6IctSLff7ZXADGJ8Aub7GGWuZZ4HiG/8VmZ7uFRfI/arcX
         4gRR9BUMik4UA9SBhIlaRs/dhHSWpMKo53sza3EDet/ZmJs1XZAZTLTvZP4kfT7Zlq2t
         nhD5/NWKM8h2s0zisSashsr2YtMIRLPodftaY9wJFqxa4zKuvMmDtee9HHQ7NY4dcGo2
         bVibrrPXweWlqY8KyKes7M7Mk7pBxK77cIeUFQSp7rCqXnFNP6Rd5FmkRs3osWcMDdp/
         izJw==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>

How about cleaning up source from all the printf and converting them
to the output? I am willing to do that, since would like to have more
control over logging and output.
