#include_next <stdio.h>

#ifndef LIBCRYPTOCOMPAT_STDIO_H
#define LIBCRYPTOCOMPAT_STDIO_H

#ifdef NO_ASPRINTF
#include <stdarg.h>
int vasprintf(char **str, const char *fmt, va_list ap);
int asprintf(char **str, const char *fmt, ...);
#endif

#endif
