#!/bin/sh
set -e

ssltest_bin=./ssltest
if [ -e ./ssltest.exe ]; then
	ssltest_bin=./ssltest.exe
elif [ -e ./ssltest.js ]; then
	ssltest_bin="node ./ssltest.js"
fi

if [ -d ../apps/openssl ]; then
	openssl_bin=../apps/openssl/openssl
	if [ -e ../apps/openssl/openssl.exe ]; then
		openssl_bin=../apps/openssl/openssl.exe
	elif [ -e ../apps/openssl/openssl.js ]; then
		openssl_bin="node ../apps/openssl/openssl.js"
	fi
else
	openssl_bin=../apps/openssl
	if [ -e ../apps/openssl.exe ]; then
		openssl_bin=../apps/openssl.exe
	elif [ -e ../apps/openssl.js ]; then
		openssl_bin="node ../apps/openssl.js"
	fi
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$srcdir/testssl $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem \
	$srcdir/ca-root-rsa.pem \
	"$ssltest_bin" "$openssl_bin"
