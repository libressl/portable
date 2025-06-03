#
# Copyright (c) 2016 Jeff Davey
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

if(ENABLE_LIBRESSL_INSTALL)
	install(DIRECTORY .
	        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	        PATTERN "CMakeLists.txt" EXCLUDE
	        PATTERN "compat" EXCLUDE
	        PATTERN "pqueue.h" EXCLUDE
	        PATTERN "Makefile*" EXCLUDE
	        PATTERN "arch" EXCLUDE)
	install(FILES ${CMAKE_BINARY_DIR}/include/openssl/opensslconf.h
	        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/openssl")
endif(ENABLE_LIBRESSL_INSTALL)

file(COPY .
	DESTINATION "${CMAKE_BINARY_DIR}/include"
	PATTERN "CMakeLists.txt" EXCLUDE
	PATTERN "compat" EXCLUDE
	PATTERN "pqueue.h" EXCLUDE
	PATTERN "Makefile*" EXCLUDE
	PATTERN "arch" EXCLUDE)

if(HOST_AARCH64)
	file(READ arch/aarch64/opensslconf.h OPENSSLCONF)
elseif(HOST_ARM)
	file(READ arch/arm/opensslconf.h OPENSSLCONF)
elseif(HOST_I386)
	file(READ arch/i386/opensslconf.h OPENSSLCONF)
elseif(HOST_LOONGARCH64)
	file(READ arch/loongarch64/opensslconf.h OPENSSLCONF)
elseif(HOST_MIPS)
	file(READ arch/mips/opensslconf.h OPENSSLCONF)
elseif(HOST_MIPS64)
	file(READ arch/mips64/opensslconf.h OPENSSLCONF)
elseif(HOST_POWERPC)
	file(READ arch/powerpc/opensslconf.h OPENSSLCONF)
elseif(HOST_POWERPC64)
	file(READ arch/powerpc64/opensslconf.h OPENSSLCONF)
elseif(HOST_RISCV64)
	file(READ arch/riscv64/opensslconf.h OPENSSLCONF)
elseif(HOST_SPARC64)
	file(READ arch/sparc64/opensslconf.h OPENSSLCONF)
elseif(HOST_X86_64)
	file(READ arch/amd64/opensslconf.h OPENSSLCONF)
else()
	message(FATAL_ERROR "Architecture not supported")
endif()
file(WRITE ${CMAKE_BINARY_DIR}/include/openssl/opensslconf.h "${OPENSSLCONF}")
