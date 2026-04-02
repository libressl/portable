#!/bin/sh
set -e

quictest_bin=./quictest
if [ -e ./quictest.exe ]; then
	quictest_bin=./quictest.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$quictest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
