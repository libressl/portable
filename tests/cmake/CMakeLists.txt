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
