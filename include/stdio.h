/*
 * Public domain
 * stdio.h compatibility shim
 */

#include_next <stdio.h>

#ifndef LIBCRYPTOCOMPAT_STDIO_H
#define LIBCRYPTOCOMPAT_STDIO_H

#ifndef HAVE_ASPRINTF
#include <stdarg.h>
int vasprintf(char **str, const char *fmt, va_list ap);
int asprintf(char **str, const char *fmt, ...);
#endif

#ifdef _WIN32
#include <errno.h>
#include <string.h>

static inline void
posix_perror(const char *s)
{
	fprintf(stderr, "%s: %s\n", s, strerror(errno));
}

#define perror(errnum) posix_perror(errnum)
#endif

#endif
