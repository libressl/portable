/* $OpenBSD$ */

#include <unistd.h>

#ifdef _WIN32
#include <windows.h>
#endif

int
getpagesize(void) {
#ifdef _WIN32
	SYSTEM_INFO system_info;
	GetSystemInfo(&system_info);
	return system_info.dwPageSize;
#else
	return sysconf(_SC_PAGESIZE);
#endif
}
