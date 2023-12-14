set(
	OCSPCHECK_SRC
	http.c
	ocspcheck.c
)

check_function_exists(memmem HAVE_MEMMEM)
if(HAVE_MEMMEM)
	add_definitions(-DHAVE_MEMMEM)
else()
	set(OCSPCHECK_SRC ${OCSPCHECK_SRC} compat/memmem.c)
endif()

add_definitions(-DDEFAULT_CA_FILE=\"${OPENSSLDIR}/cert.pem\")

add_executable(ocspcheck ${OCSPCHECK_SRC})
target_include_directories(ocspcheck
	PRIVATE
		../../include/compat
	PUBLIC
		../../include
		${CMAKE_BINARY_DIR}/include)
target_link_libraries(ocspcheck tls ${OPENSSL_LIBS} compat_obj tls_compat_obj)

if(ENABLE_LIBRESSL_INSTALL)
	install(TARGETS ocspcheck DESTINATION ${CMAKE_INSTALL_BINDIR})
	install(FILES ocspcheck.8 DESTINATION ${CMAKE_INSTALL_MANDIR}/man8)

endif(ENABLE_LIBRESSL_INSTALL)
