include_directories(
	.
	../include
	../include/compat
	./openssl
)

set(
	OPENSSL_SRC
	openssl/apps.c
	openssl/asn1pars.c
	openssl/ca.c
	openssl/ciphers.c
	openssl/cms.c
	openssl/crl.c
	openssl/crl2p7.c
	openssl/dgst.c
	openssl/dh.c
	openssl/dhparam.c
	openssl/dsa.c
	openssl/dsaparam.c
	openssl/ec.c
	openssl/ecparam.c
	openssl/enc.c
	openssl/errstr.c
	openssl/gendh.c
	openssl/gendsa.c
	openssl/genpkey.c
	openssl/genrsa.c
	openssl/nseq.c
	openssl/ocsp.c
	openssl/openssl.c
	openssl/passwd.c
	openssl/pkcs12.c
	openssl/pkcs7.c
	openssl/pkcs8.c
	openssl/pkey.c
	openssl/pkeyparam.c
	openssl/pkeyutl.c
	openssl/prime.c
	openssl/rand.c
	openssl/req.c
	openssl/rsa.c
	openssl/rsautl.c
	openssl/s_cb.c
	openssl/s_client.c
	openssl/s_server.c
	openssl/s_socket.c
	openssl/s_time.c
	openssl/sess_id.c
	openssl/smime.c
	openssl/speed.c
	openssl/spkac.c
	openssl/ts.c
	openssl/verify.c
	openssl/version.c
	openssl/x509.c
)

if(CMAKE_HOST_UNIX)
	set(OPENSSL_SRC ${OPENSSL_SRC} openssl/apps_posix.c)
	set(OPENSSL_SRC ${OPENSSL_SRC} openssl/certhash.c)
endif()

if(CMAKE_HOST_WIN32)
	set(OPENSSL_SRC ${OPENSSL_SRC} openssl/compat/apps_win.c)
	set(OPENSSL_SRC ${OPENSSL_SRC} openssl/compat/certhash_win.c)
	set(OPENSSL_SRC ${OPENSSL_SRC} openssl/compat/poll_win.c)
endif()

check_function_exists(strtonum HAVE_STRTONUM)
if(HAVE_STRTONUM)
	add_definitions(-DHAVE_STRTONUM)
else()
	set(OPENSSL_SRC ${OPENSSL_SRC} openssl/compat/strtonum.c)
endif()

add_executable(openssl ${OPENSSL_SRC})
target_link_libraries(openssl ${OPENSSL_LIBS})

install(TARGETS openssl DESTINATION bin)
