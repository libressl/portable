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

test=p
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

cat $srcdir/openssl.cnf >$test;

echo cat
$cmd enc < $test > $test.cipher
$cmd enc < $test.cipher >$test.clear
cmp $test $test.clear
if [ $? != 0 ]
then
	exit 1
else
	/bin/rm $test.cipher $test.clear
fi
echo base64
$cmd enc -a -e < $test > $test.cipher
$cmd enc -a -d < $test.cipher >$test.clear
cmp $test $test.clear
if [ $? != 0 ]
then
	exit 1
else
	/bin/rm $test.cipher $test.clear
fi

for i in \
	aes-128-cbc aes-128-cfb aes-128-cfb1 aes-128-cfb8 \
	aes-128-ecb aes-128-ofb aes-192-cbc aes-192-cfb \
	aes-192-cfb1 aes-192-cfb8 aes-192-ecb aes-192-ofb \
	aes-256-cbc aes-256-cfb aes-256-cfb1 aes-256-cfb8 \
	aes-256-ecb aes-256-ofb \
	bf-cbc bf-cfb bf-ecb bf-ofb \
	cast-cbc cast5-cbc cast5-cfb cast5-ecb cast5-ofb \
	des-cbc des-cfb des-cfb8 des-ecb des-ede \
	des-ede-cbc des-ede-cfb des-ede-ofb des-ede3 \
	des-ede3-cbc des-ede3-cfb des-ede3-ofb des-ofb desx-cbc \
	rc2-40-cbc rc2-64-cbc rc2-cbc rc2-cfb rc2-ecb rc2-ofb \
	rc4 rc4-40
do
	echo $i
	$cmd $i -e -k test < $test > $test.$i.cipher
	$cmd $i -d -k test < $test.$i.cipher >$test.$i.clear
	cmp $test $test.$i.clear
	if [ $? != 0 ]
	then
		exit 1
	else
		/bin/rm $test.$i.cipher $test.$i.clear
	fi

	echo $i base64
	$cmd $i -a -e -k test < $test > $test.$i.cipher
	$cmd $i -a -d -k test < $test.$i.cipher >$test.$i.clear
	cmp $test $test.$i.clear
	if [ $? != 0 ]
	then
		exit 1
	else
		/bin/rm $test.$i.cipher $test.$i.clear
	fi
done
rm -f $test
