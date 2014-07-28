#include_next <unistd.h>

#ifndef LIBCRYPTOCOMPAT_UNISTD_H
#define LIBCRYPTOCOMPAT_UNISTD_H

#ifdef NO_GETENTROPY
int getentropy(void *buf, size_t buflen);
#endif

#ifdef NO_ISSETUGID
int issetugid(void);
#endif

#endif
