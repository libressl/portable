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

#Test DSA certificate generation of openssl

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

# Generate DSA paramter set
$cmd dsaparam 512 -out dsa512.pem
if [ $? != 0 ]; then
        exit 1;
fi


# Denerate a DSA certificate
$cmd req -config $srcdir/openssl.cnf -x509 -newkey dsa:dsa512.pem -out testdsa.pem -keyout testdsa.key
if [ $? != 0 ]; then
        exit 1;
fi


# Now check the certificate
$cmd x509 -text -in testdsa.pem
if [ $? != 0 ]; then
        exit 1;
fi

rm testdsa.key dsa512.pem testdsa.pem

exit 0
