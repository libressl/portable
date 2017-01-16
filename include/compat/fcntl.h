/*
 * Public domain
 * fcntl.h compatibility shim
 */

#ifndef _WIN32
#include_next <fcntl.h>
#else

#ifdef _MSC_VER
#if _MSC_VER >= 1900
#include <../ucrt/fcntl.h>
#else
#include <../include/fcntl.h>
#endif
#else
#include_next <fcntl.h>
#endif

#ifndef O_NONBLOCK
#define O_NONBLOCK      0x100000
#endif

#ifndef O_CLOEXEC
#define O_CLOEXEC       0x200000
#endif

#ifndef FD_CLOEXEC
#define FD_CLOEXEC      1
#endif

int posix_open(const char *path, ...);

#ifndef NO_REDEF_POSIX_FUNCTIONS
#define open(path, ...) posix_open(path, __VA_ARGS__)
#endif

#endif
