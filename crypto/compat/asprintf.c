#ifndef HAVE_ASPRINTF

#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef VA_COPY
# if defined(va_copy) || defined(HAVE_VA_COPY)
#  define VA_COPY(dest, src) va_copy(dest, src)
# elif defined(__va_copy) || defined(HAVE___VA_COPY)
#  define VA_COPY(dest, src) __va_copy(dest, src)
# else
#  define VA_COPY(dest, src) (dest) = (src)
# endif
#endif

#define INIT_BUF_SIZE	128
#define MAX_BUF_SIZE	65536

int
vasprintf(char **str, const char *fmt, va_list ap)
{
	char *rs;
	int rc, len;
	va_list ap2;

	if (str == NULL || fmt == NULL) {
		errno = EINVAL;
		if (str != NULL)
			*str = NULL;
		return -1;
	}

	len = INIT_BUF_SIZE;
	while (1)
	{
		if ((rs = (char *) malloc(len)) == NULL)
		{
			*str = NULL;
			return -1;
		}

		VA_COPY(ap2, ap);
		rc = vsnprintf(rs, len, fmt, ap2);
		va_end(ap2);

		if (rc >= 0 && rc < len) { /* succeeded */
			*str = rs;
			return rc;
		}

		free(rs);

		/* Windows return -1 indicating that output has been truncated */
		/* The others return value of size or more means that the output was truncated. */
		len = rc > 0 ? rc + 1 : len << 1;
		if (len < INIT_BUF_SIZE || len > MAX_BUF_SIZE) { /* Bad length */
			errno = ENOMEM;
			*str = NULL;
			return -1;
		}
	}
}

int asprintf(char **str, const char *fmt, ...)
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vasprintf(str, fmt, ap);
	va_end(ap);

	return rc;
}
#endif
