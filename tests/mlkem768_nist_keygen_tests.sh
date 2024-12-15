#!/bin/sh
set -e
TEST=./mlkem768_keygen_tests
if [ -e ./mlkem768_keygen_tests.exe ]; then
	TEST=./mlkem768_keygen_tests.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST $srcdir/mlkem768_keygen_tests.txt
