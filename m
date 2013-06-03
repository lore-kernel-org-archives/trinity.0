From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH trinity v2, RFT] trinity: use Boehm-Demers-Weiser's garbage
 collecting memory allocator
Date: Mon, 03 Jun 2013 13:54:07 +0200
Message-ID: <51AC83DF.5020203@redhat.com>
References: <1369564593-18728-1-git-send-email-dborkman@redhat.com> <CA+ydwtrZKC+8UQA0gw_Qp9PffUT5wrzr3e+qnQnfyFc78zEKKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
In-Reply-To: <CA+ydwtrZKC+8UQA0gw_Qp9PffUT5wrzr3e+qnQnfyFc78zEKKQ@mail.gmail.com>
Sender: trinity-owner@vger.kernel.org
List-ID: <trinity.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Dave Jones <davej@redhat.com>, trinity@vger.kernel.org

On 06/03/2013 08:25 AM, Tommi Rantala wrote:
> 2013/5/26 Daniel Borkmann <dborkman@redhat.com>:
>> diff --git a/devices.c b/devices.c
>> index 0493c39..2e115f8 100644
>> --- a/devices.c
>> +++ b/devices.c
>> @@ -8,6 +8,7 @@
>>   #include <sys/types.h>
>>   #include <linux/kdev_t.h>
>>
>> +#include "trinity.h"
>>   #include "log.h"
>>
>>   static struct {
>> @@ -37,9 +38,9 @@ static void parse_proc_devices(void)
>>                          block = 1;
>>                  else if (sscanf(line, "%d %as", &major, &name) == 2) {
>>                          if (block) {
>> -                               new = realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
>> +                               new = bdw_realloc(block_devs, (bldevs+1)*sizeof(*block_devs));
>>                                  if (!new) {
>> -                                       free(name);
>> +                                       bdw_free(name);
>>                                          continue;
>>                                  }
>>                                  block_devs = new;
>> @@ -48,9 +49,9 @@ static void parse_proc_devices(void)
>>                                  block_devs[bldevs].name = name;
>>                                  bldevs++;
>>                          } else {
>> -                               new = realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
>> +                               new = bdw_realloc(char_devs, (chrdevs+1)*sizeof(*char_devs));
>>                                  if (!new) {
>> -                                       free(name);
>> +                                       bdw_free(name);
>>                                          continue;
>>                                  }
>>                                  char_devs = new;
>> @@ -63,7 +64,7 @@ static void parse_proc_devices(void)
>>          }
>>
>>          fclose(fp);
>> -       free(line);
>> +       bdw_free(line);
>>   }
>
> 'line' is allocated implicitly by getline(), is it safe to bdw_free() it?

True, thanks for catching! Not sure if we want to proceed with this patch or put it
on hold for now? Let me know, if wished, I could send an update.
