Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CC3440B
	for <trinity@vger.kernel.org>; Thu, 23 Nov 2023 02:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW07Q3W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53AEC433C8;
	Thu, 23 Nov 2023 02:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700707992;
	bh=rRbIXqjq8DKBA6vW+7glleky65j8TQodsqrm6IeWtY0=;
	h=Date:From:To:Subject:From;
	b=vW07Q3W3P+ZJiAgJjd1ldePPOH1+Yd3ZLJwfA/S1plFqlzbrbOXMt1fjBSrun2Aga
	 87qhPSmYdhUGcxGYx9kSCXvlL431gCto4KO69HlmSxeX0TiTBFlz+FAsYB/0/SD7C0
	 6C57kkoOqlfJhTkT3FiZAnwAjkLPlL9TO/2nht4Q=
Date: Wed, 22 Nov 2023 21:53:11 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: trinity@vger.kernel.org
Subject: PSA: this list has moved to new vger infra (no action required)
Message-ID: <20231122-flawless-fabulous-bullmastiff-a017f6@nitro>
Precedence: bulk
X-Mailing-List: trinity@vger.kernel.org
List-Id: <trinity.vger.kernel.org>
List-Subscribe: <mailto:trinity+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:trinity+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This list has been migrated to the new vger infrastructure. No action is
required on your part and there should be no change in how you interact with
this list.

This message acts as a verification test that the archives are properly
updating.

If something isn't working or looking right, please reach out to
helpdesk@kernel.org.

Best regards,
-K
