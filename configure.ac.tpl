AC_INIT([libressl], [VERSION])
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([subdir-objects])
AC_CONFIG_MACRO_DIR([m4])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_SUBST([USER_CFLAGS], "-O2 $CFLAGS")
CFLAGS="$CFLAGS -Wall -std=c99 -g"

case $target_os in
	*darwin*)
		TARGET_OS=darwin;
		LDFLAGS="$LDFLAGS -Qunused-arguments"
		;;
	*linux*)
		TARGET_OS=linux;
		CFLAGS="$CFLAGS -D_BSD_SOURCE -D_POSIX_SOURCE -D_GNU_SOURCE"
		;;
	*solaris*)
		TARGET_OS=solaris;
		CFLAGS="$CFLAGS -D__EXTENSIONS__ -D_XOPEN_SOURCE=600 -DBSD_COMP"
		AC_SUBST([PLATFORM_LDADD], ['-lnsl -lsocket'])
		;;
	*openbsd*)
		AC_DEFINE([HAVE_ATTRIBUTE__BOUNDED__], [1], [OpenBSD gcc has bounded])
		;;
	*) ;;
esac

AM_CONDITIONAL(TARGET_DARWIN, test x$TARGET_OS = xdarwin)
AM_CONDITIONAL(TARGET_LINUX, test x$TARGET_OS = xlinux)
AM_CONDITIONAL(TARGET_SOLARIS, test x$TARGET_OS = xsolaris)

AC_CHECK_FUNC([clock_gettime],,
	[AC_SEARCH_LIBS([clock_gettime],[rt posix4])])

AC_PROG_CC
AC_PROG_LIBTOOL
AC_PROG_CC_STDC
AM_PROG_CC_C_O

AC_CHECK_FUNC(strlcpy,[AC_SEARCH_LIBS(strlcpy,, [NO_STRLCPY=],
			  [NO_STRLCPY=yes])], [NO_STRLCPY=yes])
AC_SUBST(NO_STRLCPY)
AM_CONDITIONAL(NO_STRLCPY, test "x$NO_STRLCPY" = "xyes")

AC_CHECK_FUNC(strlcat,[AC_SEARCH_LIBS(strlcat,, [NO_STRLCAT=],
			  [NO_STRLCAT=yes])], [NO_STRLCAT=yes])
AC_SUBST(NO_STRLCAT)
AM_CONDITIONAL(NO_STRLCAT, test "x$NO_STRLCAT" = "xyes")

AC_CHECK_FUNC(reallocarray,[AC_SEARCH_LIBS(reallocarray,, [NO_REALLOCARRAY=],
			  [NO_REALLOCARRAY=yes])], [NO_REALLOCARRAY=yes])
AC_SUBST(NO_REALLOCARRAY)
AM_CONDITIONAL(NO_REALLOCARRAY, test "x$NO_REALLOCARRAY" = "xyes")

AC_CHECK_FUNC(timingsafe_bcmp,[AC_SEARCH_LIBS(timingsafe_bcmp,, [NO_TIMINGSAFE_BCMP=],
			  [NO_TIMINGSAFE_BCMP=yes])], [NO_TIMINGSAFE_BCMP=yes])
AC_SUBST(NO_TIMINGSAFE_BCMP)
AM_CONDITIONAL(NO_TIMINGSAFE_BCMP, test "x$NO_TIMINGSAFE_BCMP" = "xyes")

AC_CHECK_FUNC(timingsafe_memcmp,[AC_SEARCH_LIBS(timingsafe_memcmp,, [NO_TIMINGSAFE_MEMCMP=],
			  [NO_TIMINGSAFE_MEMCMP=yes])], [NO_TIMINGSAFE_MEMCMP=yes])
AC_SUBST(NO_TIMINGSAFE_MEMCMP)
AM_CONDITIONAL(NO_TIMINGSAFE_MEMCMP, test "x$NO_TIMINGSAFE_MEMCMP" = "xyes")

AC_CHECK_FUNC(arc4random_buf,[AC_SEARCH_LIBS(write,, [NO_ARC4RANDOM_BUF=],
			  [NO_ARC4RANDOM_BUF=yes])], [NO_ARC4RANDOM_BUF=yes])
AC_SUBST(NO_ARC4RANDOM_BUF)
AM_CONDITIONAL(NO_ARC4RANDOM_BUF, test "x$NO_ARC4RANDOM_BUF" = "xyes")

# overrides for arc4random_buf implementations with known issues
AM_CONDITIONAL(NO_ARC4RANDOM_BUF,
   test x$TARGET_OS = xdarwin \
     -o x$TARGET_OS = xsolaris \
	 -o x$NO_ARC4RANDOM_BUF = xyes)

AC_CHECK_FUNC(getentropy,[AC_SEARCH_LIBS(write,, [NO_GETENTROPY=],
			  [NO_GETENTROPY=yes])], [NO_GETENTROPY=yes])
AC_SUBST(NO_GETENTROPY)
AM_CONDITIONAL(NO_GETENTROPY, test "x$NO_GETENTROPY" = "xyes")

AC_CHECK_FUNC(issetugid,[AC_SEARCH_LIBS(write,, [NO_ISSETUGID=],
			  [NO_ISSETUGID=yes])], [NO_ISSETUGID=yes])
AC_SUBST(NO_ISSETUGID)
AM_CONDITIONAL(NO_ISSETUGID, test "x$NO_ISSETUGID" = "xyes")

AC_CHECK_FUNC(strtonum,[AC_SEARCH_LIBS(write,, [NO_STRTONUM=],
			  [NO_STRTONUM=yes])], [NO_STRTONUM=yes])
AC_SUBST(NO_STRTONUM)
AM_CONDITIONAL(NO_STRTONUM, test "x$NO_STRTONUM" = "xyes")

AC_CHECK_FUNC(getauxval, AC_DEFINE(HAVE_GETAUXVAL))

AC_CHECK_FUNC(funopen, AC_DEFINE(HAVE_FUNOPEN))

AC_CHECK_HEADER(sys/sysctl.h, AC_DEFINE(HAVE_SYS_SYSCTL_H))

AC_ARG_WITH([openssldir],
	AS_HELP_STRING([--with-openssldir], [Set the default openssl directory]),
	AC_DEFINE_UNQUOTED(OPENSSLDIR, "$withval")
)

AC_ARG_WITH([enginesdir],
	AS_HELP_STRING([--with-enginesdir], [Set the default engines directory (use with openssldir)]),
	AC_DEFINE_UNQUOTED(ENGINESDIR, "$withval")
)

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
