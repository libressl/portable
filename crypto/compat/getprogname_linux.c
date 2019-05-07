#include <stdlib.h>

#include <errno.h>

const char *
getprogname(void)
{
	/*
	 * Android added getprogname with API 21 [0]. We should not end up here
	 * with APIs bigger than 21. Still write a precise check.
	 *
	 * Since Android is using portions of OpenBSD libc, it should have
	 * a symbol called __progname [1].
	 *
	 * Regarding program_invocation_short_name, it is a GNU libc ext [2] and
	 * so make it conditional to __GLIBC__ [3].
	 *
	 * .. [0] https://github.com/aosp-mirror/platform_bionic/blob/1eb6d3/libc/include/stdlib.h#L160
	 *
	 * .. [1] https://github.com/aosp-mirror/platform_bionic/commit/692207
	 *
	 * .. [2] https://linux.die.net/man/3/program_invocation_short_name
	 *
	 * .. [3] https://android.googlesource.com/platform/system/core/+/2819c0/base/logging.cpp#65
	 */
#if defined(__ANDROID_API__) && __ANDROID_API__ < 21
	extern const char *__progname;
	return __progname;
#elif defined(__GLIBC__)
	return program_invocation_short_name;
#else
#error "Cannot emulate getprogname"
#endif
}
