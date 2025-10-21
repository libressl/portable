
/*
 * Stub functions for portability.
 */

#include <sys/mman.h>

#include <pthread.h>
#include <signal.h>

static pthread_mutex_t arc4random_mtx = PTHREAD_MUTEX_INITIALIZER;
#define _ARC4_LOCK()   pthread_mutex_lock(&arc4random_mtx)
#define _ARC4_UNLOCK() pthread_mutex_unlock(&arc4random_mtx)

#define _ARC4_ATFORK(f) pthread_atfork(NULL, NULL, (f))

static inline void
_getentropy_fail(void)
{
        raise(SIGKILL);
}

static volatile sig_atomic_t _rs_forked;

static inline void
_rs_forkhandler(void)
{
        _rs_forked = 1;
}

static inline void
_rs_forkdetect(void)
{
        static pid_t _rs_pid = 0;
        pid_t pid = getpid();

        if (_rs_pid == 0 || _rs_pid != pid || _rs_forked) {
                _rs_pid = pid;
                _rs_forked = 0;
                if (rs)
                        memset(rs, 0, sizeof(*rs));
        }
}

/* IRIX has no MAP_ANONYMOUS support. Use fd to /dev/zero and closefd after */

static inline int
_rs_allocate(struct _rs **rsp, struct _rsx **rsxp)
{
        int fd;
        fd = open("/dev/zero", O_RDWR);
        if ((*rsp = mmap(NULL, sizeof(**rsp), PROT_READ|PROT_WRITE,
            MAP_PRIVATE, fd, 0)) == MAP_FAILED)
                return (-1);

        if ((*rsxp = mmap(NULL, sizeof(**rsxp), PROT_READ|PROT_WRITE,
            MAP_PRIVATE, fd, 0)) == MAP_FAILED) {
                munmap(*rsp, sizeof(**rsp));
                *rsp = NULL;
                return (-1);
        }
        close(fd);

        _ARC4_ATFORK(_rs_forkhandler);
        return (0);
}
