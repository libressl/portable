#include_next <sys/types.h>

#ifndef LIBCRYPTOCOMPAT_SYS_TYPES_H
#define LIBCRYPTOCOMPAT_SYS_TYPES_H

#include <stdint.h>

#ifdef __sun
typedef uint8_t u_int8_t;
typedef uint32_t u_int32_t;
#endif

#if !defined(HAVE_ATTRIBUTE__BOUNDED__) && !defined(__bounded__)
# define __bounded__(x, y, z)
#endif

#endif
