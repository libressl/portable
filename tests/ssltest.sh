#!/bin/sh
set -e
PATH=../apps:$PATH
export PATH
$srcdir/testssl $srcdir/server.pem $srcdir/server.pem $srcdir/ca.pem
