#!/bin/sh
#
# Copyright (c) 2015 Brent Cook
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

#Test RSA certificate generation of openssl

if [ -d ../apps/openssl ]; then
	cmd=../apps/openssl/openssl
	if [ -e ../apps/openssl/openssl.exe ]; then
		cmd=../apps/openssl/openssl.exe
	fi
else
	cmd=../apps/openssl
	if [ -e ../apps/openssl.exe ]; then
		cmd=../apps/openssl.exe
	fi
fi

if [ -z $srcdir ]; then
	srcdir=.
fi

# Generate RSA private key
$cmd genrsa -out rsakey.pem
if [ $? != 0 ]; then
        exit 1;
fi


# Generate an RSA certificate
$cmd req -config $srcdir/openssl.cnf -key rsakey.pem -new -x509 -days 365 -out rsacert.pem
if [ $? != 0 ]; then
        exit 1;
fi


# Now check the certificate
$cmd x509 -text -in rsacert.pem
if [ $? != 0 ]; then
        exit 1;
fi

rm -f rsacert.pem rsakey.pem

exit 0
