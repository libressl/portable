#!/bin/sh
#
# Copyright (c) 2024 Theo Buehler
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

set -e

TEST=./mlkem_tests
if [ -e ./mlkem_tests.exe ]; then
	TEST=./mlkem_tests.exe
elif [ -e ./mlkem_tests.js ]; then
	TEST="node ./mlkem_tests.js"
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
