/*
 * Public domain
 * sys/time.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_SYS_TIME_H
#define LIBCRYPTOCOMPAT_SYS_TIME_H

#ifdef _MSC_VER
/*
 * Use the winsock struct timeval: it is what <openssl/dtls1.h> gives
 * callers of DTLSv1_get_timeout() and the dgram BIO ctrls, so libssl
 * must be built against the same layout.
 */
#include <winsock2.h>

#define gettimeofday libressl_gettimeofday

int gettimeofday(struct timeval *tp, void *tzp);
#else
#include_next <sys/time.h>
#endif

#ifndef timersub
#define timersub(tvp, uvp, vvp)                                         \
	do {                                                            \
		(vvp)->tv_sec = (tvp)->tv_sec - (uvp)->tv_sec;          \
		(vvp)->tv_usec = (tvp)->tv_usec - (uvp)->tv_usec;       \
		if ((vvp)->tv_usec < 0) {                               \
			(vvp)->tv_sec--;                                \
			(vvp)->tv_usec += 1000000;                      \
		}                                                       \
	} while (0)
#endif

#endif
