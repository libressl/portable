#!/bin/sh
set -e

rm man/*.1 man/*.3
./autogen.sh
./configure
make dist
