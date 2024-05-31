#!/bin/sh
set -e

shutdowntest_bin=./shutdowntest
if [ -e ./shutdowntest.exe ]; then
	shutdowntest_bin=./shutdowntest.exe
elif [ -e ./shutdowntest.js ]; then
	shutdowntest_bin="node ./shutdowntest.js"
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$shutdowntest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
