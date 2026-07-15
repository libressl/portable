/*
 * Public domain
 *
 * Kinichiro Inoguchi <inoguchi@openbsd.org>
 */

#ifdef _WIN32

#define NO_REDEF_POSIX_FUNCTIONS

#include <errno.h>
#include <unistd.h>

ssize_t
pwrite(int d, const void *buf, size_t nbytes, off_t offset)
{
	off_t cpos;
	ssize_t bytes;
	int save_errno;

	if((cpos = lseek(d, 0, SEEK_CUR)) == -1)
		return -1;
	if(lseek(d, offset, SEEK_SET) == -1)
		return -1;
	bytes = write(d, buf, nbytes);
	save_errno = errno;
	if(lseek(d, cpos, SEEK_SET) == -1)
		return -1;
	errno = save_errno;
	return bytes;
}

#endif
