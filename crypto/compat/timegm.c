/*
 * timegm shims based on example code from in the glibc timegm manpage.
 *
 * These should be replaced with lockless versions that do not require
 * modifying global state.
 */

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifdef _WIN32
#include <windows.h>
time_t
timegm(struct tm *tm)
{
	time_t ret;
	char *tz, *buf;
	static volatile HANDLE mtx = NULL;

	if (!mtx) {
		HANDLE p = CreateMutex(NULL, FALSE, NULL);
		if (InterlockedCompareExchangePointer(
		    (void **)&mtx, (void *)p, NULL))
			CloseHandle(p);
	}
	WaitForSingleObject(mtx, INFINITE);
	tz = getenv("TZ");
	if (tz) {
		if (asprintf(&buf, "TZ=%s", tz) == -1)
			buf = NULL;
	}
	putenv("TZ=UTC");
	tzset();
	ret = mktime(tm);
	if (buf) {
		putenv(buf);
		free(buf);
	} else
		putenv("TZ=");
	tzset();
	ReleaseMutex(mtx);
	return ret;
}
#else
#include <pthread.h>
time_t
timegm(struct tm *tm)
{
	time_t ret;
	char *tz;
	static pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;

	pthread_mutex_lock(&mtx);
	tz = getenv("TZ");
	if (tz)
		tz = strdup(tz);
	setenv("TZ", "", 1);
	tzset();
	ret = mktime(tm);
	if (tz) {
		setenv("TZ", tz, 1);
		free(tz);
	} else
		unsetenv("TZ");
	tzset();
	pthread_mutex_unlock(&mtx);
	return ret;
}
#endif
