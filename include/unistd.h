/*
 * Public domain
 * unistd.h compatibility shim
 */

#include_next <unistd.h>

#ifndef LIBCRYPTOCOMPAT_UNISTD_H
#define LIBCRYPTOCOMPAT_UNISTD_H

#ifndef HAVE_GETENTROPY
int getentropy(void *buf, size_t buflen);
#endif

#ifndef HAVE_ISSETUGID
int issetugid(void);
#endif

#endif
