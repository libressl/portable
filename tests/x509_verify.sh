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

case "$srcdir" in
/*)
	certs_path="$srcdir/certs"
	make_dir_roots="$srcdir/make-dir-roots.pl"
	openssl_conf="$srcdir/openssl.cnf"
	;;
*)
	certs_path="`pwd`/$srcdir/certs"
	make_dir_roots="`pwd`/$srcdir/make-dir-roots.pl"
	openssl_conf="`pwd`/$srcdir/openssl.cnf"
	;;
esac

if [ $# -ge 1 ]; then
	verify_bin=$1
else
	verify_bin="`pwd`/x509_verify"
	if [ -e ./x509_verify.exe ]; then
		verify_bin="`pwd`/x509_verify.exe"
	fi
fi

if [ $# -ge 2 ]; then
	openssl_dir=`dirname "$2"`
elif [ -d ../apps/openssl ]; then
	openssl_dir="`pwd`/../apps/openssl"
else
	openssl_dir="`pwd`/../apps"
fi

PATH="$openssl_dir:$PATH"
export PATH

if [ -f "$openssl_conf" ]; then
	OPENSSL_CONF="$openssl_conf"
	export OPENSSL_CONF
fi

workdir=x509_verify-certs

cleanup()
{
	rm -rf "$workdir"
}
trap cleanup EXIT

rm -rf "$workdir"
mkdir "$workdir"

perl "$make_dir_roots" "$certs_path" "$workdir"

(
	cd "$workdir"
	"$verify_bin" "$certs_path"
)
