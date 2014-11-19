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

#endif
