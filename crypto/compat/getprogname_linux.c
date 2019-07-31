#include <stdlib.h>

#include <errno.h>

const char *
getprogname(void)
{
#if defined(__ANDROID_API__) && __ANDROID_API__ < 21
	/*
	 * Android added getprogname with API 21, so we should not end up here
	 * with APIs newer than 21.
	 * https://github.com/aosp-mirror/platform_bionic/blob/1eb6d3/libc/include/stdlib.h#L160
	 *
	 * Since Android is using portions of OpenBSD libc, it should have
	 * a symbol called __progname.
	 * https://github.com/aosp-mirror/platform_bionic/commit/692207
	 */
	extern const char *__progname;
	return __progname;
#else
	return program_invocation_short_name;
#endif
}
