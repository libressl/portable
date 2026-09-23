/*
 * Public domain
 *
 * pipe2/pipe emulation
 * Brent Cook <bcook@openbsd.org>
 */

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>

/* call the real socketpair(), not the bsd_socketpair() it may be #define'd to */
#undef socketpair
/* define bsd_pipe2() directly, not through the pipe2() -> bsd_pipe2() macro */
#undef pipe2

#ifndef HAVE_PIPE2

#ifdef _WIN32

static int setfd(int fd, int flag)
{
	int rc = -1;
	if (flag & FD_CLOEXEC) {
		/* fd is a Winsock SOCKET, not a CRT descriptor: use it as a
		 * handle directly rather than translating with _get_osfhandle. */
		HANDLE h = (HANDLE)(LONG_PTR)fd;
		rc = SetHandleInformation(h, HANDLE_FLAG_INHERIT, 0) == 0 ? -1 : 0;
	}
	return rc;
}

static int setfl(int fd, int flag)
{
	int rc = -1;
	if (flag & O_NONBLOCK) {
		long mode = 1;
		rc = ioctlsocket(fd, FIONBIO, &mode);
	}
	return rc;
}

/* defined in compat/socketpair.c */
int socketpair(int domain, int type, int protocol, int socket_vector[2]);

int pipe(int fildes[2])
{
	return socketpair(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, PF_UNSPEC, fildes);
}

#else

static int setfd(int fd, int flag)
{
	int flags = fcntl(fd, F_GETFD);
	flags |= flag;
	return fcntl(fd, F_SETFD, flags);
}

static int setfl(int fd, int flag)
{
	int flags = fcntl(fd, F_GETFL);
	flags |= flag;
	return fcntl(fd, F_SETFL, flags);
}
#endif

int bsd_pipe2(int fildes[2], int flags)
{
	int rc = pipe(fildes);
	if (rc == 0) {
		if (flags & O_NONBLOCK) {
			rc |= setfl(fildes[0], O_NONBLOCK);
			rc |= setfl(fildes[1], O_NONBLOCK);
		}
		if (flags & O_CLOEXEC) {
			rc |= setfd(fildes[0], FD_CLOEXEC);
			rc |= setfd(fildes[1], FD_CLOEXEC);
		}
		if (rc != 0) {
			int e = errno;
			close(fildes[0]);
			close(fildes[1]);
			errno = e;
		}
	}
	return rc;
}

#endif /* !HAVE_PIPE2 */
