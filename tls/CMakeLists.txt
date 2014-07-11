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

add_library(tls ${TLS_SRC})
