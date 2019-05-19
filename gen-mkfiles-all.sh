#!/bin/sh

set -e

./gen-mkfile.sh lib crypto/Makefile.am
./gen-mkfile.sh lib ssl/Makefile.am
./gen-mkfile.sh lib tls/Makefile.am
./gen-mkfile.sh bin apps/openssl/Makefile.am
./gen-mkfile.sh include include/Makefile.am
