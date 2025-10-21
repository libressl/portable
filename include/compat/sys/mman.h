/*
 * Public domain
 * sys/mman.h compatibility shim
 */

#include_next <sys/mman.h>

#ifndef LIBCRYPTOCOMPAT_MMAN_H
#define LIBCRYPTOCOMPAT_MMAN_H

#ifndef MAP_ANON
#ifdef MAP_ANONYMOUS
#define MAP_ANON MAP_ANONYMOUS
#else 
#warning "System does not support mapping anonymous pages. Build may fail" /* Warn, don't error out. arc4random_irix doesn't use anonymous pages */
#endif
#endif

#endif
