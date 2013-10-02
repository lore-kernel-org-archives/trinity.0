From: Ildar Muslukhov <ildarm@google.com>
Subject: Re: [PATCH] Fix syscall32 to supply 6th arg to syscal
Date: Wed, 2 Oct 2013 13:53:15 -0700
Message-ID: <CAEGbLtsSsEVwThAf677d3-DGjUMpSqQNVGmyyzJP5Fidiui8=g@mail.gmail.com>
References: <alpine.DEB.2.02.1309191420270.12168@ildarm-linux.kir.corp.google.com>
	<20131002151244.GA10872@redhat.com>
	<CAEGbLtv4wtaRuTVDPxpQcg0WWv2jDaa59vpX5MHTWe=gz-zBoQ@mail.gmail.com>
	<20131002164337.GA17276@redhat.com>
	<CAEGbLtuTi3BZffyGLahgGDVp2YhqWMPwY6VLUOBdnfnVzZDeQQ@mail.gmail.com>
	<20131002181537.GA30862@redhat.com>
	<CAEGbLttVfFEc0-LNGPYfFthQwx7j5ME38R8a4uCGa8NNWaxueQ@mail.gmail.com>
	<20131002204830.GA7803@redhat.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Yjy0jk9YaRFuPGy/E6RbDlAIpT0xhX3llS9ligTgjg8=;
        b=BSPp/Z+2huEJoLwYPHsEFF7EWt5sVT3y9aHRVjBp64hDcLAa21iztpaHa0HaaMSJmA
         0l4yIMCyXgh5l8gAytNrjelVdEEdAVUmDXgq3pYnu7HS8lKUxzg5DGN/UPaGNGtBvOoT
         Pa5Nvk9lKfjf0gNotjNQPdCe67t/8H9YAYzSHdlGSGTyORaCohekdxA3dRoyGUFjL6Fz
         FcW2Rzfsc0dY2fo0/5ucosDK1dFRgWyjDXWw/t9wES5+7d2wYq78/l1RqHOadzVJ+CDO
         ysir5/kYw8yKG8aMl1zdxoUdan533fbx6rUVyGQy9W7aRjxn65icD2zg5rpz91b74Zf9
         F9dg==
In-Reply-To: <20131002204830.GA7803@redhat.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Jones <davej@redhat.com>
Cc: trinity@vger.kernel.org

Got it. I wonder, what are the settings you running the trinity
yourself? Are you fuzzing all calls at the same time, or you limit
your self to a set or one function at a time?
