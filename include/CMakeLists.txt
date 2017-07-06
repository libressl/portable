install(DIRECTORY .
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        PATTERN "CMakeLists.txt" EXCLUDE
        PATTERN "compat" EXCLUDE
        PATTERN "Makefile*" EXCLUDE)
