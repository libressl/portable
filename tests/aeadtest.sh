#!/bin/sh
#
# Copyright (c) 2014 Brent Cook
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
TEST=./aeadtest
if [ -e ./aeadtest.exe ]; then
	TEST=./aeadtest.exe
elif [ -e ./aeadtest.js ]; then
	TEST="node ./aeadtest.js"
fi
$TEST aead $srcdir/aeadtests.txt
$TEST aes-128-gcm $srcdir/aes_128_gcm_tests.txt
$TEST aes-192-gcm $srcdir/aes_192_gcm_tests.txt
$TEST aes-256-gcm $srcdir/aes_256_gcm_tests.txt
$TEST chacha20-poly1305 $srcdir/chacha20_poly1305_tests.txt
$TEST xchacha20-poly1305 $srcdir/xchacha20_poly1305_tests.txt

