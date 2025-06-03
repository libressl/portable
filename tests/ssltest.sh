#!/bin/sh
#
# Copyright (c) 2014 Brent Cook
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
