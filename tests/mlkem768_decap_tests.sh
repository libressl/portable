#!/bin/sh
set -e
TEST=./mlkem768_decap_tests
if [ -e ./mlkem768_decap_tests.exe ]; then
	TEST=./mlkem768_decap_tests.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST $srcdir/mlkem768_decap_tests.txt
