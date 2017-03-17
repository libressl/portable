/* $OpenBSD$ */

#include <unistd.h>
#include <windows.h>

int
getpagesize(void)
{
	SYSTEM_INFO system_info;
	GetSystemInfo(&system_info);
	return system_info.dwPageSize;
}
