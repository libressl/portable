/*
 * Public domain
 * pthread.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_PTHREAD_H
#define LIBCRYPTOCOMPAT_PTHREAD_H

#if defined(FREERTOS)
#include <freertosthreadcompat.h>
#elif defined(_WIN32)

#include <malloc.h>
#include <stdlib.h>
#include <windows.h>

/*
 * Static once initialization values.
 */
#define PTHREAD_ONCE_INIT   { INIT_ONCE_STATIC_INIT }

/*
 * Static mutex initialization values.
 */
#define PTHREAD_MUTEX_INITIALIZER	{ .lock = NULL }

/*
 * Once definitions.
 */
struct pthread_once {
	INIT_ONCE once;
};
typedef struct pthread_once pthread_once_t;

struct _pthread_win32_cb_arg {
	void (*cb)(void);
};

static inline BOOL CALLBACK
_pthread_once_win32_cb(PINIT_ONCE once, PVOID param, PVOID *context)
{
	struct _pthread_win32_cb_arg *arg = param;
	arg->cb();
	return TRUE;
}

static inline int
pthread_once(pthread_once_t *once, void (*cb) (void))
{
	struct _pthread_win32_cb_arg arg = { .cb = cb };
	BOOL rc = InitOnceExecuteOnce(&once->once, _pthread_once_win32_cb, &arg, NULL);
	if (rc == 0)
		return EINVAL;
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

struct pthread_mutex {
	volatile LPCRITICAL_SECTION lock;
};
typedef struct pthread_mutex pthread_mutex_t;
typedef void pthread_mutexattr_t;

static inline int
pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
{
	if ((mutex->lock = malloc(sizeof(CRITICAL_SECTION))) == NULL)
		exit(ENOMEM);
	InitializeCriticalSection(mutex->lock);
	return 0;
}

static inline int
pthread_mutex_lock(pthread_mutex_t *mutex)
{
	if (mutex->lock == NULL) {
		LPCRITICAL_SECTION lcs;

		if ((lcs = malloc(sizeof(CRITICAL_SECTION))) == NULL)
			exit(ENOMEM);
		InitializeCriticalSection(lcs);
		if (InterlockedCompareExchangePointer((PVOID*)&mutex->lock, (PVOID)lcs, NULL) != NULL) {
			DeleteCriticalSection(lcs);
			free(lcs);
		}
	}
	EnterCriticalSection(mutex->lock);
	return 0;
}

static inline int
pthread_mutex_unlock(pthread_mutex_t *mutex)
{
	LeaveCriticalSection(mutex->lock);
	return 0;
}

static inline int
pthread_mutex_destroy(pthread_mutex_t *mutex)
{
	DeleteCriticalSection(mutex->lock);
	free(mutex->lock);
	return 0;
}

#else
#include_next <pthread.h>
#endif

#endif
