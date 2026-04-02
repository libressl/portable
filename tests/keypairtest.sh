#!/bin/sh
set -e
TEST=./keypairtest
if [ -e ./keypairtest.exe ]; then
	TEST=./keypairtest.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST $srcdir/ca-root-rsa.pem $srcdir/server1-rsa.pem $srcdir/server1-rsa.pem
