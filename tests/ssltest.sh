#!/bin/sh
set -e
export PATH=$srcdir/../apps:$PATH
$srcdir/testssl $srcdir/server.pem $srcdir/server.pem $srcdir/ca.pem
