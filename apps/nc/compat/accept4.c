#include <sys/socket.h>
#include <fcntl.h>

int
accept4(int s, struct sockaddr *addr, socklen_t *addrlen, int flags)
{
	int rets = accept(s, addr, addrlen);
	int fl;
	if (rets == -1)
		return rets;

	if (flags & SOCK_CLOEXEC) {
		fl = fcntl(rets, F_GETFD);
		fcntl(rets, F_SETFD, fl | FD_CLOEXEC);
	}

	if (flags & SOCK_NONBLOCK) {
		fl = fcntl(rets, F_GETFL);
		fcntl(rets, F_SETFL, fl | O_NONBLOCK);
	}

	return rets;
}
