#!/bin/sh
set -e

TEST=./mlkem_tests
if [ -e ./mlkem_tests.exe ]; then
	TEST=./mlkem_tests.exe
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$TEST mlkem768_decap_tests		$srcdir/mlkem768_decap_tests.txt
$TEST mlkem768_encap_tests		$srcdir/mlkem768_encap_tests.txt
$TEST mlkem768_keygen_tests		$srcdir/mlkem768_keygen_tests.txt
$TEST mlkem768_nist_decap_tests		$srcdir/mlkem768_nist_decap_tests.txt
$TEST mlkem768_nist_keygen_tests	$srcdir/mlkem768_nist_keygen_tests.txt
$TEST mlkem1024_decap_tests		$srcdir/mlkem1024_decap_tests.txt
$TEST mlkem1024_encap_tests		$srcdir/mlkem1024_encap_tests.txt
$TEST mlkem1024_keygen_tests		$srcdir/mlkem1024_keygen_tests.txt
$TEST mlkem1024_nist_decap_tests	$srcdir/mlkem1024_nist_decap_tests.txt
$TEST mlkem1024_nist_keygen_tests	$srcdir/mlkem1024_nist_keygen_tests.txt
