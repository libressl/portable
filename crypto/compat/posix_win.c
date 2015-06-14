/*
 * Public domain
 *
 * BSD socket emulation code for Winsock2
 * File IO compatibility shims
 * Brent Cook <bcook@openbsd.org>
 */

#define NO_REDEF_POSIX_FUNCTIONS

#include <windows.h>
#include <ws2tcpip.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void
posix_perror(const char *s)
{
	fprintf(stderr, "%s: %s\n", s, strerror(errno));
}

FILE *
posix_fopen(const char *path, const char *mode)
{
	if (strchr(mode, 'b') == NULL) {
		char *bin_mode = NULL;
		if (asprintf(&bin_mode, "%sb", mode) == -1)
			return NULL;
		FILE *f = fopen(path, bin_mode);
		free(bin_mode);
		return f;
	}

	return fopen(path, mode);
}

int
posix_rename(const char *oldpath, const char *newpath)
{
	return MoveFileEx(oldpath, newpath, MOVEFILE_REPLACE_EXISTING) ? 0 : -1;
}

static int
wsa_errno(int err)
{
	switch (err) {
	case WSAENOBUFS:
		errno = ENOMEM;
		break;
	case WSAEACCES:
		errno = EACCES;
		break;
	case WSANOTINITIALISED:
		errno = EPERM;
		break;
	case WSAEHOSTUNREACH:
	case WSAENETDOWN:
		errno = EIO;
		break;
	case WSAEFAULT:
		errno = EFAULT;
		break;
	case WSAEINTR:
		errno = EINTR;
		break;
	case WSAEINVAL:
		errno = EINVAL;
		break;
	case WSAEINPROGRESS:
		errno = EINPROGRESS;
		break;
	case WSAEWOULDBLOCK:
		errno = EAGAIN;
		break;
	case WSAEOPNOTSUPP:
		errno = ENOTSUP;
		break;
	case WSAEMSGSIZE:
		errno = EFBIG;
		break;
	case WSAENOTSOCK:
		errno = ENOTSOCK;
		break;
	case WSAENOPROTOOPT:
		errno = ENOPROTOOPT;
		break;
	case WSAECONNREFUSED:
		errno = ECONNREFUSED;
		break;
	case WSAEAFNOSUPPORT:
		errno = EAFNOSUPPORT;
		break;
	case WSAENETRESET:
	case WSAENOTCONN:
	case WSAECONNABORTED:
	case WSAECONNRESET:
	case WSAESHUTDOWN:
	case WSAETIMEDOUT:
		errno = EPIPE;
		break;
	}
	return -1;
}

int
posix_connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
{
	int rc = connect(sockfd, addr, addrlen);
	if (rc == SOCKET_ERROR)
		return wsa_errno(WSAGetLastError());
	return rc;
}

int
posix_close(int fd)
{
	if (closesocket(fd) == SOCKET_ERROR) {
		int err = WSAGetLastError();
		return err == WSAENOTSOCK ?
			close(fd) : wsa_errno(err);
	}
	return 0;
}

ssize_t
posix_read(int fd, void *buf, size_t count)
{
	ssize_t rc = recv(fd, buf, count, 0);
	if (rc == SOCKET_ERROR) {
		int err = WSAGetLastError();
		return err == WSAENOTSOCK ?
			read(fd, buf, count) : wsa_errno(err);
	}
	return rc;
}

ssize_t
posix_write(int fd, const void *buf, size_t count)
{
	ssize_t rc = send(fd, buf, count, 0);
	if (rc == SOCKET_ERROR) {
		int err = WSAGetLastError();
		return err == WSAENOTSOCK ?
			write(fd, buf, count) : wsa_errno(err);
	}
	return rc;
}

int
posix_getsockopt(int sockfd, int level, int optname,
	void *optval, socklen_t *optlen)
{
	int rc = getsockopt(sockfd, level, optname, (char *)optval, optlen);
	return rc == 0 ? 0 : wsa_errno(WSAGetLastError());

}

int
posix_setsockopt(int sockfd, int level, int optname,
	const void *optval, socklen_t optlen)
{
	int rc = setsockopt(sockfd, level, optname, (char *)optval, optlen);
	return rc == 0 ? 0 : wsa_errno(WSAGetLastError());
}
