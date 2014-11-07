#include <ws2tcpip.h>

#include <stdarg.h>
#include <stdio.h>
#include <syslog.h>

static HANDLE event_source = NULL;

void openlog(const char *ident, int option, int facility)
{
	HANDLE handle = RegisterEventSourceA(NULL, (ident == NULL || ident[0] == '\0') ? "syslog" : ident);
	if (handle != NULL) {
		if (InterlockedCompareExchangePointer(&event_source, handle, NULL) != NULL)
			DeregisterEventSource(handle);
	}

	/* unused parameters */
	(void) option;
	(void) facility;
}

void syslog(int priority, const char *format, ...)
{
	int n;
	va_list ap;
	char *str = NULL;

	if (event_source == NULL)
		openlog("syslog", 0, LOG_USER);

	if (event_source == NULL)
		return;

	va_start(ap, format);
	n = vasprintf(&str, format, ap);
	va_end(ap);

	if (n > 0 && event_source != NULL) {
		const char *event_arg[1];
		int level = (priority == LOG_WARNING) ? EVENTLOG_WARNING_TYPE :
			(priority <= LOG_ERR) ? EVENTLOG_ERROR_TYPE : EVENTLOG_INFORMATION_TYPE;

		event_arg[0] = str;
		ReportEventA(event_source, (WORD) level, 0, 0, NULL, 1, 0, event_arg, NULL);
	}

	if (n > 0)
		free(str);
}

void closelog (void)
{
	if (event_source != NULL) {
		DeregisterEventSource(event_source);
		event_source = NULL;
	}
}
