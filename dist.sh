#!/bin/sh
set -e

rm -f man/*.[35] include/openssl/*.h
./autogen.sh
./configure
make -j2 distcheck
