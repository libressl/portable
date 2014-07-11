/*
 * Public domain
 * unistd.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_UNISTD_H
#define LIBCRYPTOCOMPAT_UNISTD_H

#ifndef _MSC_VER
#include_next <unistd.h>
#else

#include <stdlib.h>
#include <io.h>
#include <process.h>

#define R_OK    4
#define W_OK    2
#define X_OK    0
#define F_OK    0

#define access _access

static inline unsigned int sleep(unsigned int seconds)
{
	Sleep(seconds * 1000);
	return seconds;
}

#endif

#ifndef HAVE_GETENTROPY
int getentropy(void *buf, size_t buflen);
#endif

#endif
