if(ENABLE_LIBRESSL_INSTALL)
	install(DIRECTORY .
        	DESTINATION include
	        PATTERN "CMakeLists.txt" EXCLUDE
        	PATTERN "compat" EXCLUDE
	        PATTERN "Makefile*" EXCLUDE)
endif(ENABLE_LIBRESSL_INSTALL)
