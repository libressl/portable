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
	certs_path="$srcdir/certs"
	ca_file="$srcdir/../cert.pem"
	callback_check="$srcdir/callback.pl"
	make_dir_roots="$srcdir/make-dir-roots.pl"
	openssl_conf="$srcdir/openssl.cnf"
	;;
*)
	certs_path="`pwd`/$srcdir/certs"
	ca_file="`pwd`/$srcdir/../cert.pem"
	callback_check="`pwd`/$srcdir/callback.pl"
	make_dir_roots="`pwd`/$srcdir/make-dir-roots.pl"
	openssl_conf="`pwd`/$srcdir/openssl.cnf"
	;;
esac

if [ $# -ge 3 ]; then
	callback_bin=$1
	callbackfailures_bin=$2
	expirecallback_bin=$3
else
	callback_bin="`pwd`/callback"
	callbackfailures_bin="`pwd`/callbackfailures"
	expirecallback_bin="`pwd`/expirecallback"
	if [ -e ./callback.exe ]; then
		callback_bin="`pwd`/callback.exe"
		callbackfailures_bin="`pwd`/callbackfailures.exe"
		expirecallback_bin="`pwd`/expirecallback.exe"
	fi
fi

if [ $# -ge 4 ]; then
	openssl_dir=`dirname "$4"`
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

workdir=x509_callback-certs

cleanup()
{
	rm -rf "$workdir"
}
trap cleanup EXIT

rm -rf "$workdir"
mkdir "$workdir"

"$PERL" "$make_dir_roots" "$certs_path" "$workdir"

(
	cd "$workdir"
	"$callback_bin" "$certs_path"
	"$PERL" "$callback_check" callback.out
	"$callbackfailures_bin" "$certs_path" "$ca_file"
	"$expirecallback_bin" "$certs_path"
)
