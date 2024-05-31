#!/bin/sh
set -e
TEST=./pq_test
if [ -e ./pq_test.exe ]; then
	TEST=./pq_test.exe
elif [ -e ./pq_test.js ]; then
	TEST="node ./pq_test.js"
fi
$TEST | diff -b $srcdir/pq_expected.txt -
