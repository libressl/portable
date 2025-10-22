/*
 * Copyright (c) 2014 Theo de Raadt <deraadt@openbsd.org>
 * Copyright (c) 2014 Bob Beck <beck@obtuse.com>
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
 * some parts based off getentropy_linux.c
 * 
 */ 

#include <sys/types.h>
#include <sys/time.h>
#include <sys/utsname.h>
#include <sys/sysmp.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <stdio.h>

/* Use LibreSSL's SHA-512 implementation */
typedef struct {
    unsigned long long h[8];
    unsigned long long Nl, Nh;
    unsigned char data[128];
    unsigned int num;
} SHA512_CTX;

int  SHA512_Init(SHA512_CTX *c);
int  SHA512_Update(SHA512_CTX *c, const void *data, size_t len);
int  SHA512_Final(unsigned char *md, SHA512_CTX *c);

int
getentropy(void *buf, size_t len)
{
    int fd;
    ssize_t ret;
    size_t i = 0;
    int save_errno = errno;
    unsigned char *out = buf;

    if (len > 256) { /* OpenBSD length compliance */
        errno = EINVAL;
        return (-1);
    }

    /* Try /dev/urandom first */
    fd = open("/dev/urandom", O_RDONLY);
    if (fd != -1) {
        while (i < len) {
            ret = read(fd, out + i, len - i);
            if (ret < 0) {
                if (errno == EINTR)
                    continue;
                break;
            }
            if (ret == 0)
                break;
            i += (size_t)ret;
        }
        close(fd);
        if (i == len) {
            errno = save_errno;
            return (0);
        }
    }

    /* Fallback code */
    struct timeval tv;
    struct utsname un;
    pid_t pid = getpid(), ppid = getppid();
    uid_t uid = getuid(), gid = getgid();
    long nprocs = sysmp(MP_NPROCS);
    time_t now = time(NULL);
    void *stackptr = &fd;

    gettimeofday(&tv, NULL);
    uname(&un);

    unsigned char pool[512];
    memset(pool, 0, sizeof(pool));
    size_t pos = 0;

    pos += snprintf((char *)pool + pos, sizeof(pool) - pos,
        "%ld:%ld:%d:%d:%d:%d:%ld:%ld:%s:%s:%p",
        (long)tv.tv_sec, (long)tv.tv_usec,
        (int)pid, (int)ppid, (int)uid, (int)gid,
        nprocs, (long)now,
        un.nodename, un.version, stackptr);

    /* Hash the pool */
    unsigned char digest[64];
    unsigned char counter = 0;
    SHA512_CTX ctx;

    size_t remaining = len;
    while (remaining > 0) {
        SHA512_Init(&ctx);
        SHA512_Update(&ctx, pool, pos);
        SHA512_Update(&ctx, &counter, sizeof(counter));
        SHA512_Final(digest, &ctx);
        counter++;

        size_t take = remaining < sizeof(digest) ? remaining : sizeof(digest);
        memcpy(out + (len - remaining), digest, take);
        remaining -= take;
    }
    /* cleanup */
    memset(pool, 0, sizeof(pool));
    memset(digest, 0, sizeof(digest));
    memset(&ctx, 0, sizeof(ctx));

    errno = save_errno;
    return (0);
}
