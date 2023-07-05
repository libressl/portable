/*
 * Public domain
 * stdint.h compatibility shim
 */

#ifdef _MSC_VER
#include <../include/stdint.h>
#else
#include_next <stdint.h>
#endif

#ifndef LIBCRYPTOCOMPAT_STDINT_H
#define LIBCRYPTOCOMPAT_STDINT_H

#ifndef SIZE_MAX
#include <limits.h>
#endif

#if !defined(HAVE_ATTRIBUTE__BOUNDED__) && !defined(__bounded__)
# define __bounded__(x, y, z)
#endif

#if !defined(HAVE_ATTRIBUTE__DEAD) && !defined(__dead)
#ifdef _MSC_VER
#define __dead      __declspec(noreturn)
#else
#define __dead      __attribute__((__noreturn__))
#endif
#endif

#endif
