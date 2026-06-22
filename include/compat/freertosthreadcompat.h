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
	xSemaphoreHandle lock;
	int init_executed;
};
#define pthread_once_t libressl_pthread_once_t
typedef struct pthread_once pthread_once_t;

#define PTHREAD_ONCE_INIT { .lock = NULL, .init_executed = 0 }

static inline int
pthread_once(pthread_once_t *once, void (*cb) (void))
{
	if (once->lock == NULL)
		once->lock = xSemaphoreCreateMutex();
	if (once->lock == NULL)
		return -1;
	if (xSemaphoreTake(once->lock, portMAX_DELAY) != pdTRUE)
		return -1;

	if (!once->init_executed) {
		once->init_executed = 1;
		cb();
	}

	xSemaphoreGive(once->lock);
	return 0;
}

// PTHREAD Support 
#define pthread_t libressl_pthread_t
typedef TaskHandle_t pthread_t;

#define pthread_self libressl_pthread_self
static inline pthread_t
pthread_self(void)
{
	return xTaskGetCurrentTaskHandle();
}

#define pthread_equal libressl_pthread_equal
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

#define pthread_mutexattr libressl_pthread_mutexattr
struct pthread_mutexattr {

};
#define pthread_mutexattr_t libressl_pthread_mutexattr_t
typedef struct pthread_mutexattr pthread_mutexattr_t;


#define PTHREAD_MUTEX_INITIALIZER { NULL }

#define pthread_mutex_init libressl_pthread_mutex_init
static inline int
pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
{
	if ((mutex->handle = xSemaphoreCreateMutex()) == NULL)
		return -1;
	return 0;
}

#define pthread_mutex_lock libressl_pthread_mutex_lock
static inline int
pthread_mutex_lock(pthread_mutex_t *mutex)
{
	if (mutex->handle == NULL)
		mutex->handle = xSemaphoreCreateMutex();
	if (mutex->handle == NULL)
		return -1;
	if (xSemaphoreTake(mutex->handle, portMAX_DELAY) != pdTRUE)
		return -1;
	return 0;
}

#define pthread_mutex_unlock libressl_pthread_mutex_unlock
static inline int
pthread_mutex_unlock(pthread_mutex_t *mutex)
{
	if (mutex->handle == NULL)
		return 0;
	if (xSemaphoreGive(mutex->handle) == pdTRUE)
		return 0;
	return -1;
}

#define pthread_mutex_destroy libressl_pthread_mutex_destroy
static inline int
pthread_mutex_destroy(pthread_mutex_t *mutex)
{
	if (mutex->handle != NULL)
		vQueueDelete(mutex->handle);
	mutex->handle = NULL;
	return 0;
}

#endif

#endif
