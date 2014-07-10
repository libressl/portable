#include_next <sys/types.h>

#ifndef LIBCRYPTOCOMPAT_SYS_TYPES_H
#define LIBCRYPTOCOMPAT_SYS_TYPES_H

#include <stdint.h>

#ifdef __sun
typedef uint8_t u_int8_t;
typedef uint32_t u_int32_t;
#endif

#endif
