#!/bin/sh
set -e
TEST=./mlkem1024_keygen_tests
if [ -e ./mlkem1024_keygen_tests.exe ]; then
	TEST=./mlkem1024_keygen_tests.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST $srcdir/mlkem1024_keygen_tests.txt
