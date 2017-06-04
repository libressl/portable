cmake_minimum_required (VERSION 2.8.8)

# find dumpbin.exe

set(DUMPBIN_2015 "C:\\Program Files (x86)\\Microsoft Visual Studio 14.0\\VC\\bin\\dumpbin.exe")
set(DUMPBIN_2013 "C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\VC\\bin\\dumpbin.exe")
set(DUMPBIN_2012 "C:\\Program Files (x86)\\Microsoft Visual Studio 11.0\\VC\\bin\\dumpbin.exe")

if(EXISTS ${DUMPBIN_2015})
	set(DUMPBIN ${DUMPBIN_2015})
elseif(EXISTS ${DUMPBIN_2013})
	set(DUMPBIN ${DUMPBIN_2013})
elseif(EXISTS ${DUMPBIN_2012})
	set(DUMPBIN ${DUMPBIN_2012})
else()
	set(DUMPBIN "")
endif()

# generate .DEF file

file(WRITE ${DEF_FILE} "EXPORTS\n")
file(READ ${SYM_FILE} SYMBOLS)

# add keyword 'DATA' after exported data symbols

string(REPLACE ".lib" ".dmp.txt" DMP_FILE ${LIB_FILE})
execute_process(COMMAND ${DUMPBIN} /symbols /out:${DMP_FILE} ${LIB_FILE})
file(READ ${DMP_FILE} DMP)
string(REPLACE "\n" ";" DMP ${DMP})
set(PATTERN "[0-9A-Z]+ [0-9A-Z]+ [0-9A-Z]+  notype       External     \\| ([0-9A-Za-z_]+)")
foreach(LINE IN LISTS DMP)
	if(${LINE} MATCHES ${PATTERN})
		string(REGEX REPLACE ${PATTERN} [[\1]] DATA ${LINE})
		string(REPLACE "${DATA}\n" "${DATA} DATA\n" SYMBOLS ${SYMBOLS})
	endif()
endforeach()

file(APPEND ${DEF_FILE} "${SYMBOLS}")

