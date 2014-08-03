#include_next <string.h>

#ifndef LIBCRYPTOCOMPAT_STRING_H
#define LIBCRYPTOCOMPAT_STRING_H

#include <sys/types.h>

#ifdef __sun
/* Some functions historically defined in string.h were placed in strings.h by
 * SUS. Use the same hack as OS X and FreeBSD use to work around on Solaris.
 */
#include <strings.h>
#endif

#ifdef NO_STRLCPY
size_t strlcpy(char *dst, const char *src, size_t siz);
#endif

#ifdef NO_STRLCAT
size_t strlcat(char *dst, const char *src, size_t siz);
#endif

#ifdef NO_STRNDUP
char * strndup(const char *str, size_t maxlen);
#ifdef NO_STRNLEN
size_t strnlen(const char *str, size_t maxlen);
#endif
#endif

#ifdef NO_EXPLICIT_BZERO
void explicit_bzero(void *, size_t);
#endif

#ifdef NO_TIMINGSAFE_BCMP
int timingsafe_bcmp(const void *b1, const void *b2, size_t n);
#endif

#ifdef NO_TIMINGSAFE_MEMCMP
int timingsafe_memcmp(const void *b1, const void *b2, size_t len);
#endif

#ifdef NO_MEMMEM
void * memmem(const void *big, size_t big_len, const void *little,
	size_t little_len);
#endif

#endif
