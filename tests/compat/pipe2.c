/*
 * Public domain
 */

#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#undef socketpair

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

int pipe2(int fildes[2], int flags)
{
	int rc = pipe(fildes);
	if (rc == 0) {
		if (flags & O_NONBLOCK) {
			setfl(fildes[0], O_NONBLOCK);
			setfl(fildes[1], O_NONBLOCK);
		}
		if (flags & O_CLOEXEC) {
			setfd(fildes[0], FD_CLOEXEC);
			setfd(fildes[1], FD_CLOEXEC);
		}
	}
	return rc;
}

int bsd_socketpair(int domain, int type, int protocol, int socket_vector[2])
{
	int flags = type & ~0xf;
	type &= 0xf;
	int rc = socketpair(domain, type, protocol, socket_vector);
	if (rc == 0) {
		if (flags & SOCK_NONBLOCK) {
			setfl(socket_vector[0], O_NONBLOCK);
			setfl(socket_vector[1], O_NONBLOCK);
		}
		if (flags & SOCK_CLOEXEC) {
			setfd(socket_vector[0], FD_CLOEXEC);
			setfd(socket_vector[1], FD_CLOEXEC);
		}
	}
	return rc;
}
