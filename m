From: Ildar Muslukhov <ildarm@google.com>
Subject: Reproducible run and binary logs (ideas)
Date: Wed, 18 Sep 2013 12:48:40 -0700
Message-ID: <CAEGbLtsg8_xLx9YvdrZ-gLWR4UqSQ+DT4mzEV9BfGnf-uHxDjQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <trinity-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=DSY70iUrsVeesJsra3XGGrgQrOYMRwfZimQ22IUsS3Y=;
        b=PyEdmviO4mfWV+srjHzRgSktkTJBRFlSY3nVqheic8q/PM+frr8HyPVMxeBd1YOXxV
         dJGYArzM5bujBJJ+SykOguqFazqUwUK55wCLKu4/iIsXXrTeuMtuTFk7hbOAXNl3o30l
         8gPB0BGNppdYQMY/pJeRC+qaDi0oIURaiaEoHAemOcnwhyaNh3c+sGkTRI8i3Q6W99cT
         b0XOS553kSOsZduu6z35lzSMDsD/Zoy7PLo/yc9UmwXZo5sWimRb2/tZPCWiR681cXms
         VEqFNze9vM7mz8dTGbxp+6IX/rwSy+K4NUMlJnSYQUPJRHvqVDynzTebvWmH6mnpWVVz
         8y/Q==
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trinity@vger.kernel.org

Hello everyone,

Decided to share some ideas before jumping into them and how they
align with the TODO list.

Lets just assume for now that we have something similar to sockets
cache if FDs (i.e., they are also reproducible to some extent). I am
planning to work on it rather sooner than later, but it is not crucial
for the current discussion.

Here is my thoughts:
One runs trinity either with a single child process or with multiple
child processes.
In a single child approach we don't catch cases where a race condition
occurs, however, we do catch everything else (like usual bugs, when
param's value handled incorrectly). [Q: Am I missing something here?]
Now assume that we caught a bug, how can we reproduce it? What is the
minimal set of details we need? I think, in general, we need only rand
seed. In rerun we will use that number to reseed the prng and trinity
should follow the same execution path (i.e., all the places where
rand() func is called for branching) and generate the same input
parameters. Of course, having the iteration number where kernel oopsed
would help improving the speed of replay, like a fast forward.

Although, the way it is implemented right now is a bit risky, since
the rand functions are called in place, and we cannot guarantee that
no other code (like gcc libraries) hasn't made a call to rand()
function, thus moving the rand queue forward. If such calls repeats
all the times its not a big deal, it is a problem, however, if that is
a stochastic behavior. The idea I have it to have a buffer with rand
numbers, which is filled by parent process, and in the logs we report
details about what is in the beginning of that buffer and what is in
the end. So that later, when we use "replay" function we are sure that
the same rand buffer is used. If we need several buffers, we can
always use these details in the logs to fast forward rand function if
we see that it does not match with the buffer being used according the
logs.

Now with multiple child approach. It gets even more interesting. When
we fork a child, we reseed it. This approach is very good from
simplicity point of view, but there is a small caveat to it, in
particular we do not explore every seed deep enough into its random
queue. And also, now we have to keep track of all child seeds, which
makes the replay function a bit more complicated. The idea I had is
that in the SHM struct we will have a buffer of rand numbers generated
before we fork a child, and each child uses its own buffer to be
predictable. Once the buffer is empty, parent process regenerates it.
I.e., basically avoid call to rand function from a child completely.
This makes the support of randomness uniform of whether you go with a
single child or multiple child processes.

For the replay function in multiple child processes to be more
successful it should follow the exact call sequence as it was during
original run when the bug was discovered, e.g., if child A executed
syscalls 1,2,3,4,4,4 and only then child B executed syscalls 5 and 6,
the replay has to do exactly the same. Doing it just as is, is also
OK, but in my view, such approach has less chances to reproduce race
condition types of bugs. Of course, the exact repetition of the
sequence does not guarantee us in repeating the bug, still, it should
have a bit higher chances.

Summarizing this, for multiple child processes replay we need that
"call script" which stores the sequence of syscall execution. Writing
such into a text file like logs is bad, since it will definitely
become an IO problem. Having a binary logs, like you mentioned in the
TODO seems to be the only option. Then we can add the parameter
--parselog=mylog.bin to it to rerun the exact things. Of course this
log should also store all the config params.

Another benefit of having such call script is that we can put syscall
result into it as well as an int, and then use that date to do
analysis on which syscalls fails constantly. This is inline with TODO
in terms of gathering more stats on current syscalls success/failure
rate. Having these stats might reveal syscalls that need a better call
handling (i.e., input parameter guessing and other related parts).

So that's it for now. My gut feeling is that first I should look into
rand function use, then work on FDs and then only go to bin-logs. What
do you think of it?

Thanks,
Ildar
