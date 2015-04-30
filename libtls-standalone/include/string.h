/*
 * Public domain
 * string.h compatibility shim
 */

#include_next <string.h>

#ifndef LIBCRYPTOCOMPAT_STRING_H
#define LIBCRYPTOCOMPAT_STRING_H

#include <sys/types.h>

#if defined(__sun) || defined(__hpux)
/* Some functions historically defined in string.h were placed in strings.h by
 * SUS. Use the same hack as OS X and FreeBSD use to work around on Solaris and HPUX.
 */
#include <strings.h>
#endif

#ifndef HAVE_EXPLICIT_BZERO
void explicit_bzero(void *, size_t);
#endif

#ifndef HAVE_STRSEP
char *strsep(char **stringp, const char *delim);
#endif

#endif
