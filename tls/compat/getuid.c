/*
 * Public domain
 *
 * Kinichiro Inoguchi <inoguchi@openbsd.org>
 */

#ifdef _WIN32

#include <unistd.h>

uid_t
getuid(void)
{
	/* Windows fstat sets 0 as st_uid */
	return 0;
}

#endif
