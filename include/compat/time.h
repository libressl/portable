/*
 * Public domain
 * sys/time.h compatibility shim
 */

#ifdef _MSC_VER
#if _MSC_VER >= 1900
#include <../ucrt/time.h>
#else
#include <../include/time.h>
#endif
#define gmtime_r(tp, tm) ((gmtime_s((tm), (tp)) == 0) ? (tm) : NULL)
#else
#include_next <time.h>
#endif
