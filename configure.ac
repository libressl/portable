AC_INIT([libressl], m4_esyscmd([tr -d '\n' < VERSION]))
AC_SUBST([LIBCRYPTO_VERSION], m4_esyscmd([tr -d '\n' < crypto/VERSION]))
AC_SUBST([LIBSSL_VERSION], m4_esyscmd([tr -d '\n' < ssl/VERSION]))
AC_SUBST([LIBTLS_VERSION], m4_esyscmd([tr -d '\n' < tls/VERSION]))

AC_CANONICAL_HOST
AM_INIT_AUTOMAKE([subdir-objects])
AC_CONFIG_MACRO_DIR([m4])

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_SUBST([USER_CFLAGS], "$CFLAGS")
CFLAGS="-Wall -std=gnu99 -g -O2"

case $host_os in
	*darwin*)
		HOST_OS=darwin
		HOST_ABI=macosx
		;;
	*freebsd*)
		HOST_OS=freebsd
		HOST_ABI=elf
		AC_SUBST([PROG_LDADD], ['-lthr'])
		;;
	*hpux*)
		HOST_OS=hpux;
		CFLAGS="$CFLAGS -mlp64 -D_XOPEN_SOURCE=600 -D__STRICT_ALIGNMENT"
		AC_SUBST([PLATFORM_LDADD], ['-lpthread'])
		;;
	*linux*)
		HOST_OS=linux
		HOST_ABI=elf
		CFLAGS="$CFLAGS -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_POSIX_SOURCE -D_GNU_SOURCE"
		;;
	*netbsd*)
		HOST_OS=netbsd
		;;
	*openbsd*)
		HOST_ABI=elf
		AC_DEFINE([HAVE_ATTRIBUTE__BOUNDED__], [1], [OpenBSD gcc has bounded])
		;;
	*mingw*)
		HOST_OS=win
		CFLAGS="$CFLAGS -D_GNU_SOURCE -D_POSIX -D_POSIX_SOURCE -D_REENTRANT -D_POSIX_THREAD_SAFE_FUNCTIONS -DWIN32_LEAN_AND_MEAN -D_WIN32_WINNT=0x0600 -DOPENSSL_NO_SPEED -DNO_SYSLOG -D__USE_MINGW_ANSI_STDIO -static-libgcc"
		LDFLAGS="$LDFLAGS -static-libgcc"
		AC_SUBST([PLATFORM_LDADD], ['-lws2_32'])
		;;
	*solaris*)
		HOST_OS=solaris
		HOST_ABI=elf
		CFLAGS="$CFLAGS -D__EXTENSIONS__ -D_XOPEN_SOURCE=600 -DBSD_COMP"
		AC_SUBST([PLATFORM_LDADD], ['-lnsl -lsocket'])
		;;
	*) ;;
esac

AM_CONDITIONAL([HOST_DARWIN],  [test x$HOST_OS = xdarwin])
AM_CONDITIONAL([HOST_FREEBSD], [test x$HOST_OS = xfreebsd])
AM_CONDITIONAL([HOST_HPUX],    [test x$HOST_OS = xhpux])
AM_CONDITIONAL([HOST_LINUX],   [test x$HOST_OS = xlinux])
AM_CONDITIONAL([HOST_NETBSD],  [test x$HOST_OS = xnetbsd])
AM_CONDITIONAL([HOST_SOLARIS], [test x$HOST_OS = xsolaris])
AM_CONDITIONAL([HOST_WIN],     [test x$HOST_OS = xwin])

AC_CHECK_FUNC([clock_gettime],,
	[AC_SEARCH_LIBS([clock_gettime],[rt posix4])])

AC_CHECK_FUNC([dl_iterate_phdr],,
	[AC_SEARCH_LIBS([dl_iterate_phdr],[dl])])

AC_PROG_CC
AC_PROG_LIBTOOL
AC_PROG_CC_STDC
AM_PROG_CC_C_O

AC_MSG_CHECKING([if compiling with clang])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [[
#ifndef __clang__
	not clang
#endif
	]])],
	[CLANG=yes],
	[CLANG=no]
)
AC_MSG_RESULT([$CLANG])
AS_IF([test "x$CLANG" = "xyes"], [CLANG_FLAGS=-Qunused-arguments])

# We want to check for compiler flag support. Prior to clang v5.1, there was no
# way to make clang's "argument unused" warning fatal.  So we invoke the
# compiler through a wrapper script that greps for this message.
saved_CC="$CC"
saved_LD="$LD"
flag_wrap="$srcdir/scripts/wrap-compiler-for-flag-check"
CC="$flag_wrap $CC"
LD="$flag_wrap $LD"

AC_ARG_ENABLE([hardening],
	[AS_HELP_STRING([--disable-hardening],
			[Disable options to frustrate memory corruption exploits])],
	[], [enable_hardening=yes])

AC_ARG_ENABLE([windows-ssp],
	[AS_HELP_STRING([--enable-windows-ssp],
			[Enable building the stack smashing protection on
			 Windows. This currently distributing libssp-0.dll.])])

AC_DEFUN([CHECK_CFLAG], [
	 AC_LANG_ASSERT(C)
	 AC_MSG_CHECKING([if $saved_CC supports "$1"])
	 old_cflags="$CFLAGS"
	 CFLAGS="$1 -Wall -Werror"
	 AC_TRY_LINK([
		      #include <stdio.h>
		      ],
		     [printf("Hello")],
		     AC_MSG_RESULT([yes])
		     CFLAGS=$old_cflags
		     HARDEN_CFLAGS="$HARDEN_CFLAGS $1",
		     AC_MSG_RESULT([no])
		     CFLAGS=$old_cflags
		     [$2])
])

AC_DEFUN([CHECK_LDFLAG], [
	 AC_LANG_ASSERT(C)
	 AC_MSG_CHECKING([if $saved_LD supports "$1"])
	 old_ldflags="$LDFLAGS"
	 LDFLAGS="$1 -Wall -Werror"
	 AC_TRY_LINK([
		      #include <stdio.h>
		      ],
		     [printf("Hello")],
		     AC_MSG_RESULT([yes])
		     LDFLAGS=$old_ldflags
		     HARDEN_LDFLAGS="$HARDEN_LDFLAGS $1",
		     AC_MSG_RESULT([no])
		     LDFLAGS=$old_ldflags
		     [$2])
])

AS_IF([test "x$enable_hardening" = "xyes"], [
	# Tell GCC to NOT optimize based on signed arithmetic overflow
	CHECK_CFLAG([[-fno-strict-overflow]])

	# _FORTIFY_SOURCE replaces builtin functions with safer versions.
	CHECK_CFLAG([[-D_FORTIFY_SOURCE=2]])

	# Enable read only relocations
	CHECK_LDFLAG([[-Wl,-z,relro]])
	CHECK_LDFLAG([[-Wl,-z,now]])

	# Windows security flags
	AS_IF([test "x$HOST_OS" = "xwin"], [
		CHECK_LDFLAG([[-Wl,--nxcompat]])
		CHECK_LDFLAG([[-Wl,--dynamicbase]])
		CHECK_LDFLAG([[-Wl,--high-entropy-va]])
	])

	# Use stack-protector-strong if available; if not, fallback to
	# stack-protector-all which is considered to be overkill
	AS_IF([test "x$enable_windows_ssp" = "xyes" -o "x$HOST_OS" != "xwin"], [
		CHECK_CFLAG([[-fstack-protector-strong]],
			CHECK_CFLAG([[-fstack-protector-all]],
				AC_MSG_WARN([compiler does not appear to support stack protection])
			)
		)
		AS_IF([test "x$HOST_OS" = "xwin"], [
			AC_SEARCH_LIBS([__stack_chk_guard],[ssp])
		])
	])
])


# Restore CC, LD
CC="$saved_CC"
LD="$saved_LD"

CFLAGS="$CFLAGS $HARDEN_CFLAGS"
LDFLAGS="$LDFLAGS $HARDEN_LDFLAGS"

# Removing the dependency on -Wno-pointer-sign should be a goal
save_cflags="$CFLAGS"
CFLAGS=-Wno-pointer-sign
AC_MSG_CHECKING([whether CC supports -Wno-pointer-sign])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
	[AC_MSG_RESULT([yes])]
	[AM_CFLAGS=-Wno-pointer-sign],
	[AC_MSG_RESULT([no])]
)
CFLAGS="$save_cflags $AM_CFLAGS"

save_cflags="$CFLAGS"
CFLAGS=
AC_MSG_CHECKING([whether AS supports .note.GNU-stack])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
__asm__(".section .note.GNU-stack,\"\",@progbits");]])],
	[AC_MSG_RESULT([yes])]
	[AM_CFLAGS=-DHAVE_GNU_STACK],
	[AC_MSG_RESULT([no])]
)
CFLAGS="$save_cflags $AM_CFLAGS"
AM_PROG_AS

CFLAGS="$CFLAGS $CLANG_CFLAGS"
LDFLAGS="$LDFLAGS $CLANG_FLAGS"

AC_CHECK_FUNCS([arc4random_buf asprintf explicit_bzero funopen getauxval])
AC_CHECK_FUNCS([getentropy issetugid memmem poll reallocarray])
AC_CHECK_FUNCS([strlcat strlcpy strndup strnlen strsep strtonum])
AC_CHECK_FUNCS([symlink])
AC_CHECK_FUNCS([timingsafe_bcmp timingsafe_memcmp])

# Share test results with automake
AM_CONDITIONAL([HAVE_ARC4RANDOM_BUF], [test "x$ac_cv_func_arc4random_buf" = xyes])
AM_CONDITIONAL([HAVE_ASPRINTF], [test "x$ac_cv_func_asprintf" = xyes])
AM_CONDITIONAL([HAVE_EXPLICIT_BZERO], [test "x$ac_cv_func_explicit_bzero" = xyes])
AM_CONDITIONAL([HAVE_GETENTROPY], [test "x$ac_cv_func_getentropy" = xyes])
AM_CONDITIONAL([HAVE_ISSETUGID], [test "x$ac_cv_func_issetugid" = xyes])
AM_CONDITIONAL([HAVE_MEMMEM], [test "x$ac_cv_func_memmem" = xyes])
AM_CONDITIONAL([HAVE_POLL], [test "x$ac_cv_func_poll" = xyes])
AM_CONDITIONAL([HAVE_REALLOCARRAY], [test "x$ac_cv_func_reallocarray" = xyes])
AM_CONDITIONAL([HAVE_STRLCAT], [test "x$ac_cv_func_strlcat" = xyes])
AM_CONDITIONAL([HAVE_STRLCPY], [test "x$ac_cv_func_strlcpy" = xyes])
AM_CONDITIONAL([HAVE_STRNDUP], [test "x$ac_cv_func_strndup" = xyes])
AM_CONDITIONAL([HAVE_STRNLEN], [test "x$ac_cv_func_strnlen" = xyes])
AM_CONDITIONAL([HAVE_STRSEP], [test "x$ac_cv_func_strsep" = xyes])
AM_CONDITIONAL([HAVE_STRTONUM], [test "x$ac_cv_func_strtonum" = xyes])
AM_CONDITIONAL([HAVE_TIMINGSAFE_BCMP], [test "x$ac_cv_func_timingsafe_bcmp" = xyes])
AM_CONDITIONAL([HAVE_TIMINGSAFE_MEMCMP], [test "x$ac_cv_func_timingsafe_memcmp" = xyes])
AM_CONDITIONAL([BUILD_CERTHASH], [test "x$ac_cv_func_symlink" = xyes])

# overrides for arc4random_buf implementations with known issues
AM_CONDITIONAL([HAVE_ARC4RANDOM_BUF],
	[test "x$HOST_OS" != xdarwin \
	   -a "x$HOST_OS" != xfreebsd \
	   -a "x$HOST_OS" != xnetbsd \
	   -a "x$ac_cv_func_arc4random_buf" = xyes])

# overrides for issetugid implementations with known issues
AM_CONDITIONAL([HAVE_ISSETUGID],
       [test "x$HOST_OS" != xdarwin \
	  -a "x$ac_cv_func_issetugid" = xyes])

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

AC_CHECK_HEADERS([sys/sysctl.h err.h])

AC_ARG_WITH([openssldir],
	AS_HELP_STRING([--with-openssldir],
		       [Set the default openssl directory]),
	AC_DEFINE_UNQUOTED(OPENSSLDIR, "$withval")
)

AC_ARG_WITH([enginesdir],
	AS_HELP_STRING([--with-enginesdir],
		       [Set the default engines directory (use with openssldir)]),
	AC_DEFINE_UNQUOTED(ENGINESDIR, "$withval")
)

AC_ARG_ENABLE([asm],
	AS_HELP_STRING([--disable-asm], [Disable assembly]))
AM_CONDITIONAL([OPENSSL_NO_ASM], [test "x$enable_asm" = "xno"])

old_cflags=$CFLAGS
CFLAGS="$USER_CFLAGS -I$srcdir/include"
AC_MSG_CHECKING([if BSWAP4 builds without __STRICT_ALIGNMENT])
AC_TRY_COMPILE([#include "$srcdir/crypto/modes/modes_lcl.h"],
	       [int a = 0; BSWAP4(a);],
	       AC_MSG_RESULT([yes])
	       BSWAP4=yes,
	       AC_MSG_RESULT([no])
	       BSWAP4=no)
CFLAGS="$old_cflags"

case $host_cpu in
	*sparc*)
		CFLAGS="$CFLAGS -D__STRICT_ALIGNMENT"
		;;
	*arm*)
		AS_IF([test "x$BSWAP4" = "xyes"],,
		    CFLAGS="$CFLAGS -D__STRICT_ALIGNMENT")
		;;
esac

AM_CONDITIONAL([HOST_ASM_ELF_X86_64],
    [test "x$HOST_ABI" = "xelf" -a "$host_cpu" = "x86_64" -a "x$enable_asm" != "xno"])
AM_CONDITIONAL([HOST_ASM_MACOSX_X86_64],
    [test "x$HOST_ABI" = "xmacosx" -a "$host_cpu" = "x86_64" -a "x$enable_asm" != "xno"])

LT_INIT

AC_CONFIG_FILES([
	Makefile
	include/Makefile
	include/openssl/Makefile
	crypto/Makefile
	ssl/Makefile
	tls/Makefile
	tests/Makefile
	apps/Makefile
	man/Makefile
	libcrypto.pc
	libssl.pc
	libtls.pc
	openssl.pc
])

AC_OUTPUT
