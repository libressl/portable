+AC_INIT([libressl], m4_esyscmd([tr -d '\n' < VERSION]))
AC_CANONICAL_HOST
AM_INIT_AUTOMAKE([subdir-objects])
AC_CONFIG_MACRO_DIR([m4])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_SUBST([USER_CFLAGS], "-O2 $CFLAGS")
CFLAGS="$CFLAGS -Wall -std=gnu99 -g"

case $host_os in
	*darwin*)
		HOST_OS=darwin;
		LDFLAGS="$LDFLAGS -Qunused-arguments"
		;;
	*linux*)
		HOST_OS=linux;
		CFLAGS="$CFLAGS -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_SOURCE -D_GNU_SOURCE"
		;;
	*solaris*)
		HOST_OS=solaris;
		CFLAGS="$CFLAGS -D__EXTENSIONS__ -D_XOPEN_SOURCE=600 -DBSD_COMP"
		AC_SUBST([PLATFORM_LDADD], ['-lnsl -lsocket'])
		;;
	*openbsd*)
		AC_DEFINE([HAVE_ATTRIBUTE__BOUNDED__], [1], [OpenBSD gcc has bounded])
		;;
	*mingw*)
		HOST_OS=win32
		;;
	*) ;;
esac

AM_CONDITIONAL(HOST_DARWIN, test x$HOST_OS = xdarwin)
AM_CONDITIONAL(HOST_LINUX, test x$HOST_OS = xlinux)
AM_CONDITIONAL(HOST_SOLARIS, test x$HOST_OS = xsolaris)
AM_CONDITIONAL(HOST_WIN, test x$HOST_OS = xwin)

AC_CHECK_FUNC([clock_gettime],,
	[AC_SEARCH_LIBS([clock_gettime],[rt posix4])])

AC_CHECK_FUNC([dl_iterate_phdr],,
	[AC_SEARCH_LIBS([dl_iterate_phdr],[dl])])

AC_PROG_CC
AC_PROG_LIBTOOL
AC_PROG_CC_STDC
AM_PROG_CC_C_O

save_cflags="$CFLAGS"
CFLAGS=-Wno-pointer-sign
AC_MSG_CHECKING([whether CC supports -Wno-pointer-sign])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
	[AC_MSG_RESULT([yes])]
	[AM_CFLAGS=-Wno-pointer-sign],
	[AC_MSG_RESULT([no])]
)
CFLAGS="$save_cflags $AM_CFLAGS"

AC_CHECK_FUNC(strlcpy, 
	AM_CONDITIONAL(NO_STRLCPY, false),
	AC_DEFINE(NO_STRLCPY)
	AM_CONDITIONAL(NO_STRLCPY, true))

AC_CHECK_FUNC(strlcat,
	AM_CONDITIONAL(NO_STRLCAT, false),
	AC_DEFINE(NO_STRLCAT)
	AM_CONDITIONAL(NO_STRLCAT, true))

AC_CHECK_FUNC(strndup,
	AM_CONDITIONAL(NO_STRNDUP, false),
	AC_DEFINE(NO_STRNDUP)
	AM_CONDITIONAL(NO_STRNDUP, true))

AC_CHECK_FUNC(strnlen,
	AM_CONDITIONAL(NO_STRNLEN, false),
	AC_DEFINE(NO_STRNLEN)
	AM_CONDITIONAL(NO_STRNLEN, true))

AC_CHECK_FUNC(asprintf,
	AM_CONDITIONAL(NO_ASPRINTF, false),
	AC_DEFINE(NO_ASPRINTF)
	AM_CONDITIONAL(NO_ASPRINTF, true))

AC_CHECK_FUNC(reallocarray,
	AM_CONDITIONAL(NO_REALLOCARRAY, false),
	AC_DEFINE(NO_REALLOCARRAY)
	AM_CONDITIONAL(NO_REALLOCARRAY, true))

AC_CHECK_FUNC(timingsafe_bcmp,
	AM_CONDITIONAL(NO_TIMINGSAFE_BCMP, false),
	AC_DEFINE(NO_TIMINGSAFE_BCMP)
	AM_CONDITIONAL(NO_TIMINGSAFE_BCMP, true))

AC_CHECK_FUNC(timingsafe_memcmp,
	AM_CONDITIONAL(NO_TIMINGSAFE_MEMCMP, false),
	AC_DEFINE(NO_TIMINGSAFE_MEMCMP)
	AM_CONDITIONAL(NO_TIMINGSAFE_MEMCMP, true))

AC_CHECK_FUNC(arc4random_buf,
	AM_CONDITIONAL(NO_ARC4RANDOM_BUF, false),
	AC_DEFINE(NO_ARC4RANDOM_BUF)
	AM_CONDITIONAL(NO_ARC4RANDOM_BUF, true))

AC_CHECK_FUNC(getentropy,
	AM_CONDITIONAL(NO_GETENTROPY, false),
	AC_DEFINE(NO_GETENTROPY)
	AM_CONDITIONAL(NO_GETENTROPY, true))

AC_CHECK_FUNC(issetugid,
	AM_CONDITIONAL(NO_ISSETUGID, false),
	AC_DEFINE(NO_ISSETUGID)
	AM_CONDITIONAL(NO_ISSETUGID, true))

AC_CHECK_FUNC(strtonum,
	AM_CONDITIONAL(NO_STRTONUM, false),
	AC_DEFINE(NO_STRTONUM)
	AM_CONDITIONAL(NO_STRTONUM, true))

AC_CHECK_FUNC(explicit_bzero,
	AM_CONDITIONAL(NO_EXPLICIT_BZERO, false),
	AC_DEFINE(NO_EXPLICIT_BZERO)
	AM_CONDITIONAL(NO_EXPLICIT_BZERO, true))

AC_CACHE_CHECK([whether va_copy exists], ac_cv_have_va_copy, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <stdarg.h>
va_list x,y;
		]], [[ va_copy(x,y); ]])],
	[ ac_cv_have_va_copy="yes" ],
	[ ac_cv_have_va_copy="no"
	])
])
if test "x$ac_cv_have_va_copy" = "xyes" ; then
	AC_DEFINE([HAVE_VA_COPY], [1], [Define if va_copy exists])
fi

AC_CACHE_CHECK([whether __va_copy exists], ac_cv_have___va_copy, [
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <stdarg.h>
va_list x,y;
		]], [[ __va_copy(x,y); ]])],
	[ ac_cv_have___va_copy="yes" ], [ ac_cv_have___va_copy="no"
	])
])
if test "x$ac_cv_have___va_copy" = "xyes" ; then
	AC_DEFINE([HAVE___VA_COPY], [1], [Define if __va_copy exists])
fi

AC_CHECK_FUNC(getauxval, AC_DEFINE(HAVE_GETAUXVAL))

AC_CHECK_FUNC(funopen, AC_DEFINE(HAVE_FUNOPEN))

AC_CHECK_HEADER(sys/sysctl.h, AC_DEFINE(HAVE_SYS_SYSCTL_H))

AC_CHECK_HEADER(err.h, AC_DEFINE(HAVE_ERR_H))

AC_ARG_WITH([openssldir],
	AS_HELP_STRING([--with-openssldir], [Set the default openssl directory]),
	AC_DEFINE_UNQUOTED(OPENSSLDIR, "$withval")
)

AC_ARG_WITH([enginesdir],
	AS_HELP_STRING([--with-enginesdir], [Set the default engines directory (use with openssldir)]),
	AC_DEFINE_UNQUOTED(ENGINESDIR, "$withval")
)

AC_ARG_ENABLE([asm],
	AS_HELP_STRING([--disable-asm], [Disable assembly]))
AS_IF([test "x$enable_asm" = "xno"], [CFLAGS="$CFLAGS -DOPENSSL_NO_ASM"])

LT_INIT

AC_CONFIG_FILES([
	Makefile
	include/Makefile
	include/openssl/Makefile
	ssl/Makefile
	crypto/Makefile
	tests/Makefile
	apps/Makefile
	man/Makefile
	libcrypto.pc
	libssl.pc
	openssl.pc
])

AC_OUTPUT
