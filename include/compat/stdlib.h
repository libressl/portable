/*
 * stdlib.h compatibility shim
 * Public domain
 */

#ifdef _MSC_VER
#if _MSC_VER >= 1900
#include <../ucrt/stdlib.h>
#else
#include <../include/stdlib.h>
#endif
#else
#include_next <stdlib.h>
#endif

#ifndef LIBCRYPTOCOMPAT_STDLIB_H
#define LIBCRYPTOCOMPAT_STDLIB_H

#include <sys/types.h>
#include <stdint.h>

#ifndef HAVE_ARC4RANDOM_BUF
#define arc4random libressl_arc4random
uint32_t arc4random(void);
#define arc4random_buf libressl_arc4random_buf
void arc4random_buf(void *_buf, size_t n);
#define arc4random_uniform libressl_arc4random_uniform
uint32_t arc4random_uniform(uint32_t upper_bound);
#endif

#ifndef HAVE_FREEZERO
#define freezero libressl_freezero
void freezero(void *ptr, size_t sz);
#endif

#ifndef HAVE_GETPROGNAME
#define getprogname libressl_getprogname
const char * getprogname(void);
#endif

#ifndef HAVE_REALLOCARRAY
#define reallocarray libressl_reallocarray
void *reallocarray(void *, size_t, size_t);
#endif

#ifndef HAVE_RECALLOCARRAY
#define recallocarray libressl_recallocarray
void *recallocarray(void *, size_t, size_t, size_t);
#endif

#ifndef HAVE_STRTONUM
#define strtonum libressl_strtonum
long long strtonum(const char *nptr, long long minval,
		long long maxval, const char **errstr);
#endif

#endif
