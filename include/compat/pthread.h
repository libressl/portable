/*
 * Public domain
 * pthread.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_PTHREAD_H
#define LIBCRYPTOCOMPAT_PTHREAD_H

#ifdef _WIN32

#include <windows.h>

/*
 * Static once initialization values.
 */
#define PTHREAD_ONCE_INIT   { INIT_ONCE_STATIC_INIT }

/*
 * Once definitions.
 */
struct pthread_once {
	INIT_ONCE once;
};
typedef struct pthread_once pthread_once_t;

static inline BOOL CALLBACK
_pthread_once_win32_cb(PINIT_ONCE once, PVOID param, PVOID *context)
{
	void (*cb) (void) = param;
	cb();
	return TRUE;
}

static inline int
pthread_once(pthread_once_t *once, void (*cb) (void))
{
	BOOL rc = InitOnceExecuteOnce(&once->once, _pthread_once_win32_cb, cb, NULL);
	if (rc == 0)
		return -1;
	else
		return 0;
}

typedef DWORD pthread_t;

static inline pthread_t
pthread_self(void)
{
	return GetCurrentThreadId();
}

static inline int
pthread_equal(pthread_t t1, pthread_t t2)
{
	return t1 == t2;
}

typedef CRITICAL_SECTION pthread_mutex_t;
typedef void pthread_mutexattr_t;

static inline int
pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
{
	InitializeCriticalSection(mutex);
	return 0;
}

static inline int
pthread_mutex_lock(pthread_mutex_t *mutex)
{
	EnterCriticalSection(mutex);
	return 0;
}

static inline int
pthread_mutex_unlock(pthread_mutex_t *mutex)
{
	LeaveCriticalSection(mutex);
	return 0;
}

#else
#include_next <pthread.h>
#endif

#endif
