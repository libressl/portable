#!/bin/sh
set -e

openbsd_branch=`cat OPENBSD_BRANCH`

# pull in latest upstream code
echo "pulling upstream openbsd source"
if [ ! -d openbsd ]; then
	if [ -z "$LIBRESSL_GIT" ]; then
		git clone https://github.com/libressl-portable/openbsd.git
	else
		git clone $LIBRESSL_GIT/openbsd
	fi
fi
(cd openbsd
 git checkout $openbsd_branch
 git pull --rebase)

# setup source paths
CWD=`pwd`
libc_src=$CWD/openbsd/src/lib/libc
libc_regress=$CWD/openbsd/src/regress/lib/libc
libcrypto_src=$CWD/openbsd/src/lib/libcrypto
libcrypto_regress=$CWD/openbsd/src/regress/lib/libcrypto
libssl_src=$CWD/openbsd/src/lib/libssl
libssl_regress=$CWD/openbsd/src/regress/lib/libssl
libtls_src=$CWD/openbsd/src/lib/libtls
libtls_regress=$CWD/openbsd/src/regress/lib/libtls
app_src=$CWD/openbsd/src/usr.bin

# load library versions
. $libcrypto_src/shlib_version
libcrypto_version=$major:$minor:0
echo "libcrypto version $libcrypto_version"
echo $libcrypto_version > crypto/VERSION

. $libssl_src/shlib_version
libssl_version=$major:$minor:0
echo "libssl version $libssl_version"
echo $libssl_version > ssl/VERSION

. $libtls_src/shlib_version
libtls_version=$major:$minor:0
echo "libtls version $libtls_version"
echo $libtls_version > tls/VERSION
echo $major.$minor.0 > libtls-standalone/VERSION

do_mv() {
	if ! cmp -s "$1" "$2"
	then
		mv "$1" "$2"
	else
		rm -f "$1"
	fi
}
MV='do_mv'

do_cp_libc() {
	sed "/DEF_WEAK/d" < "$1" > "$2"/`basename "$1"`
}
CP_LIBC='do_cp_libc'

CP='cp -p'

$CP $libssl_src/LICENSE COPYING

$CP $libcrypto_src/arch/amd64/opensslconf.h include/openssl
$CP $libcrypto_src/opensslfeatures.h include/openssl
$CP $libssl_src/pqueue.h include

$CP $libtls_src/tls.h include
$CP $libtls_src/tls.h libtls-standalone/include

for i in crypto/compat libtls-standalone/compat; do
	for j in $libc_src/crypt/arc4random.c \
	    $libc_src/crypt/arc4random_uniform.c \
	    $libc_src/crypt/chacha_private.h \
	    $libc_src/string/explicit_bzero.c \
	    $libc_src/stdlib/reallocarray.c \
	    $libc_src/string/strcasecmp.c \
	    $libc_src/string/strlcpy.c \
	    $libc_src/string/strlcat.c \
	    $libc_src/string/strndup.c \
	    $libc_src/string/strnlen.c \
	    $libc_src/string/timingsafe_bcmp.c \
	    $libc_src/string/timingsafe_memcmp.c \
	    $libcrypto_src/arc4random/getentropy_*.c \
	    $libcrypto_src/arc4random/arc4random_*.h; do
		$CP_LIBC $j $i
	done
done

$CP include/compat/stdlib.h \
	include/compat/string.h \
	include/compat/unistd.h \
	libtls-standalone/include

$CP crypto/compat/arc4random*.h \
	crypto/compat/bsd-asprintf.c \
	libtls-standalone/compat

(cd $libcrypto_src/objects/;
	perl objects.pl objects.txt obj_mac.num obj_mac.h;
	perl obj_dat.pl obj_mac.h obj_dat.h )
mkdir -p include/openssl crypto/objects
$MV $libcrypto_src/objects/obj_mac.h ./include/openssl/obj_mac.h
$MV $libcrypto_src/objects/obj_dat.h ./crypto/objects/obj_dat.h

copy_hdrs() {
	for file in $2; do
		$CP $1/$file include/openssl
	done
}

copy_hdrs $libcrypto_src "stack/stack.h lhash/lhash.h stack/safestack.h
	ossl_typ.h err/err.h crypto.h comp/comp.h x509/x509.h buffer/buffer.h
	objects/objects.h asn1/asn1.h bn/bn.h ec/ec.h ecdsa/ecdsa.h
	ecdh/ecdh.h rsa/rsa.h sha/sha.h x509/x509_vfy.h pkcs7/pkcs7.h pem/pem.h
	pem/pem2.h hmac/hmac.h rand/rand.h md5/md5.h
	krb5/krb5_asn.h asn1/asn1_mac.h x509v3/x509v3.h conf/conf.h ocsp/ocsp.h
	aes/aes.h modes/modes.h asn1/asn1t.h dso/dso.h bf/blowfish.h
	bio/bio.h cast/cast.h cmac/cmac.h conf/conf_api.h des/des.h dh/dh.h
	dsa/dsa.h engine/engine.h ui/ui.h pkcs12/pkcs12.h ts/ts.h
	md4/md4.h ripemd/ripemd.h whrlpool/whrlpool.h idea/idea.h
	rc2/rc2.h rc4/rc4.h ui/ui_compat.h txt_db/txt_db.h
	chacha/chacha.h evp/evp.h poly1305/poly1305.h camellia/camellia.h
	gost/gost.h"

copy_hdrs $libssl_src "srtp.h ssl.h ssl2.h ssl3.h ssl23.h tls1.h dtls1.h"

$CP $libcrypto_src/opensslv.h include/openssl
awk '/LIBRESSL_VERSION_TEXT/ {print $4}' < include/openssl/opensslv.h | cut -d\" -f1 > VERSION
echo "LibreSSL version `cat VERSION`"

# copy libcrypto source
echo copying libcrypto source
rm -f crypto/*.c crypto/*.h
for i in `awk '/SOURCES|HEADERS/ { print $3 }' crypto/Makefile.am` ; do
	dir=`dirname $i`
	mkdir -p crypto/$dir
	if [ $dir != "compat" ]; then
		if [ -e $libcrypto_src/$i ]; then
			$CP $libcrypto_src/$i crypto/$i
		fi
	fi
done
$CP crypto/compat/b_win.c crypto/bio
$CP crypto/compat/ui_openssl_win.c crypto/ui

# generate assembly crypto algorithms
asm_src=$libcrypto_src
gen_asm_stdout() {
	perl $asm_src/$2 $1 > $3.tmp
	[ $1 = "elf" ] && cat <<-EOF >> $3.tmp
	#if defined(HAVE_GNU_STACK)
	.section .note.GNU-stack,"",%progbits
	#endif
	EOF
	$MV $3.tmp $3
}
gen_asm() {
	perl $asm_src/$2 $1 $3.tmp
	[ $1 = "elf" ] && cat <<-EOF >> $3.tmp
	#if defined(HAVE_GNU_STACK)
	.section .note.GNU-stack,"",%progbits
	#endif
	EOF
	$MV $3.tmp $3
}
for abi in elf macosx; do
	echo generating ASM source for $abi
	gen_asm_stdout $abi aes/asm/aes-x86_64.pl        crypto/aes/aes-$abi-x86_64.s
	gen_asm_stdout $abi aes/asm/vpaes-x86_64.pl      crypto/aes/vpaes-$abi-x86_64.s
	gen_asm_stdout $abi aes/asm/bsaes-x86_64.pl      crypto/aes/bsaes-$abi-x86_64.s
	gen_asm_stdout $abi aes/asm/aesni-x86_64.pl      crypto/aes/aesni-$abi-x86_64.s
	gen_asm_stdout $abi aes/asm/aesni-sha1-x86_64.pl crypto/aes/aesni-sha1-$abi-x86_64.s
	gen_asm_stdout $abi bn/asm/modexp512-x86_64.pl   crypto/bn/modexp512-$abi-x86_64.s
	gen_asm_stdout $abi bn/asm/x86_64-mont.pl        crypto/bn/mont-$abi-x86_64.s
	gen_asm_stdout $abi bn/asm/x86_64-mont5.pl       crypto/bn/mont5-$abi-x86_64.s
	gen_asm_stdout $abi bn/asm/x86_64-gf2m.pl        crypto/bn/gf2m-$abi-x86_64.s
	gen_asm_stdout $abi camellia/asm/cmll-x86_64.pl  crypto/camellia/cmll-$abi-x86_64.s
	gen_asm_stdout $abi md5/asm/md5-x86_64.pl        crypto/md5/md5-$abi-x86_64.s
	gen_asm_stdout $abi modes/asm/ghash-x86_64.pl    crypto/modes/ghash-$abi-x86_64.s
	gen_asm_stdout $abi rc4/asm/rc4-x86_64.pl        crypto/rc4/rc4-$abi-x86_64.s
	gen_asm_stdout $abi rc4/asm/rc4-md5-x86_64.pl    crypto/rc4/rc4-md5-$abi-x86_64.s
	gen_asm_stdout $abi sha/asm/sha1-x86_64.pl       crypto/sha/sha1-$abi-x86_64.s
	gen_asm        $abi sha/asm/sha512-x86_64.pl     crypto/sha/sha256-$abi-x86_64.S
	gen_asm        $abi sha/asm/sha512-x86_64.pl     crypto/sha/sha512-$abi-x86_64.S
	gen_asm_stdout $abi whrlpool/asm/wp-x86_64.pl    crypto/whrlpool/wp-$abi-x86_64.s
	gen_asm        $abi x86_64cpuid.pl               crypto/cpuid-$abi-x86_64.S
done

# copy libtls source
echo copying libtls source
rm -f tls/*.c tls/*.h libtls/src/*.c libtls/src/*.h
for i in `awk '/SOURCES|HEADERS/ { print $3 }' tls/Makefile.am` ; do
	if [ -e $libtls_src/$i ]; then
		$CP $libtls_src/$i tls
		$CP $libtls_src/$i libtls-standalone/src
	fi
done

$CP_LIBC $libc_src/string/strsep.c tls
$CP_LIBC $libc_src/string/strsep.c libtls-standalone/compat

mkdir -p libtls-standalone/m4
$CP m4/check*.m4 \
	m4/disable*.m4 \
	libtls-standalone/m4
sed -e "s/compat\///" crypto/Makefile.am.arc4random > \
	libtls-standalone/compat/Makefile.am.arc4random

# copy nc(1) source
echo "copying nc(1) source"
$CP $app_src/nc/nc.1 apps/nc
rm -f apps/nc/*.c apps/nc/*.h
$CP_LIBC $libc_src/stdlib/strtonum.c apps/nc/compat
for i in `awk '/SOURCES|HEADERS|MANS/ { print $3 }' apps/nc/Makefile.am` ; do
	if [ -e $app_src/nc/$i ]; then
		$CP $app_src/nc/$i apps/nc
	fi
done

# copy openssl(1) source
echo "copying openssl(1) source"
$CP $app_src/openssl/openssl.1 apps/openssl
$CP_LIBC $libc_src/stdlib/strtonum.c apps/openssl/compat
$CP $libcrypto_src/cert.pem apps/openssl
$CP $libcrypto_src/openssl.cnf apps/openssl
$CP $libcrypto_src/x509v3.cnf apps/openssl
for i in `awk '/SOURCES|HEADERS|MANS/ { print $3 }' apps/openssl/Makefile.am` ; do
	if [ -e $app_src/openssl/$i ]; then
		$CP $app_src/openssl/$i apps/openssl
	fi
done

# copy libssl source
echo "copying libssl source"
rm -f ssl/*.c ssl/*.h
for i in `awk '/SOURCES|HEADERS/ { print $3 }' ssl/Makefile.am` ; do
	$CP $libssl_src/$i ssl
done

# copy libcrypto tests
echo "copying tests"
for i in `find $libcrypto_regress -name '*.c'`; do
	 $CP "$i" tests
done
$CP $libcrypto_regress/evp/evptests.txt tests
$CP $libcrypto_regress/aead/aeadtests.txt tests
$CP $libcrypto_regress/pqueue/expected.txt tests/pq_expected.txt

# copy libc tests
$CP $libc_regress/arc4random-fork/arc4random-fork.c tests/arc4randomforktest.c
$CP $libc_regress/explicit_bzero/explicit_bzero.c tests
$CP_LIBC $libc_src/string/memmem.c tests
$CP $libc_regress/timingsafe/timingsafe.c tests

# copy libssl tests
$CP $libssl_regress/ssl/testssl tests
for i in `find $libssl_regress -name '*.c'`; do
	 $CP "$i" tests
done
$CP $libssl_regress/unit/tests.h tests
$CP $libssl_regress/certs/ca.pem tests
$CP $libssl_regress/certs/server.pem tests

# copy libtls tests
for i in `find $libtls_regress -name '*.c'`; do
	 $CP "$i" tests
done

chmod 755 tests/testssl

# add headers
(cd include/openssl
	$CP Makefile.am.tpl Makefile.am
	for i in `ls -1 *.h|sort`; do
		echo "opensslinclude_HEADERS += $i" >> Makefile.am
	done
)

add_man_links() {
	filter=$1
	dest=$2
	echo "install-data-hook:" >> $dest
	for i in `grep $filter man/links`; do
		IFS=","; set $i; unset IFS
		if [ "$2" != "" ]; then
			echo "	ln -sf $1 \$(DESTDIR)\$(mandir)/man3/$2" >> $dest
		fi
	done
	echo "" >> $dest
	echo "uninstall-local:" >> $dest
	for i in `grep $filter man/links`; do
		IFS=","; set $i; unset IFS
		if [ "$2" != "" ]; then
			echo "	-rm -f \$(DESTDIR)\$(mandir)/man3/$2" >> $dest
		fi
	done
}

# apply local patches
PATCH=patch
# Prefer gnu patch on AIX systems, if available
if [ -x /opt/freeware/bin/patch ]; then
    PATCH=/opt/freeware/bin/patch
fi
for i in patches/*.patch; do
    $PATCH -p0 < $i
done

# copy manpages
echo "copying manpages"
echo EXTRA_DIST = CMakeLists.txt > man/Makefile.am
echo dist_man_MANS = >> man/Makefile.am

$CP $libtls_src/tls_init.3 man
echo "dist_man_MANS += tls_init.3" >> man/Makefile.am

(cd man
	# update new-style manpages
	for i in `ls -1 $libssl_src/doc/*.3 | sort`; do
		NAME=`basename "$i"`
		$CP $i .
		echo "dist_man_MANS += $NAME" >> Makefile.am
	done

	for i in `ls -1 $libcrypto_src/man/*.3 | sort`; do
		NAME=`basename "$i"`
		$CP $i .
		echo "dist_man_MANS += $NAME" >> Makefile.am
	done

	# convert remaining POD manpages
	for i in `ls -1 $libcrypto_src/doc/*.pod | sort`; do
		BASE=`echo $i|sed -e "s/\.pod//"`
		NAME=`basename "$BASE"`
		# reformat file if new
		if [ ! -f $NAME.3 -o $BASE.pod -nt $NAME.3 -o ../include/openssl/opensslv.h -nt $NAME.3 ]; then
			echo processing $NAME
			pod2man --official --release="LibreSSL $VERSION" --center=LibreSSL \
				--section=3 $POD2MAN --name=$NAME < $BASE.pod > $NAME.3
		fi
		echo "dist_man_MANS += $NAME.3" >> Makefile.am
	done
)
add_man_links . man/Makefile.am

# standalone libtls manpages
mkdir -p libtls-standalone/man
echo "dist_man_MANS = tls_init.3" > libtls-standalone/man/Makefile.am

$CP $libtls_src/tls_init.3 libtls-standalone/man
add_man_links tls_init libtls-standalone/man/Makefile.am
