## Building with MinGW-w64 for 32- and 64-bit

For Windows systems, LibreSSL supports the MinGW-w64 toolchain, which can use
GCC or Clang as the compiler. Contrary to its name, MinGW-w64 supports both
32-bit and 64-bit build environments. If your project already uses MinGW-w64,
then LibreSSL should integrate very nicely. Old versions of the MinGW-w64
toolchain, such as the one packaged with Ubuntu 12.04, may have trouble
building LibreSSL. Please try it with a recent toolchain if you encounter
troubles. Cygwin provides an easy method of installing the latest MinGW-w64
cross-compilers on Windows.

To configure and build LibreSSL for a 32-bit system, use the following
build steps:

 CC=i686-w64-mingw32-gcc CPPFLAGS=-D__MINGW_USE_VC2005_COMPAT \
 ./configure --host=i686-w64-mingw32
 make
 make check

For 64-bit builds, use these instead:

 CC=x86_64-w64-mingw32-gcc ./configure --host=x86_64-w64-mingw32
 make
 make check

### Why the -D__MINGW_USE_VC2005_COMPAT flag on 32-bit systems?

An ABI change introduced with Microsoft Visual C++ 2005 (also known as
Visual C++ 8.0) switched time_t from 32-bit to 64-bit. It is important to
build LibreSSL with 64-bit time_t whenever possible, because 32-bit time_t
is unable to represent times past 2038 (this is commonly known as the
Y2K38 problem).

If LibreSSL is built with 32-bit time_t, when verifying a certificate whose
expiry date is set past 19 January 2038, it will be unable to tell if the
certificate has expired or not, and thus take the safe stance and reject it.

In order to avoid this, you need to build LibreSSL (and everything that links
with it) with the -D__MINGW_USE_VC2005_COMPAT flag. This tells MinGW-w64 to
use the new ABI.

64-bit systems always have a 64-bit time_t and are not affected by this
problem.
