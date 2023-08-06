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
endif()
file(WRITE ${CMAKE_BINARY_DIR}/include/openssl/opensslconf.h "${OPENSSLCONF}")
