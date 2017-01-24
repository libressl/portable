include_directories(
	.
	./compat
	../../include
	../../include/compat
)

set(
	OCSPCHECK_SRC
	http.c
	ocspcheck.c
)

if(NOT "${OPENSSLDIR}" STREQUAL "")
	add_definitions(-DDEFAULT_CA_FILE=\"${OPENSSLDIR}/cert.pem\")
else()
	add_definitions(-DDEFAULT_CA_FILE=\"${CMAKE_INSTALL_PREFIX}/etc/ssl/cert.pem\")
endif()

add_executable(ocspcheck ${OCSPCHECK_SRC})
target_link_libraries(ocspcheck tls ${OPENSSL_LIBS})

install(TARGETS ocspcheck DESTINATION bin)
install(FILES ocspcheck.8 DESTINATION share/man/man8)
