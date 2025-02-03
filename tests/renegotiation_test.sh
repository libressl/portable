#!/bin/sh
set -e

renegotiation_test_bin=./renegotiation_test
if [ -e ./renegotiation_test.exe ]; then
	renegotiation_test_bin=./renegotiation_test.exe
elif [ -e ./renegotiation_test.js ]; then
	renegotiation_test_bin="node ./renegotiation_test.js"
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$renegotiation_test_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
