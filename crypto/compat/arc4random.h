#ifndef LIBCRYPTOCOMPAT_ARC4RANDOM_H
#define LIBCRYPTOCOMPAT_ARC4RANDOM_H

#include <sys/param.h>

#if defined(__FreeBSD__)
#include "arc4random_freebsd.h"

#elif defined(__linux__)
#include "arc4random_linux.h"

#elif defined(__APPLE__)
#include "arc4random_osx.h"

#elif defined(__sun)
#include "arc4random_solaris.h"

#elif defined(_WIN32)
#include "arc4random_win.h"

#else
#error "No arc4random hooks defined for this platform."

#endif

#endif
