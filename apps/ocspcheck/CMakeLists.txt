if(NOT MSVC)

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

check_function_exists(strtonum HAVE_STRTONUM)
if(HAVE_STRTONUM AND CMAKE_SYSTEM_NAME MATCHES "Darwin" AND
    CMAKE_HOST_SYSTEM_VERSION VERSION_GREATER_EQUAL 20)
	add_definitions(-DHAVE_STRTONUM)
else()
	set(OCSPCHECK_SRC ${OCSPCHECK_SRC} compat/strtonum.c)
endif()

if(NOT "${OPENSSLDIR}" STREQUAL "")
	add_definitions(-DDEFAULT_CA_FILE=\"${OPENSSLDIR}/cert.pem\")
else()
	add_definitions(-DDEFAULT_CA_FILE=\"${CMAKE_INSTALL_PREFIX}/etc/ssl/cert.pem\")
endif()

add_executable(ocspcheck ${OCSPCHECK_SRC})
target_include_directories(ocspcheck PRIVATE . ./compat ../../include/compat)
target_link_libraries(ocspcheck tls ${OPENSSL_LIBS})

if(ENABLE_LIBRESSL_INSTALL)
	install(TARGETS ocspcheck DESTINATION ${CMAKE_INSTALL_BINDIR})
	install(FILES ocspcheck.8 DESTINATION ${CMAKE_INSTALL_MANDIR}/man8)

endif(ENABLE_LIBRESSL_INSTALL)

endif()
