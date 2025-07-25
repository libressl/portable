#!/bin/sh
#
# Copyright (c) 2017 Kinichiro Inoguchi
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

servertest_bin=./servertest
if [ -e ./servertest.exe ]; then
	servertest_bin=./servertest.exe
elif [ -e ./servertest.js ]; then
	servertest_bin="node ./servertest.js"
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

$servertest_bin $srcdir/server1-rsa.pem $srcdir/server1-rsa-chain.pem $srcdir/ca-root-rsa.pem
