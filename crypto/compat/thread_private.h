#include <pthread.h>

static pthread_mutex_t arc4random_mtx = PTHREAD_MUTEX_INITIALIZER;

#define _ARC4_LOCK()   pthread_mutex_lock(&arc4random_mtx)
#define _ARC4_UNLOCK() pthread_mutex_unlock(&arc4random_mtx)

#ifdef __GLIBC__
extern void *__dso_handle;
extern int __register_atfork(void (*)(void), void(*)(void), void (*)(void), void *);
#define _ARC4_ATFORK(f) __register_atfork(NULL, NULL, (f), __dso_handle)
#else
#define _ARC4_ATFORK(f) pthread_atfork(NULL, NULL, (f))
#endif
