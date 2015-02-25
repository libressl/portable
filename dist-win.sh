#!/bin/bash
set -e
set -x

export PATH=/cygdrive/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio\ 12.0/VC/bin:$PATH
VERSION=`cat VERSION`
DIST=libressl-$VERSION

rm -fr $DIST
mkdir -p $DIST

for ARCH in X86 X64; do
	echo Building for $ARCH

	if [ $ARCH=X86 ]; then
		HOST=i686-w64-mingw32
	else
		HOST=x86_64-w64-mingw32
	fi

	CC=$HOST-gcc ./configure --host=$HOST \
	    --enable-libtls --disable-shared
	make clean
	PATH=$PATH:/usr/$HOST/sys-root/mingw/bin \
	   make -j 4 check
	make -j 4 install DESTDIR=`pwd`/stage-$ARCH

	mkdir -p $DIST/$ARCH
	#cp -a stage-$ARCH/usr/local/lib/* $DIST/$ARCH
	if [ ! -e $DIST/include ]; then
		cp -a stage-$ARCH/usr/local/include $DIST
		sed -i -e 'N;/\n.*__non/s/"\? *\n/ /;P;D' \
		       $DIST/include/openssl/*.h $DIST/include/*.h
		sed -i -e 'N;/\n.*__attr/s/"\? *\n/ /;P;D' \
		       $DIST/include/openssl/*.h $DIST/include/*.h
		sed -i -e "s/__attr.*;/;/"  \
		       -e "s/sys\/time.h/winsock2.h/" \
		       $DIST/include/openssl/*.h $DIST/include/*.h
	fi

	cp stage-$ARCH/usr/local/bin/* $DIST/$ARCH
	#cp /usr/$HOST/sys-root/mingw/bin/libssp* $DIST/$ARCH

	for i in libcrypto libssl libtls; do
		DLL=$(basename `ls -1 $DIST/$ARCH/$i*.dll`|cut -d. -f1)
		echo EXPORTS > $DLL.def
		dumpbin /exports $DIST/$ARCH/$DLL.dll | \
		    awk '{print $4}' | awk 'NF' |tail -n +9 >> $DLL.def
		lib /MACHINE:$ARCH /def:$DLL.def /out:$DIST/$ARCH/$DLL.lib
	cv2pdb $DIST/$ARCH/$DLL.dll
	done
done

zip -r $DIST.zip $DIST
