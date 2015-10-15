/*
 * Public domain
 * limits.h compatibility shim
 */

#ifdef _MSC_VER
#if _MSC_VER >= 1900
#include <../ucrt/limits.h>
#else
#include <../include/limits.h>
#endif
#else
#include_next <limits.h>
#endif

#ifdef __hpux
#include <sys/param.h>
#ifndef PATH_MAX
#define PATH_MAX MAXPATHLEN
#endif
#endif
