#include_next <sys/mman.h>

#ifndef LIBCRYPTOCOMPAT_MMAN_H
#define LIBCRYPTOCOMPAT_MMAN_H

#ifndef MAP_ANONYMOUS
#ifdef MAP_ANON
#define MAP_ANONYMOUS MAP_ANON
#else
#error "System does not support mapping anonymous pages?"
#endif
#endif

#endif
