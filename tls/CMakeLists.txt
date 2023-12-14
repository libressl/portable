set(
	TLS_SRC
	tls.c
	tls_bio_cb.c
	tls_client.c
	tls_config.c
	tls_conninfo.c
	tls_keypair.c
	tls_server.c
	tls_signer.c
	tls_ocsp.c
	tls_peer.c
	tls_util.c
	tls_verify.c
)

set(TLS_COMPAT_SRC empty.c)

if(WIN32)
	set(
		TLS_SRC
		${TLS_SRC}
	)

	set(TLS_COMPAT_SRC ${TLS_COMPAT_SRC} compat/ftruncate.c)
	set(TLS_COMPAT_SRC ${TLS_COMPAT_SRC} compat/pread.c)
	set(TLS_COMPAT_SRC ${TLS_COMPAT_SRC} compat/pwrite.c)
endif()

add_definitions(-DTLS_DEFAULT_CA_FILE=\"${OPENSSLDIR}/cert.pem\")

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/tls.sym DESTINATION
	${CMAKE_CURRENT_BINARY_DIR})

add_library(tls_compat_obj OBJECT ${TLS_COMPAT_SRC})
target_include_directories(tls_compat_obj
	PRIVATE
		.
		../include/compat
	PUBLIC
		../include
		${CMAKE_BINARY_DIR}/include)

add_library(tls_obj OBJECT ${TLS_SRC})
target_include_directories(tls_obj
	PRIVATE
		.
		../include/compat
	PUBLIC
		../include
		${CMAKE_BINARY_DIR}/include)

if(BUILD_SHARED_LIBS)
	add_library(tls $<TARGET_OBJECTS:tls_obj> $<TARGET_OBJECTS:tls_compat_obj> $<TARGET_OBJECTS:compat_obj> empty.c)
else()
	add_library(tls $<TARGET_OBJECTS:tls_obj> $<TARGET_OBJECTS:tls_compat_obj> empty.c)
endif()

export_symbol(tls ${CMAKE_CURRENT_BINARY_DIR}/tls.sym)
target_link_libraries(tls ${OPENSSL_LIBS})
if (WIN32)
	set(TLS_POSTFIX -${TLS_MAJOR_VERSION} PARENT_SCOPE)
endif()
set_target_properties(tls PROPERTIES
	OUTPUT_NAME tls${TLS_POSTFIX}
	ARCHIVE_OUTPUT_NAME tls${TLS_POSTFIX}
	EXPORT_NAME TLS
	VERSION ${TLS_VERSION}
	SOVERSION ${TLS_MAJOR_VERSION}
)

target_include_directories(
	tls
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

install(
	TARGETS tls
	EXPORT TLS-target
)

export(
	EXPORT TLS-target
	FILE "${LibreSSL_BINARY_DIR}/LibreSSL-TLS.cmake"
	NAMESPACE LibreSSL::
)

if(ENABLE_LIBRESSL_INSTALL)
	install(
		TARGETS tls
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
	install(
		EXPORT TLS-target
		FILE "LibreSSL-TLS.cmake"
		NAMESPACE LibreSSL::
		DESTINATION "${LIBRESSL_INSTALL_CMAKEDIR}"
	)
endif(ENABLE_LIBRESSL_INSTALL)

# build static library for regression test
if(BUILD_SHARED_LIBS)
	add_library(tls-static STATIC $<TARGET_OBJECTS:tls_obj>)
	target_link_libraries(tls-static ${OPENSSL_TEST_LIBS})
endif()

