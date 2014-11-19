/*
 * Public domain
 * sys/times.h compatibility shim
 */

#ifndef _WIN32
#include_next <sys/times.h>
#else
#include <win32netcompat.h>
#endif
