#!/bin/sh
set -e
TEST=./mlkem1024_nist_decap_tests
if [ -e ./mlkem1024_nist_decap_tests.exe ]; then
	TEST=./mlkem1024_nist_decap_tests.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST $srcdir/mlkem1024_nist_decap_tests.txt
