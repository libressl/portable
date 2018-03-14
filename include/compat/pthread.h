/*
 * Public domain
 * pthread.h compatibility shim
 */

#ifdef _WIN32

#include <synchapi.h>

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

static BOOL CALLBACK _pthread_once_win32_cb(PINIT_ONCE once, PVOID param, PVOID *context)
{
	void (*cb) (void) = param;
	cb();
    return TRUE;
}

static int pthread_once(pthread_once_t *once, void (*cb) (void))
{
	BOOL rc = InitOnceExecuteOnce(&once->once, _pthread_once_win32_cb, cb, NULL);
	if (rc == 0) {
		return -1;
	} else {
		return 0;
	}
}

#else
#include_next <pthread.h>
#endif
