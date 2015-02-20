#!/bin/sh
set -e
set -x

# This script generates Windows binary distribution packages with Visual
# Studio-compatible header and library files.

# Visual Studio 2013 Community Edition and the mingw64 32-bit and 64-bit cross
# compilers packaged with Cygwin are assumed to be installed.

ARCH=$1
if [ x$ARCH = x ]; then
	ARCH=X86
fi
echo Building for $ARCH

if [ $ARCH=X86 ]; then
	HOST=i686-w64-mingw32
else
	HOST=x86_64-w64-mingw32
fi

export PATH=/cygdrive/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 12.0/VC/bin:$PATH
VERSION=`cat VERSION`
DIST=libressl-$VERSION-$ARCH

CC=$HOST-gcc \
CFLAGS="-Wl,--nxcompat -fstack-protector" \
LDFLAGS="-lssp -Wl,--dynamicbase,--export-all-symbols" \
./configure --prefix=/ --host=$HOST --enable-libtls

make clean
make -j 4 install DESTDIR=`pwd`/tmp

rm -fr $DIST
mkdir $DIST

cp -a tmp/lib $DIST
cp -a tmp/include $DIST
# massage the headers to remove things cl.exe cannot understand
sed -i -e 'N;/\n.*__non/s/"\? *\n/ /;P;D' \
       $DIST/include/openssl/*.h $DIST/include/*.h
sed -i -e 'N;/\n.*__attr/s/"\? *\n/ /;P;D' \
       $DIST/include/openssl/*.h $DIST/include/*.h
sed -i -e "s/__attr.*;/;/"  \
       -e "s/sys\/time.h/winsock2.h/" \
       $DIST/include/openssl/*.h $DIST/include/*.h
cp tmp/bin/* $DIST/lib

for i in libcrypto libssl libtls; do
	echo EXPORTS > $i.def
	mv $DIST/lib/$i*.dll $DIST/lib/$i.dll
	dumpbin.exe /exports $DIST/lib/$i.dll | awk '{print $4}' | awk 'NF' |tail -n +9 >> $i.def
	lib.exe /MACHINE:$ARCH /def:$i.def /out:$DIST/lib/$i.lib
done
zip -r $DIST.zip $DIST
