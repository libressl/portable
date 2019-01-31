#include <stdlib.h>

#include <windows.h>

const char *
getprogname(void)
{
	static char progname[MAX_PATH + 1];
	DWORD length = GetModuleFileName(NULL, progname, sizeof (progname) - 1);
	if (length < 0)
		return "?";
	return progname;
}
