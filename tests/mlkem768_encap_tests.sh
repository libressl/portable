#!/bin/sh
set -e
TEST=./mlkem768_encap_tests
if [ -e ./mlkem768_encap_tests.exe ]; then
	TEST=./mlkem768_encap_tests.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST $srcdir/mlkem768_encap_tests.txt
