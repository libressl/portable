#
# Copyright (c) 2016 Kinichiro Inoguchi
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

if(BUILD_NC)

set(
	NC_SRC
	atomicio.c
	netcat.c
	socks.c
	compat/socket.c
)

check_function_exists(b64_ntop HAVE_B64_NTOP)
if(HAVE_B64_NTOP)
	add_definitions(-DHAVE_B64_NTOP)
else()
	set(NC_SRC ${NC_SRC} compat/base64.c)
endif()

check_function_exists(accept4 HAVE_ACCEPT4)
if(HAVE_ACCEPT4)
	add_definitions(-DHAVE_ACCEPT4)
else()
	set(NC_SRC ${NC_SRC} compat/accept4.c)
endif()

check_symbol_exists(readpassphrase "readpassphrase.h" HAVE_READPASSPHRASE)
if(HAVE_READPASSPHRASE)
	add_definitions(-DHAVE_READPASSPHRASE)
else()
	set(NC_SRC ${NC_SRC} compat/readpassphrase.c)
endif()

add_definitions(-DDEFAULT_CA_FILE=\"${OPENSSLDIR}/cert.pem\")

add_executable(nc ${NC_SRC})
target_include_directories(nc
	PRIVATE
		.
		./compat
		../../include/compat
	PUBLIC
		../../include
		${CMAKE_BINARY_DIR}/include)
target_link_libraries(nc ${LIBTLS_LIBS} compat_obj)

if(ENABLE_NC)
	if(ENABLE_LIBRESSL_INSTALL)
		install(TARGETS nc DESTINATION ${CMAKE_INSTALL_BINDIR})
		install(FILES nc.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
	endif(ENABLE_LIBRESSL_INSTALL)
endif()

endif()
