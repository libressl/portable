include_directories(
	.
	../include
	../include/compat
)

set(
	SSL_SRC
	bio_ssl.c
	bs_ber.c
	bs_cbb.c
	bs_cbs.c
	d1_both.c
	d1_clnt.c
	d1_enc.c
	d1_lib.c
	d1_meth.c
	d1_pkt.c
	d1_srtp.c
	d1_srvr.c
	pqueue.c
	s3_cbc.c
	s3_lib.c
	ssl_algs.c
	ssl_asn1.c
	ssl_both.c
	ssl_cert.c
	ssl_ciph.c
	ssl_clnt.c
	ssl_err.c
	ssl_init.c
	ssl_lib.c
	ssl_packet.c
	ssl_pkt.c
	ssl_rsa.c
	ssl_sess.c
	ssl_srvr.c
	ssl_stat.c
	ssl_tlsext.c
	ssl_txt.c
	ssl_versions.c
	t1_clnt.c
	t1_enc.c
	t1_hash.c
	t1_lib.c
	t1_meth.c
	t1_srvr.c
)

add_library(ssl ${SSL_SRC})
if (BUILD_SHARED_LIBS)
	export_symbol(ssl ${CMAKE_CURRENT_SOURCE_DIR}/ssl.sym)
	target_link_libraries(ssl crypto)
	if (WIN32)
		target_link_libraries(ssl Ws2_32.lib)
		set(SSL_POSTFIX -${SSL_MAJOR_VERSION})
	endif()
	set_target_properties(ssl PROPERTIES
		OUTPUT_NAME ssl${SSL_POSTFIX}
		ARCHIVE_OUTPUT_NAME ssl${SSL_POSTFIX})
	set_target_properties(ssl PROPERTIES VERSION ${SSL_VERSION}
		SOVERSION ${SSL_MAJOR_VERSION})
endif()

if(ENABLE_LIBRESSL_INSTALL)
	install(
		TARGETS ssl
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
endif(ENABLE_LIBRESSL_INSTALL)
