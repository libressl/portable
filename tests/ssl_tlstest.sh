#!/bin/sh
#
# Copyright (c) 2026 Kenjiro Nakayama
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

if [ $# -ge 1 ]; then
	ssl_tlstest_bin=$1
else
	ssl_tlstest_bin=./ssl_tlstest
	if [ -e ./ssl_tlstest.exe ]; then
		ssl_tlstest_bin=./ssl_tlstest.exe
	elif [ -e ./ssl_tlstest.js ]; then
		ssl_tlstest_bin=./ssl_tlstest.js
	fi
fi

if [ -z "$srcdir" ]; then
	srcdir=.
fi

case "$ssl_tlstest_bin" in
*.js)
	node "$ssl_tlstest_bin" "$srcdir/server1-rsa.pem" \
	    "$srcdir/server1-rsa-chain.pem" "$srcdir/ca-root-rsa.pem"
	;;
*)
	"$ssl_tlstest_bin" "$srcdir/server1-rsa.pem" \
	    "$srcdir/server1-rsa-chain.pem" "$srcdir/ca-root-rsa.pem"
	;;
esac
