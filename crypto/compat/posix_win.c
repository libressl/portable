/*
 * Public domain
 *
 * BSD socket emulation code for Winsock2
 * File IO compatibility shims
 * Brent Cook <bcook@openbsd.org>
 * Kinichiro Inoguchi <inoguchi@openbsd.org>
 */

#define NO_REDEF_POSIX_FUNCTIONS

#include <sys/time.h>

#include <ws2tcpip.h>
#include <windows.h>

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>

static int
is_socket(int fd)
{
	// Border case: Don't break std* file descriptors
	if (fd < 3)
		return 0;

	// All locally-allocated file descriptors will have the high bit set
	return (fd & 0x80000000) == 0;
}

static int
get_real_fd(int fd)
{
	return (fd & 0x7fffffff);
}

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
libressl_fstat(int fd, struct stat *statbuf)
{
	return fstat(get_real_fd(fd), statbuf);
}

int
posix_open(const char *path, ...)
{
	va_list ap;
	int mode = 0;
	int flags;

	va_start(ap, path);
	flags = va_arg(ap, int);
	if (flags & O_CREAT)
		mode = va_arg(ap, int);
	va_end(ap);

	flags |= O_BINARY;
	if (flags & O_CLOEXEC) {
		flags &= ~O_CLOEXEC;
		flags |= O_NOINHERIT;
	}
	flags &= ~O_NONBLOCK;

	const int fh = open(path, flags, mode);

	// Set high bit to mark file descriptor as a file handle
	return fh + 0x80000000;
}

char *
posix_fgets(char *s, int size, FILE *stream)
{
	char *ret = fgets(s, size, stream);
	if (ret != NULL) {
		size_t end = strlen(ret);
		if (end >= 2 && ret[end - 2] == '\r' && ret[end - 1] == '\n') {
			ret[end - 2] = '\n';
			ret[end - 1] = '\0';
		}
	}
	return ret;
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
	case WSAEBADF:
		errno = EBADF;
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
	int rc;
	if (is_socket(fd)) {
		if ((rc = closesocket(fd)) == SOCKET_ERROR) {
			int err = WSAGetLastError();
			rc = wsa_errno(err);
		}
	} else {
		rc = close(get_real_fd(fd));
	}
	return rc;
}

ssize_t
posix_read(int fd, void *buf, size_t count)
{
	ssize_t rc;
	if (is_socket(fd)) {
		if ((rc = recv(fd, buf, count, 0)) == SOCKET_ERROR) {
			int err = WSAGetLastError();
			rc = wsa_errno(err);
		}
	} else {
		rc = read(get_real_fd(fd), buf, count);
	}
	return rc;
}

ssize_t
posix_write(int fd, const void *buf, size_t count)
{
	ssize_t rc;
	if (is_socket(fd)) {
		if ((rc = send(fd, buf, count, 0)) == SOCKET_ERROR) {
			rc = wsa_errno(WSAGetLastError());
		}
	} else {
		rc = write(get_real_fd(fd), buf, count);
	}
	return rc;
}

int
posix_getsockopt(int sockfd, int level, int optname,
	void *optval, socklen_t *optlen)
{
	int rc;
	if (is_socket(sockfd)) {
		rc = getsockopt(sockfd, level, optname, (char *)optval, optlen);
		if (rc != 0) {
			rc = wsa_errno(WSAGetLastError());
		}
	} else {
		rc = -1;
	}
	return rc;
}

int
posix_setsockopt(int sockfd, int level, int optname,
	const void *optval, socklen_t optlen)
{
	int rc;
	if (is_socket(sockfd)) {
		rc = setsockopt(sockfd, level, optname, (char *)optval, optlen);
		if (rc != 0) {
			rc = wsa_errno(WSAGetLastError());
		}
	} else {
		rc = -1;
	}
	return rc;
}

uid_t getuid(void)
{
	/* Windows fstat sets 0 as st_uid */
	return 0;
}

#ifdef _MSC_VER
struct timezone;
int gettimeofday(struct timeval *tp, void *tzp)
{
	/*
	 * Note: some broken versions only have 8 trailing zero's, the correct
	 * epoch has 9 trailing zero's
	 */
	static const uint64_t EPOCH = ((uint64_t) 116444736000000000ULL);

	SYSTEMTIME  system_time;
	FILETIME    file_time;
	uint64_t    time;

	GetSystemTime(&system_time);
	SystemTimeToFileTime(&system_time, &file_time);
	time = ((uint64_t)file_time.dwLowDateTime);
	time += ((uint64_t)file_time.dwHighDateTime) << 32;

	tp->tv_sec = (long long)((time - EPOCH) / 10000000L);
	tp->tv_usec = (long)(system_time.wMilliseconds * 1000);
	return 0;
}
#endif
