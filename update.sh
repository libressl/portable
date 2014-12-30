#!/usr/bin/env bash
set -e

openbsd_branch=`cat OPENBSD_BRANCH`
libressl_version=`cat VERSION`

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
dir=`pwd`
libc_src=$dir/openbsd/src/lib/libc
libc_regress=$dir/openbsd/src/regress/lib/libc
libcrypto_src=$dir/openbsd/src/lib/libcrypto
libcrypto_regress=$dir/openbsd/src/regress/lib/libcrypto
libssl_src=$dir/openbsd/src/lib/libssl
libssl_regress=$dir/openbsd/src/regress/lib/libssl
libtls_src=$dir/openbsd/src/lib/libtls
openssl_app_src=$dir/openbsd/src/usr.bin/openssl

# load library versions
source $libcrypto_src/crypto/shlib_version
libcrypto_version=$major:$minor:0
echo "libcrypto version $libcrypto_version"
echo $libcrypto_version > crypto/VERSION

source $libssl_src/ssl/shlib_version
libssl_version=$major:$minor:0
echo "libssl version $libssl_version"
echo $libssl_version > ssl/VERSION

source $libtls_src/shlib_version
libtls_version=$major:$minor:0
echo "libtls version $libtls_version"
echo $libtls_version > tls/VERSION

do_mv() {
	if ! cmp -s "$1" "$2"
	then
		mv "$1" "$2"
	else
		rm -f "$1"
	fi
}
CP='cp -p'
MV='do_mv'

$CP $libssl_src/src/LICENSE COPYING

$CP $libcrypto_src/crypto/arch/amd64/opensslconf.h include/openssl
$CP $libssl_src/src/crypto/opensslfeatures.h include/openssl
$CP $libssl_src/src/e_os2.h include/openssl
$CP $libssl_src/src/ssl/pqueue.h include
$CP $libtls_src/tls.h include

for i in explicit_bzero.c strlcpy.c strlcat.c strndup.c strnlen.c \
		timingsafe_bcmp.c timingsafe_memcmp.c; do
	$CP $libc_src/string/$i crypto/compat
done
$CP $libc_src/stdlib/reallocarray.c crypto/compat
$CP $libc_src/crypt/arc4random.c crypto/compat
$CP $libc_src/crypt/chacha_private.h crypto/compat
$CP $libcrypto_src/crypto/getentropy_*.c crypto/compat
$CP $libcrypto_src/crypto/arc4random_*.h crypto/compat

(cd $libssl_src/src/crypto/objects/;
	perl objects.pl objects.txt obj_mac.num obj_mac.h;
	perl obj_dat.pl obj_mac.h obj_dat.h )
mkdir -p include/openssl crypto/objects
$MV $libssl_src/src/crypto/objects/obj_mac.h ./include/openssl/obj_mac.h
$MV $libssl_src/src/crypto/objects/obj_dat.h ./crypto/objects/obj_dat.h

copy_hdrs() {
	for file in $2; do
		$CP $libssl_src/src/$1/$file include/openssl
	done
}

copy_hdrs crypto "stack/stack.h lhash/lhash.h stack/safestack.h
	ossl_typ.h err/err.h crypto.h comp/comp.h x509/x509.h buffer/buffer.h
	objects/objects.h asn1/asn1.h bn/bn.h ec/ec.h ecdsa/ecdsa.h
	ecdh/ecdh.h rsa/rsa.h sha/sha.h x509/x509_vfy.h pkcs7/pkcs7.h pem/pem.h
	pem/pem2.h hmac/hmac.h rand/rand.h md5/md5.h
	krb5/krb5_asn.h asn1/asn1_mac.h x509v3/x509v3.h conf/conf.h ocsp/ocsp.h
	aes/aes.h modes/modes.h asn1/asn1t.h dso/dso.h bf/blowfish.h
	bio/bio.h cast/cast.h cmac/cmac.h conf/conf_api.h des/des.h dh/dh.h
	dsa/dsa.h cms/cms.h engine/engine.h ui/ui.h pkcs12/pkcs12.h ts/ts.h
	md4/md4.h ripemd/ripemd.h whrlpool/whrlpool.h idea/idea.h mdc2/mdc2.h
	rc2/rc2.h rc4/rc4.h rc5/rc5.h ui/ui_compat.h txt_db/txt_db.h
	chacha/chacha.h evp/evp.h poly1305/poly1305.h camellia/camellia.h
	gost/gost.h"

copy_hdrs ssl "srtp.h ssl.h ssl2.h ssl3.h ssl23.h tls1.h dtls1.h"

sed -e "s/\"LibreSSL .*\"/\"LibreSSL ${libressl_version}\"/" \
	$libssl_src/src/crypto/opensslv.h > include/openssl/opensslv.h.lcl
$MV include/openssl/opensslv.h.lcl include/openssl/opensslv.h

# copy libcrypto source
echo copying libcrypto source
rm -f crypto/*.c crypto/*.h
for i in `awk '/SOURCES|HEADERS/ { print $3 }' crypto/Makefile.am` ; do
	dir=`dirname $i`
	mkdir -p crypto/$dir
	if [ $dir != "compat" ]; then
		if [ -e $libssl_src/src/crypto/$i ]; then
			$CP $libssl_src/src/crypto/$i crypto/$i
		fi
	fi
done
$CP crypto/compat/b_win.c crypto/bio
$CP crypto/compat/ui_openssl_win.c crypto/ui

# generate assembly crypto algorithms
asm_src=$libssl_src/src/crypto
gen_asm_stdout() {
	perl $asm_src/$2 $1 > $3.tmp
	[[ $1 == "elf" ]] && cat <<-EOF >> $3.tmp
	#if defined(HAVE_GNU_STACK)
	.section .note.GNU-stack,"",%progbits
	#endif
	EOF
	$MV $3.tmp $3
}
gen_asm() {
	perl $asm_src/$2 $1 $3.tmp
	[[ $1 == "elf" ]] && cat <<-EOF >> $3.tmp
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
rm -f tls/*.c tls/*.h
for i in `awk '/SOURCES|HEADERS/ { print $3 }' tls/Makefile.am` ; do
	$CP $libtls_src/$i tls
done

# copy openssl(1) source
echo "copying openssl(1) source"
$CP $libc_src/stdlib/strtonum.c apps
$CP $libcrypto_src/openssl.cnf apps
for i in `awk '/SOURCES|HEADERS/ { print $3 }' apps/Makefile.am` ; do
	if [ -e $openssl_app_src/$i ]; then
		$CP $openssl_app_src/$i apps
	fi
done

# copy libssl source
echo "copying libssl source"
rm -f ssl/*.c ssl/*.h
for i in `awk '/SOURCES|HEADERS/ { print $3 }' ssl/Makefile.am` ; do
	$CP $libssl_src/src/ssl/$i ssl
done

# copy libcrypto tests
echo "copying tests"
rm -f tests/biotest.c
for i in aead/aeadtest.c aeswrap/aes_wrap.c base64/base64test.c bf/bftest.c \
	bn/general/bntest.c bn/mont/mont.c \
	cast/casttest.c chacha/chachatest.c cts128/cts128test.c \
	des/destest.c dh/dhtest.c dsa/dsatest.c ec/ectest.c ecdh/ecdhtest.c \
	ecdsa/ecdsatest.c engine/enginetest.c evp/evptest.c exp/exptest.c \
	gcm128/gcm128test.c hmac/hmactest.c idea/ideatest.c ige/igetest.c \
	md4/md4test.c md5/md5test.c mdc2/mdc2test.c poly1305/poly1305test.c \
	pkcs7/pkcs7test.c pqueue/pq_test.c rand/randtest.c rc2/rc2test.c \
	rc4/rc4test.c rmd/rmdtest.c sha/shatest.c sha1/sha1test.c \
	sha256/sha256test.c sha512/sha512test.c utf8/utf8test.c \
	gost/gost2814789t.c ; do
	 $CP $libcrypto_regress/$i tests
done

# copy libc tests
$CP $libc_regress/arc4random-fork/arc4random-fork.c tests/arc4randomforktest.c
$CP $libc_regress/explicit_bzero/explicit_bzero.c tests
$CP $libc_regress/timingsafe/timingsafe.c tests

# copy libssl tests
$CP $libssl_regress/asn1/asn1test.c tests
$CP $libssl_regress/ssl/testssl tests
$CP $libssl_regress/ssl/ssltest.c tests
$CP $libssl_regress/certs/ca.pem tests
$CP $libssl_regress/certs/server.pem tests

# setup test drivers
# do not directly run all test programs
test_drivers=(
	aeadtest
	evptest
	pq_test
	ssltest
	arc4randomforktest
	pidwraptest
)
tests_posix_only=(
	arc4randomforktest
	explicit_bzero
	pidwraptest
)
$CP $libc_src/string/memmem.c tests/
(cd tests
	$CP Makefile.am.tpl Makefile.am

	for i in `ls -1 *.c|sort|grep -v memmem.c`; do
		TEST=`echo $i|sed -e "s/\.c//"`
		if [[ ${tests_posix_only[*]} =~ "$TEST" ]]; then
			echo "if !HOST_WIN" >> Makefile.am
		fi
		if ! [[ ${test_drivers[*]} =~ "$TEST" ]]; then
			echo "TESTS += $TEST" >> Makefile.am
		fi
		echo "check_PROGRAMS += $TEST" >> Makefile.am
		echo "${TEST}_SOURCES = $i" >> Makefile.am
		if [[ ${TEST} = "explicit_bzero" ]]; then
			echo "if !HAVE_MEMMEM" >> Makefile.am
			echo "explicit_bzero_SOURCES += memmem.c" >> Makefile.am
			echo "endif" >> Makefile.am
		fi
		if [[ ${tests_posix_only[*]} =~ "$TEST" ]]; then
			echo "endif" >> Makefile.am
		fi
	done
)
$CP $libcrypto_regress/evp/evptests.txt tests
$CP $libcrypto_regress/aead/aeadtests.txt tests
$CP $libcrypto_regress/pqueue/expected.txt tests/pq_expected.txt
chmod 755 tests/testssl
for i in "${test_drivers[@]}"; do
	if [ -e tests/${i}.sh ]; then
		if [[ ${tests_posix_only[*]} =~ "$i" ]]; then
			echo "if !HOST_WIN" >> tests/Makefile.am
		fi
		if ! [[ ${tests_disabled[*]} =~ "$i" ]]; then
			echo "TESTS += ${i}.sh" >> tests/Makefile.am
		fi
		if [[ ${tests_posix_only[*]} =~ "$i" ]]; then
			echo "endif" >> tests/Makefile.am
		fi
		echo "EXTRA_DIST += ${i}.sh" >> tests/Makefile.am
	fi
done
echo "EXTRA_DIST += aeadtests.txt" >> tests/Makefile.am
echo "EXTRA_DIST += evptests.txt" >> tests/Makefile.am
echo "EXTRA_DIST += pq_expected.txt" >> tests/Makefile.am
echo "EXTRA_DIST += testssl ca.pem server.pem" >> tests/Makefile.am

(cd include/openssl
	$CP Makefile.am.tpl Makefile.am
	for i in `ls -1 *.h|sort`; do
		echo "opensslinclude_HEADERS += $i" >> Makefile.am
	done
)

echo "copying manpages"
# copy manpages
(cd man
	$CP Makefile.am.tpl Makefile.am

	# update new-style manpages
	for i in `ls -1 $libssl_src/src/doc/ssl/*.3 | sort`; do
		NAME=`basename "$i"`
		$CP $i .
		echo "dist_man_MANS += $NAME" >> Makefile.am
	done
	$CP $openssl_app_src/openssl.1 .
	echo "dist_man_MANS += openssl.1" >> Makefile.am
	$CP $libtls_src/tls_init.3 .
	echo "if ENABLE_LIBTLS" >> Makefile.am
	echo "dist_man_MANS += tls_init.3" >> Makefile.am
	echo "endif" >> Makefile.am

	# convert remaining POD manpages
	for i in `ls -1 $libssl_src/src/doc/crypto/*.pod | sort`; do
		BASE=`echo $i|sed -e "s/\.pod//"`
		NAME=`basename "$BASE"`
		# reformat file if new
		if [ ! -f $NAME.3 -o $BASE.pod -nt $NAME.3 -o ../VERSION -nt $NAME.3 ]; then
			echo processing $NAME
			pod2man --official --release="LibreSSL $VERSION" --center=LibreSSL \
				--section=3 $POD2MAN --name=$NAME < $BASE.pod > $NAME.3
		fi
		echo "dist_man_MANS += $NAME.3" >> Makefile.am
	done

	echo "install-data-hook:" >> Makefile.am
	source ./links
	for i in $SSL_MLINKS; do
		IFS=","; set $i; unset IFS
		echo "	ln -f \$(DESTDIR)\$(mandir)/man3/$1 \\" >> Makefile.am
		echo "    \$(DESTDIR)\$(mandir)/man3/$2" >> Makefile.am
	done
	echo "if ENABLE_LIBTLS" >> Makefile.am
	for i in $TLS_MLINKS; do
		IFS=","; set $i; unset IFS
		echo "	ln -f \$(DESTDIR)\$(mandir)/man3/$1 \\" >> Makefile.am
		echo "    \$(DESTDIR)\$(mandir)/man3/$2" >> Makefile.am
	done
	echo "endif" >> Makefile.am
	echo "" >> Makefile.am
	echo "uninstall-local:" >> Makefile.am
	for i in $SSL_MLINKS; do
		IFS=","; set $i; unset IFS
		echo "	-rm -f \$(DESTDIR)\$(mandir)/man3/$2" >> Makefile.am
	done
	echo "if ENABLE_LIBTLS" >> Makefile.am
	for i in $TLS_MLINKS; do
		IFS=","; set $i; unset IFS
		echo "	rm -f \$(DESTDIR)\$(mandir)/man3/$2" >> Makefile.am
	done
	echo "endif" >> Makefile.am
)
