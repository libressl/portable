#
# Copyright (c) 2023 Pierre Wendling
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

cmake_minimum_required(VERSION 3.5)

project(LibreSSL_Consumer LANGUAGES C)

find_package(
  LibreSSL
  CONFIG
  REQUIRED
  COMPONENTS Crypto SSL TLS
)

set(RESULTS_TO_CHECK
  "LIBRESSL_VERSION"
  "LIBRESSL_FOUND"
  "LIBRESSL_INCLUDE_DIR"
  "LIBRESSL_LIBRARIES"
  "LIBRESSL_CRYPTO_LIBRARY"
  "LIBRESSL_SSL_LIBRARY"
  "LIBRESSL_TLS_LIBRARY"
)

foreach(RESULT_VAR IN LISTS RESULTS_TO_CHECK)
  if(${RESULT_VAR})
    message(STATUS "${RESULT_VAR}: ${${RESULT_VAR}}")
  else()
    message(FATAL_ERROR "${RESULT_VAR} was not set by the package.")
  endif()
endforeach()

add_executable(crypto crypto.c)
target_link_libraries(crypto PRIVATE LibreSSL::Crypto)

add_executable(ssl ssl.c)
target_link_libraries(ssl PRIVATE LibreSSL::SSL)

add_executable(tls tls.c)
target_link_libraries(tls PRIVATE LibreSSL::TLS)
