#!/bin/sh
set -e

quictest_bin=./quictest
if [ -e ./quictest.exe ]; then
	quictest_bin=./quictest.exe
elif [ -e ./quictest.js ]; then
	quictest_bin="node ./quictest.js"
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$quictest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
