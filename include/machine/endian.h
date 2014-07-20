#ifndef LIBCRYPTOCOMPAT_BYTE_ORDER_H_
#define LIBCRYPTOCOMPAT_BYTE_ORDER_H_

#if defined(__WIN32)

#define LITTLE_ENDIAN  1234
#define BIG_ENDIAN 4321
#define PDP_ENDIAN	3412

/*
 * Use GCC and Visual Studio compiler defines to determine endian.
 */
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#define BYTE_ORDER LITTLE_ENDIAN
#else
#define BYTE_ORDER BIG_ENDIAN
#endif

#elif defined(__linux__)
#include <endian.h>

#elif defined(__sun)
#include <arpa/nameser_compat.h>

#else
#include_next <machine/endian.h>

#endif

#endif
