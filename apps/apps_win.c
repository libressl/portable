/*
 * Public domain
 *
 * Dongsheng Song <dongsheng.song@gmail.com>
 * Brent Cook <bcook@openbsd.org>
 */

#include <windows.h>

#include "apps.h"

double
app_tminterval(int stop, int usertime)
{
	static unsigned __int64 tmstart;
	union {
		unsigned __int64 u64;
		FILETIME ft;
	} ct, et, kt, ut;

	GetProcessTimes(GetCurrentProcess(), &ct.ft, &et.ft, &kt.ft, &ut.ft);

	if (stop == TM_START) {
		tmstart = ut.u64 + kt.u64;
	} else {
		return (ut.u64 + kt.u64 - tmstart) / (double) 10000000;
	}
	return 0;
}
