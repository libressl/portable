macro(export_symbol TARGET FILENAME STATIC_LIB)

	set(FLAG "")

	if(WIN32)
		string(REPLACE ".sym" ".def" DEF_FILENAME ${FILENAME})
		target_sources(${TARGET} PRIVATE ${DEF_FILENAME})
		add_custom_command(OUTPUT ${DEF_FILENAME}
		    COMMAND cmake ARGS -DSYM_FILE=${FILENAME}
		    -DDEF_FILE=${DEF_FILENAME}
		    -DLIB_FILE=$<TARGET_FILE:${STATIC_LIB}>
		    -P ${CMAKE_CURRENT_SOURCE_DIR}/../cmake_generate_def.cmake
		    DEPENDS ${STATIC_LIB}
		    COMMENTS generating ${DEF_FILENAME} file ...)

	elseif(APPLE)
		set(FLAG "-exported_symbols_list ${FILENAME}")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})

	elseif(CMAKE_SYSTEM_NAME MATCHES "HP-UX")
		file(READ ${FILENAME} SYMBOLS)
		string(REGEX REPLACE "\n$" "" SYMBOLS ${SYMBOLS})
		string(REPLACE "\n" "\n+e " SYMBOLS ${SYMBOLS})
		string(REPLACE ".sym" ".opt" OPT_FILENAME ${FILENAME})
		file(WRITE ${OPT_FILENAME} "+e ${SYMBOLS}")
		set(FLAG "-Wl,-c,${OPT_FILENAME}")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})

	elseif(CMAKE_SYSTEM_NAME MATCHES "SunOS")
		file(READ ${FILENAME} SYMBOLS)
		string(REPLACE "\n" ";\n" SYMBOLS ${SYMBOLS})
		string(REPLACE ".sym" ".ver" VER_FILENAME ${FILENAME})
		file(WRITE ${VER_FILENAME}
			"{\nglobal:\n${SYMBOLS}\nlocal:\n*;\n};\n")
		set(FLAG "-Wl,-M${VER_FILENAME}")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})

	elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID MATCHES "Clang")
		file(READ ${FILENAME} SYMBOLS)
		string(REPLACE "\n" ";\n" SYMBOLS ${SYMBOLS})
		string(REPLACE ".sym" ".ver" VER_FILENAME ${FILENAME})
		file(WRITE ${VER_FILENAME}
			"{\nglobal:\n${SYMBOLS}\nlocal:\n*;\n};\n")
		set(FLAG "-Wl,--version-script,\"${VER_FILENAME}\"")
		set_target_properties(${TARGET} PROPERTIES LINK_FLAGS ${FLAG})
	endif()

endmacro()
