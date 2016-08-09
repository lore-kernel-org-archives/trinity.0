From: Li jinyue <lijinyue@huawei.com>
Subject: What's the suggestion to do trinity test?
Date: Tue, 9 Aug 2016 10:34:25 +0800
Message-ID: <57A94131.3000401@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trinity@vger.kernel.org
Cc: Zhangdianfang <zhangdianfang@huawei.com>

Hi all,
We 're using trinity to do linux syscall fuzzer test. And some problems about root test confused us. We know test under
root is dangerous and not recommended, but we do found some kernel problems under root which can't be repeated with a non-root user.
So, what's the suggestion to do a full test? Test with non-root user or attempt it under root?(Of course, it will encounter many
meaningless oops or Calltrace, and cost much time to confirm it. That's what we do not want to see.)
Look forward to your response. Thanks!

Best regards!
Realeam
lijinyue@huawei.com
