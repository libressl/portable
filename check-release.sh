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

ver=$1
dir=libressl-$ver
tarball=$dir.tar.gz
tag=v$ver

if [ -z "$LIBRESSL_SSH" ]; then
	if ! curl -v 1>/dev/null 2>&1; then
		download="curl -O"
	elif echo quit | ftp 1>/dev/null 2>&1; then
		download=ftp
	else
		echo "need 'ftp' or 'curl' to verify"
		exit
	fi
fi

if [ "$ver" = "" ]; then
	echo "please specify a version to check, e.g. $0 2.1.2"
	exit
fi

if [ ! -e releases/$tarball ]; then
	mkdir -p releases
	rm -f $tarball
	if [ -z "$LIBRESSL_SSH" ]; then
		$download https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/$tarball releases/
		mv $tarball releases
	else
		scp $LIBRESSL_SSH/$tarball releases
	fi
	(cd releases; tar zxvf $tarball)
fi

if [ ! -e gen-releases/$tarball ]; then
	rm -fr tests man include ssl crypto libtls-standalone/VERSION INSTALL
	git checkout OPENBSD_BRANCH update.sh tests man include ssl crypto
	git checkout $tag
	echo "libressl-$tag" > OPENBSD_BRANCH
	sed -i 's/git pull --rebase//' update.sh
	./autogen.sh
	./configure --enable-libtls
	make dist

	mkdir -p gen-releases
	mv $tarball gen-releases

	git checkout OPENBSD_BRANCH update.sh
	git checkout master
fi

(cd gen-releases; rm -fr $dir; tar zxf $tarball)
(cd releases; rm -fr $dir; tar zxf $tarball)

echo "differences between release and regenerated release tag:"
diff -urN \
	-x *.3 \
	-x *.5 \
	-x Makefile.in \
	-x aclocal.m4 \
	-x compile \
	-x config.guess \
	-x config.sub \
	-x configure \
	-x depcomp \
	-x install-sh \
	-x missing \
	-x test-driver \
	releases/$dir gen-releases/$dir
