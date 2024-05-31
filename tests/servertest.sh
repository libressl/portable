#!/bin/sh
set -e

servertest_bin=./servertest
if [ -e ./servertest.exe ]; then
	servertest_bin=./servertest.exe
elif [ -e ./servertest.js ]; then
	servertest_bin="node ./servertest.js"
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$servertest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
