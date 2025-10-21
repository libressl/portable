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
