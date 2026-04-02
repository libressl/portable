#!/bin/sh
set -e

shutdowntest_bin=./shutdowntest
if [ -e ./shutdowntest.exe ]; then
	shutdowntest_bin=./shutdowntest.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$shutdowntest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
