/*
 * Public domain
 * syslog.h compatibility shim
 */

#ifndef LIBCRYPTOCOMPAT_SYSLOG_H
#define LIBCRYPTOCOMPAT_SYSLOG_H

#ifndef _WIN32
#include_next <syslog.h>
#else

/* priorities */
#define LOG_EMERG 0
#define LOG_ALERT 1
#define LOG_CRIT 2
#define LOG_ERR 3
#define LOG_WARNING 4
#define LOG_NOTICE 5
#define LOG_INFO 6
#define LOG_DEBUG 7

/* facility codes */
#define LOG_KERN (0<<3)
#define LOG_USER (1<<3)
#define LOG_DAEMON (3<<3)

/* flags for openlog */
#define LOG_PID 0x01
#define LOG_CONS 0x02

extern void openlog(const char *ident, int option, int facility);
extern void syslog(int priority, const char *fmt, ...)
	__attribute__ ((__format__ (__printf__, 2, 3)));
extern void closelog (void);
#endif

#endif /* LIBCRYPTOCOMPAT_SYSLOG_H */
