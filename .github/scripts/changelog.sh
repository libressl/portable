#!/bin/sh
# Copyright (c) 2023 Joshua Sing <joshua@hypera.dev>
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
# Usage: changelog.sh <version>
#  Reads the changelog for the specified version from the changelog file.
#  The output will be reformatted for use in GitHub releases.
#
#  The changelog file defaults to "ChangeLog", but can be changed by setting
#  the environment variable $CHANGELOG_FILE
#

set -e

# Check if the version argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

version="${1#v}"
changelog_file="${CHANGELOG_FILE:-ChangeLog}"
found_version=false
changelog=""

# Check if the specified changelog file exists
if [ ! -f "$changelog_file" ]; then
    echo "Error: Changelog file '$changelog_file' not found"
    exit 1
fi

# Read the changelog file line by line
while IFS= read -r line; do
    # Check for the version line
    if echo "$line" | grep -Eq "^${version} - "; then
      found_version=true
      continue
    fi

    # Continue reading the changelog until the next version or end of file,
    # skipping empty lines
    if $found_version; then
      echo "$line" | grep -Eq "^\s*$" && continue
      echo "$line" | grep -Eq "^[0-9]+\.[0-9]+\.[0-9]+ - " && break
      changelog="${changelog}${line}\n"
    fi
done < "$changelog_file"

# If the specified version was not found, print an error
if ! $found_version; then
    echo "Error: Version $version was not found in changelog"
    exit 1
fi

# Tidy up the changelog for displaying on GitHub
changelog=$(echo "$changelog" | sed -e 's/^\t\*/###/' -e 's/^\t//')

# Print the changelog for the specified version
echo "$changelog"
echo
echo "Full changelog: https://github.com/libressl/portable/blob/master/ChangeLog"
exit 0
