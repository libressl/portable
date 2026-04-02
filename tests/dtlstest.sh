#!/bin/sh
set -e

dtlstest_bin=./dtlstest
if [ -e ./dtlstest.exe ]; then
	dtlstest_bin=./dtlstest.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$dtlstest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa.pem $srcdir/ca-int-rsa.pem
