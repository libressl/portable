#
# Copyright (c) 2014 Brent Cook
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
#
#!/bin/sh

VERSION=$(cat VERSION)
DESTDIR=libressl-coverage-$VERSION

echo "This will generate a code coverage report under $DESTDIR"
echo

if [ "x$(which lcov)" = "x" ]; then
	echo "'lcov' is required but not found!"
	exit 1
fi

if [ "x$(which genhtml)" = "x" ]; then
	echo "'genhtml' is required but not found!"
	exit 1
fi

find -name '*.gcda' -o -name '*.gcno' -delete
rm -fr $DESTDIR

echo "Configuring to build with code coverage support"
./configure CFLAGS='-O0 -fprofile-arcs -ftest-coverage'

echo "Running all code paths"
make clean
make check

echo "Generating report"
mkdir -p $DESTDIR
find tests -name '*.gcda' -o -name '*.gcno' -delete
lcov --capture --output-file $DESTDIR/coverage.tmp \
	--rc lcov_branch_coverage=1 \
	--directory crypto \
	--directory ssl \
	--directory tls \
    --test-name "LibreSSL $VERSION"
genhtml --prefix . --output-directory $DESTDIR \
	--branch-coverage --function-coverage \
	--rc lcov_branch_coverage=1 \
    --title "LibreSSL $VERSION" --legend --show-detail $DESTDIR/coverage.tmp

echo "Code coverage report is available under $DESTDIR"
