/*
 * Public domain
 * endian.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_BYTE_ORDER_H_
#define LIBCRYPTOCOMPAT_BYTE_ORDER_H_

#if defined(_WIN32)

#define LITTLE_ENDIAN 1234
#define BIG_ENDIAN 4321
#define PDP_ENDIAN 3412

/*
 * Use GCC compiler defines to determine endianness.
 */
#if defined(__BYTE_ORDER__)
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
#define BYTE_ORDER LITTLE_ENDIAN
#else
#define BYTE_ORDER BIG_ENDIAN
#endif
#endif

/*
 * Use build system defines to determine endianness.
 */
#if !defined(BYTE_ORDER)
#if defined(HAVE_LITTLE_ENDIAN)
#define BYTE_ORDER LITTLE_ENDIAN
#elif defined(HAVE_BIG_ENDIAN)
#define BYTE_ORDER BIG_ENDIAN
#else
#error "Could not detect endianness."
#endif
#endif

#elif defined(HAVE_ENDIAN_H)
#include_next <endian.h>

#elif defined(HAVE_MACHINE_ENDIAN_H)
#include_next <machine/endian.h>

#elif defined(__sun) || defined(_AIX) || defined(__hpux)
#include <arpa/nameser_compat.h>
#include <sys/types.h>

#elif defined(__sgi)
#include <standards.h>
#include <sys/endian.h>

#endif

#ifndef __STRICT_ALIGNMENT
#define __STRICT_ALIGNMENT
#if defined(__i386) || defined(__i386__) || defined(__x86_64) ||               \
    defined(__x86_64__) || defined(__s390__) || defined(__s390x__) ||          \
    defined(__aarch64__) ||                                                    \
    ((defined(__arm__) || defined(__arm)) && __ARM_ARCH >= 6)
#undef __STRICT_ALIGNMENT
#endif
#endif

#if defined(__APPLE__)
#include <libkern/OSByteOrder.h>
#define be16toh(x) OSSwapBigToHostInt16((x))
#define htobe16(x) OSSwapHostToBigInt16((x))
#define le32toh(x) OSSwapLittleToHostInt32((x))
#define be32toh(x) OSSwapBigToHostInt32((x))
#define htole32(x) OSSwapHostToLittleInt32(x)
#define htobe32(x) OSSwapHostToBigInt32(x)
#define htole64(x) OSSwapHostToLittleInt64(x)
#define htobe64(x) OSSwapHostToBigInt64(x)
#define le64toh(x) OSSwapLittleToHostInt64(x)
#define be64toh(x) OSSwapBigToHostInt64(x)
#endif /* __APPLE__ */

#if defined(_WIN32) && !defined(HAVE_ENDIAN_H)
#include <winsock2.h>

#define be16toh(x) ntohs((x))
#define htobe16(x) htons((x))
#define le32toh(x) (x)
#define be32toh(x) ntohl((x))
#define htole32(x) (x)
#define htobe32(x) ntohl((x))
#define be64toh(x) ntohll((x))

#if !defined(ntohll)
#define ntohll(x)                                                              \
  ((1 == htonl(1))                                                             \
       ? (x)                                                                   \
       : ((uint64_t)ntohl((x)&0xFFFFFFFF) << 32) | ntohl((x) >> 32))
#endif
#if !defined(htonll)
#define htonll(x)                                                              \
  ((1 == ntohl(1))                                                             \
       ? (x)                                                                   \
       : ((uint64_t)htonl((x)&0xFFFFFFFF) << 32) | htonl((x) >> 32))
#endif

#define htobe64(x) ntohll((x))
#define htole64(x) (x)
#define le64toh(x) (x)
#endif /* _WIN32 && !HAVE_ENDIAN_H */

#ifdef __linux__
#if !defined(betoh16)
#define betoh16(x) be16toh(x)
#endif
#if !defined(betoh32)
#define betoh32(x) be32toh(x)
#endif
#if !defined(betoh64)
#define betoh64(x) be64toh(x)
#endif
#endif /* __linux__ */

#if defined(__FreeBSD__)
#if !defined(HAVE_ENDIAN_H)
#include <sys/endian.h>
#endif
#if !defined(betoh16)
#define betoh16(x) be16toh(x)
#endif
#if !defined(betoh32)
#define betoh32(x) be32toh(x)
#endif
#if !defined(betoh64)
#define betoh64(x) be64toh(x)
#endif
#endif

#if defined(__NetBSD__)
#if !defined(betoh16)
#define betoh16(x) be16toh(x)
#endif
#if !defined(betoh32)
#define betoh32(x) be32toh(x)
#endif
#if !defined(betoh64)
#define betoh64(x) be64toh(x)
#endif
#endif

#if defined(__sun)
#include <sys/byteorder.h>
#define be16toh(x) BE_16(x)
#define htobe16(x) BE_16(x)
#define le32toh(x) LE_32(x)
#define be32toh(x) BE_32(x)
#define htole32(x) LE_32(x)
#define htobe32(x) BE_32(x)
#define be64toh(x) BE_64(x)
#define le64toh(x) LE_64(x)
#define htole64(x) LE_64(x)
#define htobe64(x) BE_64(x)
#endif

#ifdef _AIX /* AIX is always big endian */
#include <stdint.h>
#include <sys/types.h>

static inline uint64_t htole64(uint64_t x) {
#ifdef __BYTE_ORDER__
#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
	return x;
#else
	return ((uint64_t)x << 56) |
	(((uint64_t)x & 0xFF00ULL) << 40) |
	(((uint64_t)x & 0xFF0000ULL) << 24) |
	(((uint64_t)x & 0xFF000000ULL) << 8) |
	(((uint64_t)x & 0xFF00000000ULL) >> 8) |
	(((uint64_t)x & 0xFF0000000000ULL) >> 24) |
	(((uint64_t)x & 0xFF000000000000ULL) >> 40) |
	((uint64_t)x >> 56);
#endif
#else
	/* Fallback for systems without __BYTE_ORDER__ */
	union {
		uint64_t u64;
		unsigned char bytes[8];
	} val;
	val.u64 = x;
	return ((uint64_t)val.bytes[0] << 56) |
	((uint64_t)val.bytes[1] << 48) |
	((uint64_t)val.bytes[2] << 40) |
	((uint64_t)val.bytes[3] << 32) |
	((uint64_t)val.bytes[4] << 24) |
	((uint64_t)val.bytes[5] << 16) |
	((uint64_t)val.bytes[6] << 8) |
	(uint64_t)val.bytes[7];
#endif
}

#define be64toh(x) (x)
#define be32toh(x) (x)
#define be16toh(x) (x)
#define le32toh(x)             \
	((((x) & 0xff) << 24) |    \
	(((x) & 0xff00) << 8) |    \
	(((x) & 0xff0000) >> 8) |  \
	(((x) & 0xff000000) >> 24))
#define le64toh(x)                          \
	((((x) & 0x00000000000000ffL) << 56) |  \
	(((x) & 0x000000000000ff00L) << 40) |   \
	(((x) & 0x0000000000ff0000L) << 24) |   \
	(((x) & 0x00000000ff000000L) << 8)  |   \
	(((x) & 0x000000ff00000000L) >> 8)  |   \
	(((x) & 0x0000ff0000000000L) >> 24) |   \
	(((x) & 0x00ff000000000000L) >> 40) |   \
	(((x) & 0xff00000000000000L) >> 56))
#ifndef htobe64
#define htobe64(x) be64toh(x)
#endif
#ifndef htobe32
#define htobe32(x) be32toh(x)
#endif
#ifndef htobe16
#define htobe16(x) be16toh(x)
#endif
#ifndef htole32
#define htole32(x) le32toh(x)
#endif
#endif

#endif
