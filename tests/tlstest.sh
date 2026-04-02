#!/bin/sh
set -e

tlstest_bin=./tlstest
if [ -e ./tlstest.exe ]; then
	tlstest_bin=./tlstest.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$tlstest_bin $srcdir/ca-root-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/server1-rsa.pem
