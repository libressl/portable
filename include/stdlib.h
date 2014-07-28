#include_next <stdlib.h>

#ifndef LIBCRYPTOCOMPAT_STDLIB_H
#define LIBCRYPTOCOMPAT_STDLIB_H

#include <sys/stat.h>
#include <sys/time.h>
#include <stdint.h>

#ifdef NO_ARC4RANDOM_BUF
uint32_t arc4random(void);
void arc4random_buf(void *_buf, size_t n);
#endif

#ifdef NO_REALLOCARRAY
void *reallocarray(void *, size_t, size_t);
#endif

#ifdef NO_STRTONUM
long long strtonum(const char *nptr, long long minval,
		long long maxval, const char **errstr);
#endif

#endif
