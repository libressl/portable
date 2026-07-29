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

if [ -z "$srcdir" ]; then
	srcdir=.
fi

if [ -z "$PERL" ]; then
	PERL=perl
fi

case "$srcdir" in
/*)
	create_certs="$srcdir/create-libressl-test-certs.pl"
	;;
*)
	create_certs="`pwd`/$srcdir/create-libressl-test-certs.pl"
	;;
esac

if [ $# -ge 1 ]; then
	verify_bin=$1
else
	verify_bin="`pwd`/ssl_verify"
	if [ -e ./ssl_verify.exe ]; then
		verify_bin="`pwd`/ssl_verify.exe"
	fi
fi

workdir=ssl_verify-certs

cleanup()
{
	rm -rf "$workdir"
}
trap cleanup EXIT

rm -rf "$workdir"
mkdir "$workdir"

(
	cd "$workdir"
	"$PERL" "$create_certs"
	case "$verify_bin" in
	*.js)
		node "$verify_bin"
		;;
	*)
		"$verify_bin"
		;;
	esac
)
