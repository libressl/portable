/*
 * Copyright (c) 2025 Kazuo Kuroi (kazuo@irixnet.org)
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *
 * getentropy_irix.c --  getentropy function for IRIX 6.5 and up. 
 * 
 */ 


#include <sys/types.h>                                                                                       
#include <sys/stat.h>                                                                                        
#include <sys/time.h>          
#include <sys/utsname.h>                                                                                     
#include <sys/sysmp.h>                     
#include <sys/syssgi.h>
#include <unistd.h>
#include <fcntl.h>     
#include <errno.h>
#include <string.h>
#include <stdlib.h>              
#include <time.h>
#include <stdio.h>

int
getentropy(void *buf, size_t len)
{
    int fd;
    ssize_t ret;
    size_t i = 0;
    int save_errno = errno;

    /* Primary: use /dev/urandom */
    fd = open("/dev/urandom", O_RDONLY);
    if (fd != -1) {
        while (i < len) {
            ret = read(fd, (char *)buf + i, len - i);
            if (ret <= 0) {
                if (errno == EINTR) continue;
                break;
            }
            i += ret;
        }
        close(fd);
        if (i == len) {
            errno = save_errno;
            return 0;
        }
    }

    /* Fallback: hacky entropy in case urandom/random isn't available */
    struct timeval tv;
    struct utsname un;
    pid_t pid = getpid(), ppid = getppid();
    uid_t uid = getuid(), gid = getgid();
    long nprocs = sysmp(MP_NPROCS);
    unsigned long tsc = 0;

    uname(&un);
    gettimeofday(&tv, NULL);

    unsigned char *p = buf;
    size_t minlen = len < sizeof(tv) + sizeof(pid) + sizeof(tsc) + sizeof(uid) ? len : sizeof(tv) + sizeof(pid) + sizeof(tsc) + sizeof(uid);
    unsigned char mix[256];
    memset(mix, 0, sizeof(mix));

    /* Combine multiple system values */
    snprintf((char *)mix, sizeof(mix), "%ld%ld%lu%s%d%d%d%ld%s",
        (long)tv.tv_sec, (long)tv.tv_usec, tsc,
        un.nodename, pid, ppid, uid, nprocs, un.version);

    /* Simple linear congruential mix for extra diffusion */
    unsigned int seed = (unsigned int)tsc ^ pid ^ (tv.tv_usec + (tv.tv_sec << 16));
    for (i = 0; i < len; i++) {
        seed = 1103515245 * seed + 12345 + mix[i % sizeof(mix)];
        p[i] = (unsigned char)(seed >> 16);
    }

    errno = save_errno;
    return 0;
}
