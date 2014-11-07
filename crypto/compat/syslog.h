#ifndef LIBCRYPTOCOMPAT_SYSLOG_H
#define LIBCRYPTOCOMPAT_SYSLOG_H

/* priorities */
#define LOG_EMERG   0
#define LOG_ALERT   1
#define LOG_CRIT    2
#define LOG_ERR     3
#define LOG_WARNING 4
#define LOG_NOTICE  5
#define LOG_INFO    6
#define LOG_DEBUG   7

/* facility codes */
#define LOG_KERN    (0<<3)
#define LOG_USER    (1<<3)
#define LOG_DAEMON  (3<<3)

/* flags for openlog */
#define LOG_PID     0x01
#define LOG_CONS    0x02

#ifdef __cplusplus
extern "C" {
#endif

extern void openlog(const char *ident, int option, int facility);
extern void syslog(int priority, const char *format, ...)
        __attribute__ ((__format__ (__printf__, 2, 3)));
extern void closelog (void);

#ifdef __cplusplus
}
#endif

#endif /* LIBCRYPTOCOMPAT_SYSLOG_H */
