/*
 * Public domain
 * sys/time.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_TIME_H
#define LIBCRYPTOCOMPAT_TIME_H

#ifdef _MSC_VER
#include <../include/time.h>
#define gmtime_r(tp, tm) ((gmtime_s((tm), (tp)) == 0) ? (tm) : NULL)
#else
#include_next <time.h>
#endif

#endif
