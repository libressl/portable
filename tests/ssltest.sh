#!/bin/sh
set -e

ssltest_bin=./ssltest
if [ -e ./ssltest.exe ]; then
	ssltest_bin=./ssltest.exe
fi

openssl_bin=../apps/openssl
if [ -e ../apps/openssl.exe ]; then
	openssl_bin=../apps/openssl.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$srcdir/testssl $srcdir/server.pem $srcdir/server.pem $srcdir/ca.pem \
	$ssltest_bin $openssl_bin
