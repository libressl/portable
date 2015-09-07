include_directories(
	.
	../include
	../include/compat
)

set(
	TLS_SRC
	tls.c
	tls_client.c
	tls_config.c
	tls_server.c
	tls_util.c
	tls_verify.c
)


if(NOT HAVE_STRCASECMP)
	set(TLS_SRC ${TLS_SRC} strsep.c)
endif()

add_library(tls-objects OBJECT ${TLS_SRC})
set_property(TARGET tls-objects PROPERTY POSITION_INDEPENDENT_CODE 1)
add_library(tls STATIC $<TARGET_OBJECTS:tls-objects>)
set(TLS_TARGETS tls)

if (BUILD_SHARED)
	add_library(tls-shared SHARED $<TARGET_OBJECTS:tls-objects>)
	set_target_properties(tls-shared PROPERTIES OUTPUT_NAME tls)
	set_target_properties(tls-shared PROPERTIES VERSION ${TLS_VERSION} SOVERSION ${TLS_MAJOR_VERSION})
	set(TLS_TARGETS ${TLS_TARGETS} tls-shared)
endif()

install(TARGETS ${TLS_TARGETS} DESTINATION lib)
