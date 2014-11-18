#include <ws2tcpip.h>

#include <errno.h>
#include <poll.h>

static int compute_revents (int fd, short events, fd_set *rfds, fd_set *wfds, fd_set *efds)
{
	short rc = 0;

	if (FD_ISSET(fd, efds))
		return POLLERR;

	if ((events & (POLLIN | POLLRDNORM | POLLRDBAND)) && FD_ISSET(fd, rfds))
		rc |= POLLIN;

	if ((events & (POLLOUT | POLLWRNORM | POLLWRBAND)) && FD_ISSET(fd, wfds))
		rc |= POLLOUT;

	return rc;
}

/* Just select(2) wrapper, ignored unsupported flags. */
int poll(struct pollfd *pfds, nfds_t nfds, int timeout)
{
	int i, rc;
	fd_set rfds, wfds, efds;
	struct timeval tv;
	struct timeval *ptv;

	if (pfds == NULL || nfds > FD_SETSIZE)
	{
		errno = EINVAL;
		return -1;
	}

	if (timeout < 0)
	{
		ptv = NULL;
	} else {
		ptv = &tv;
		ptv->tv_sec = timeout / 1000;
		ptv->tv_usec = (timeout % 1000) * 1000;
	}

	FD_ZERO (&rfds);
	FD_ZERO (&wfds);
	FD_ZERO (&efds);

	for (i = 0; i < (int) nfds; i++)
	{
		if (pfds[i].fd < 0)
			continue;

		FD_SET (pfds[i].fd, &efds);

		if (pfds[i].events & (POLLIN | POLLRDNORM | POLLRDBAND))
			FD_SET (pfds[i].fd, &rfds);

		if (pfds[i].events & (POLLOUT | POLLWRNORM | POLLWRBAND))
			FD_SET (pfds[i].fd, &wfds);
	}

	/* Winsock ignore the first parameter. */
	rc = select (0, &rfds, &wfds, &efds, ptv);
	if (rc < 0) {
		errno  = WSAGetLastError();
		return rc;
	}

	rc = 0;
	for (i = 0; i < (int) nfds; i++)
	{
		pfds[i].revents = 0;

		if (pfds[i].fd < 0)
			continue;

		pfds[i].revents = compute_revents (pfds[i].fd, pfds[i].events,
			&rfds, &wfds, &efds);

		if (pfds[i].revents)
			rc++;
	}

	return rc;
}
