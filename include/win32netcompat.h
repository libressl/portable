#ifndef LIBCRYPTOCOMPAT_WIN32NETCOMPAT_H
#define LIBCRYPTOCOMPAT_WIN32NETCOMPAT_H

#ifdef _WIN32

#include <ws2tcpip.h>

#ifndef SHUT_RDWR
#define SHUT_RDWR SD_BOTH
#endif

#ifndef SHUT_RD
#define SHUT_RD SD_RECEIVE
#endif

#ifndef SHUT_WR
#define SHUT_WR SD_SEND
#endif

#endif

#endif
