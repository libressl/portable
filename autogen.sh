#!/bin/sh
set -e

./update.sh
mkdir -p m4
autoreconf -i -f
