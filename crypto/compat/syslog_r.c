#include <stdio.h>
#include <stdlib.h>
#include <syslog.h>

void
syslog_r(int pri, struct syslog_data *data, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    vsyslog_r(pri, data, fmt, ap);
    va_end(ap);
}

void
vsyslog_r(int pri, struct syslog_data *data, const char *fmt, va_list ap)
{
#ifdef HAVE_SYSLOG
#ifdef HAVE_VSYSLOG
	vsyslog(pri, fmt, ap);
#else
	char *msg = NULL;

	if (vasprintf(&msg, fmt, ap) == -1)
		return;
	syslog(pri, "%s", msg);
	free(msg);
#endif
#endif
}
