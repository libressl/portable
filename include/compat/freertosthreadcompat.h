#ifndef LIBCRYPTOCOMPAT_FREERTOSTHREADCOMPAT_H
#define LIBCRYPTOCOMPAT_FREERTOSTHREADCOMPAT_H

#ifdef FREERTOS

#include <sys/types.h>

#include <FreeRTOS/FreeRTOSConfig.h>
#include <FreeRTOS/FreeRTOS.h>
#include <FreeRTOS/semphr.h>
#include <FreeRTOS/task.h>

// PTHREAD ONCE
#define pthread_once libressl_pthread_once
struct pthread_once {
	int   is_initialized;
	int   init_executed;
};
#define pthread_once_t libressl_pthread_once_t
typedef struct pthread_once pthread_once_t;

#define PTHREAD_ONCE_INIT { 1, 0 }

static inline int
pthread_once(pthread_once_t *once, void (*cb) (void))
{
	if (!once->is_initialized) {
		return -1;
	}

	if (!once->init_executed) {
		once->init_executed = 1;
		cb();
		return 0;
	}

	return -1;

}

// PTHREAD Support 
#define pthread_t libressl_pthread_t
typedef TaskHandle_t pthread_t;

static inline pthread_t
pthread_self(void)
{
	return xTaskGetCurrentTaskHandle();
}

static inline int
pthread_equal(pthread_t t1, pthread_t t2)
{
	return t1 == t2;
}


// PTHREAD MUTEX Support
#define pthread_mutex libressl_pthread_mutex
struct pthread_mutex {
	xSemaphoreHandle handle;
};
#define pthread_mutex_t libressl_pthread_mutex_t
typedef struct pthread_mutex pthread_mutex_t;

#define pthread_mutexattr libressl_mutexattr
struct pthread_mutexattr {

};
#define pthread_mutexattr_t libressl_mutexattr_t
typedef struct pthread_mutexattr pthread_mutexattr_t;


#define PTHREAD_MUTEX_INITIALIZER { NULL }

static inline int
pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
{
	xSemaphoreHandle x = xSemaphoreCreateMutex();
	if (x) {
		mutex->handle = x;
		return 0;
	}

	return -1;
}

static inline int
pthread_mutex_lock(pthread_mutex_t *mutex)
{
	xSemaphoreHandle x = mutex->handle;
	if (x == NULL) {
		x = xSemaphoreCreateMutex();
		mutex->handle = x;
	}

	if ( xSemaphoreTake(x, portMAX_DELAY) == pdTRUE ) {
        return 0;
    }
    else {
        return -2;
    }
}

static inline int
pthread_mutex_unlock(pthread_mutex_t *mutex)
{
	xSemaphoreHandle x = mutex->handle;
	if (x) {
	    if ( xSemaphoreGive(x) == pdTRUE ) {
	        return 0;
	    }
	    else {
	    	return -1;
	    }
	}

	return 0;
}

static inline int
pthread_mutex_destroy(pthread_mutex_t *mutex)
{
	xSemaphoreHandle x = mutex->handle;
	if (x) {
		vQueueDelete(x);
	}
	mutex->handle = NULL;
	return 0;
}

#endif

#endif
