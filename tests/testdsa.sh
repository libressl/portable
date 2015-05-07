#!/bin/sh
#	$OpenBSD: testdsa.sh,v 1.1 2014/08/26 17:50:07 jsing Exp $


#Test DSA certificate generation of openssl

cmd=../apps/openssl

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

rm testdsa.key

exit 0
