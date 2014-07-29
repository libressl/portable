#!/bin/sh
set -e

./autogen.sh
./configure
make dist
