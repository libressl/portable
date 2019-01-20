include_directories(
	.
	../crypto/modes
	../crypto/asn1
	../ssl
	../tls
	../apps/openssl
	../apps/openssl/compat
	../include/compat
)

add_definitions(-D_PATH_SSL_CA_FILE=\"${CMAKE_CURRENT_SOURCE_DIR}/../apps/openssl/cert.pem\")

file(TO_NATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR} TEST_SOURCE_DIR)

# aeadtest
add_executable(aeadtest aeadtest.c)
target_link_libraries(aeadtest ${OPENSSL_LIBS})
add_test(aeadtest aeadtest ${CMAKE_CURRENT_SOURCE_DIR}/aeadtests.txt)

# aes_wrap
add_executable(aes_wrap aes_wrap.c)
target_link_libraries(aes_wrap ${OPENSSL_LIBS})
add_test(aes_wrap aes_wrap)

# arc4randomforktest
# Windows/mingw does not have fork, but Cygwin does.
if(NOT (WIN32 OR (CMAKE_SYSTEM_NAME MATCHES "MINGW")))
	add_executable(arc4randomforktest arc4randomforktest.c)
	target_link_libraries(arc4randomforktest ${OPENSSL_LIBS})
	add_test(arc4randomforktest ${CMAKE_CURRENT_SOURCE_DIR}/arc4randomforktest.sh)
endif()

# asn1evp
add_executable(asn1evp asn1evp.c)
target_link_libraries(asn1evp ${OPENSSL_LIBS})
add_test(asn1evp asn1evp)

# asn1test
add_executable(asn1test asn1test.c)
target_link_libraries(asn1test ${OPENSSL_LIBS})
add_test(asn1test asn1test)

# asn1time
add_executable(asn1time asn1time.c)
target_link_libraries(asn1time ${OPENSSL_LIBS})
add_test(asn1time asn1time)

# base64test
add_executable(base64test base64test.c)
target_link_libraries(base64test ${OPENSSL_LIBS})
add_test(base64test base64test)

# bftest
add_executable(bftest bftest.c)
target_link_libraries(bftest ${OPENSSL_LIBS})
add_test(bftest bftest)

# biotest
# the BIO tests rely on resolver results that are OS and environment-specific
if(ENABLE_EXTRATESTS)
	add_executable(biotest biotest.c)
	target_link_libraries(biotest ${OPENSSL_LIBS})
	add_test(biotest biotest)
endif()

# bnaddsub
add_executable(bnaddsub bnaddsub.c)
target_link_libraries(bnaddsub ${OPENSSL_LIBS})
add_test(bnaddsub bnaddsub)

# bn_rand_interval
if(NOT BUILD_SHARED_LIBS)
	add_executable(bn_rand_interval bn_rand_interval.c)
	target_link_libraries(bn_rand_interval ${OPENSSL_LIBS})
	add_test(bn_rand_interval bn_rand_interval)
endif()

# bntest
if(NOT BUILD_SHARED_LIBS)
	add_executable(bntest bntest.c)
	set_source_files_properties(bntest.c PROPERTIES COMPILE_FLAGS
		-ULIBRESSL_INTERNAL)
	target_link_libraries(bntest ${OPENSSL_LIBS})
	add_test(bntest bntest)
endif()

# buffertest
if(NOT BUILD_SHARED_LIBS)
	add_executable(buffertest buffertest.c)
	target_link_libraries(buffertest ${OPENSSL_LIBS})
	add_test(buffertest buffertest)
endif()

# bytestringtest
if(NOT BUILD_SHARED_LIBS)
	add_executable(bytestringtest bytestringtest.c)
	target_link_libraries(bytestringtest ${OPENSSL_LIBS})
	add_test(bytestringtest bytestringtest)
endif()

# casttest
add_executable(casttest casttest.c)
target_link_libraries(casttest ${OPENSSL_LIBS})
add_test(casttest casttest)

# chachatest
add_executable(chachatest chachatest.c)
target_link_libraries(chachatest ${OPENSSL_LIBS})
add_test(chachatest chachatest)

# cipher_list
if(NOT BUILD_SHARED_LIBS)
	add_executable(cipher_list cipher_list.c)
	target_link_libraries(cipher_list ${OPENSSL_LIBS})
	add_test(cipher_list cipher_list)
endif()

# cipherstest
add_executable(cipherstest cipherstest.c)
target_link_libraries(cipherstest ${OPENSSL_LIBS})
add_test(cipherstest cipherstest)

# clienttest
add_executable(clienttest clienttest.c)
target_link_libraries(clienttest ${OPENSSL_LIBS})
add_test(clienttest clienttest)

# configtest
add_executable(configtest configtest.c)
target_link_libraries(configtest ${OPENSSL_LIBS})
add_test(configtest configtest)

# cts128test
add_executable(cts128test cts128test.c)
target_link_libraries(cts128test ${OPENSSL_LIBS})
add_test(cts128test cts128test)

# destest
add_executable(destest destest.c)
target_link_libraries(destest ${OPENSSL_LIBS})
add_test(destest destest)

# dhtest
add_executable(dhtest dhtest.c)
target_link_libraries(dhtest ${OPENSSL_LIBS})
add_test(dhtest dhtest)

# dsatest
add_executable(dsatest dsatest.c)
target_link_libraries(dsatest ${OPENSSL_LIBS})
add_test(dsatest dsatest)

# ecdhtest
add_executable(ecdhtest ecdhtest.c)
target_link_libraries(ecdhtest ${OPENSSL_LIBS})
add_test(ecdhtest ecdhtest)

# ecdsatest
add_executable(ecdsatest ecdsatest.c)
target_link_libraries(ecdsatest ${OPENSSL_LIBS})
add_test(ecdsatest ecdsatest)

# ectest
add_executable(ectest ectest.c)
target_link_libraries(ectest ${OPENSSL_LIBS})
add_test(ectest ectest)

# enginetest
add_executable(enginetest enginetest.c)
target_link_libraries(enginetest ${OPENSSL_LIBS})
add_test(enginetest enginetest)

# evptest
add_executable(evptest evptest.c)
target_link_libraries(evptest ${OPENSSL_LIBS})
add_test(evptest evptest ${CMAKE_CURRENT_SOURCE_DIR}/evptests.txt)

# explicit_bzero
# explicit_bzero relies on SA_ONSTACK, which is unavailable on Windows
if(NOT WIN32)
	if(HAVE_MEMMEM)
		add_executable(explicit_bzero explicit_bzero.c)
	else()
		add_executable(explicit_bzero explicit_bzero.c compat/memmem.c)
	endif()
	target_link_libraries(explicit_bzero ${OPENSSL_LIBS})
	add_test(explicit_bzero explicit_bzero)
endif()

# exptest
if(NOT BUILD_SHARED_LIBS)
	add_executable(exptest exptest.c)
	set_source_files_properties(exptest.c PROPERTIES COMPILE_FLAGS
		-ULIBRESSL_INTERNAL)
	target_link_libraries(exptest ${OPENSSL_LIBS})
	add_test(exptest exptest)
endif()

# freenull
add_executable(freenull freenull.c)
target_link_libraries(freenull ${OPENSSL_LIBS})
add_test(freenull freenull)

# gcm128test
add_executable(gcm128test gcm128test.c)
target_link_libraries(gcm128test ${OPENSSL_LIBS})
add_test(gcm128test gcm128test)

# gost2814789t
add_executable(gost2814789t gost2814789t.c)
target_link_libraries(gost2814789t ${OPENSSL_LIBS})
add_test(gost2814789t gost2814789t)

# hkdf_test
add_executable(hkdf_test hkdf_test.c)
target_link_libraries(hkdf_test ${OPENSSL_LIBS})
add_test(hkdf_test hkdf_test)

# hmactest
add_executable(hmactest hmactest.c)
target_link_libraries(hmactest ${OPENSSL_LIBS})
add_test(hmactest hmactest)

# ideatest
add_executable(ideatest ideatest.c)
target_link_libraries(ideatest ${OPENSSL_LIBS})
add_test(ideatest ideatest)

# igetest
add_executable(igetest igetest.c)
target_link_libraries(igetest ${OPENSSL_LIBS})
add_test(igetest igetest)

# keypairtest
if(NOT BUILD_SHARED_LIBS)
	add_executable(key_schedule key_schedule.c)
	target_link_libraries(key_schedule ${OPENSSL_LIBS})
	add_test(key_schedule key_schedule)

	add_executable(keypairtest keypairtest.c)
	target_link_libraries(keypairtest ${OPENSSL_LIBS})
	add_test(keypairtest keypairtest
		${CMAKE_CURRENT_SOURCE_DIR}/ca.pem
		${CMAKE_CURRENT_SOURCE_DIR}/server.pem
		${CMAKE_CURRENT_SOURCE_DIR}/server.pem)
endif()

# md4test
add_executable(md4test md4test.c)
target_link_libraries(md4test ${OPENSSL_LIBS})
add_test(md4test md4test)

# md5test
add_executable(md5test md5test.c)
target_link_libraries(md5test ${OPENSSL_LIBS})
add_test(md5test md5test)

# mont
add_executable(mont mont.c)
target_link_libraries(mont ${OPENSSL_LIBS})
add_test(mont mont)

# ocsp_test
if(ENABLE_EXTRATESTS)
	add_executable(ocsp_test ocsp_test.c)
	target_link_libraries(ocsp_test ${OPENSSL_LIBS})
	if(NOT MSVC)
		add_test(NAME ocsptest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ocsptest.sh)
	else()
		add_test(NAME ocsptest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ocsptest.bat $<TARGET_FILE:ocsp_test>)
	endif()
endif()

# optionstest
add_executable(optionstest optionstest.c)
target_link_libraries(optionstest ${OPENSSL_LIBS})
add_test(optionstest optionstest)

# pbkdf2
add_executable(pbkdf2 pbkdf2.c)
target_link_libraries(pbkdf2 ${OPENSSL_LIBS})
add_test(pbkdf2 pbkdf2)

# pidwraptest
# pidwraptest relies on an OS-specific way to give out pids and is generally
# awkward on systems with slow fork
if(ENABLE_EXTRATESTS AND NOT MSVC)
	add_executable(pidwraptest pidwraptest.c)
	target_link_libraries(pidwraptest ${OPENSSL_LIBS})
	add_test(pidwraptest ${CMAKE_CURRENT_SOURCE_DIR}/pidwraptest.sh)
endif()

# pkcs7test
add_executable(pkcs7test pkcs7test.c)
target_link_libraries(pkcs7test ${OPENSSL_LIBS})
add_test(pkcs7test pkcs7test)

# poly1305test
add_executable(poly1305test poly1305test.c)
target_link_libraries(poly1305test ${OPENSSL_LIBS})
add_test(poly1305test poly1305test)

# pq_test
if(NOT BUILD_SHARED_LIBS)
	add_executable(pq_test pq_test.c)
	target_link_libraries(pq_test ${OPENSSL_LIBS})
	if(NOT MSVC)
		add_test(NAME pq_test COMMAND
			${CMAKE_CURRENT_SOURCE_DIR}/pq_test.sh)
	else()
		add_test(NAME pq_test COMMAND
			${CMAKE_CURRENT_SOURCE_DIR}/pq_test.bat
			$<TARGET_FILE:pq_test>)
	endif()
	set_tests_properties(pq_test PROPERTIES ENVIRONMENT
		"srcdir=${TEST_SOURCE_DIR}")
endif()

# randtest
add_executable(randtest randtest.c)
target_link_libraries(randtest ${OPENSSL_LIBS})
add_test(randtest randtest)

# rc2test
add_executable(rc2test rc2test.c)
target_link_libraries(rc2test ${OPENSSL_LIBS})
add_test(rc2test rc2test)

# rc4test
add_executable(rc4test rc4test.c)
target_link_libraries(rc4test ${OPENSSL_LIBS})
add_test(rc4test rc4test)

# recordtest
if(NOT BUILD_SHARED_LIBS)
	add_executable(recordtest recordtest.c)
	target_link_libraries(recordtest ${OPENSSL_LIBS})
	add_test(recordtest recordtest)
endif()

# rfc5280time
add_executable(rfc5280time rfc5280time.c)
target_link_libraries(rfc5280time ${OPENSSL_LIBS})
if(SMALL_TIME_T)
	add_test(rfc5280time ${CMAKE_CURRENT_SOURCE_DIR}/rfc5280time_small.test)
else()
	add_test(rfc5280time rfc5280time)
endif()

# rmdtest
add_executable(rmdtest rmdtest.c)
target_link_libraries(rmdtest ${OPENSSL_LIBS})
add_test(rmdtest rmdtest)

# rsa_test
add_executable(rsa_test rsa_test.c)
target_link_libraries(rsa_test ${OPENSSL_LIBS})
add_test(rsa_test rsa_test)

# servertest
add_executable(servertest servertest.c)
target_link_libraries(servertest ${OPENSSL_LIBS})
if(NOT MSVC)
	add_test(NAME servertest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/servertest.sh)
else()
	add_test(NAME servertest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/servertest.bat $<TARGET_FILE:servertest>)
endif()
set_tests_properties(servertest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# sha1test
add_executable(sha1test sha1test.c)
target_link_libraries(sha1test ${OPENSSL_LIBS})
add_test(sha1test sha1test)

# sha256test
add_executable(sha256test sha256test.c)
target_link_libraries(sha256test ${OPENSSL_LIBS})
add_test(sha256test sha256test)

# sha512test
add_executable(sha512test sha512test.c)
target_link_libraries(sha512test ${OPENSSL_LIBS})
add_test(sha512test sha512test)

# sm3test
add_executable(sm3test sm3test.c)
target_link_libraries(sm3test ${OPENSSL_LIBS})
add_test(sm3test sm3test)

# ssl_versions
if(NOT BUILD_SHARED_LIBS)
	add_executable(ssl_versions ssl_versions.c)
	target_link_libraries(ssl_versions ${OPENSSL_LIBS})
	add_test(ssl_versions ssl_versions)
endif()

# ssltest
add_executable(ssltest ssltest.c)
target_link_libraries(ssltest ${OPENSSL_LIBS})
if(NOT MSVC)
	add_test(NAME ssltest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ssltest.sh)
else()
	add_test(NAME ssltest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ssltest.bat $<TARGET_FILE:ssltest> $<TARGET_FILE:openssl>)
endif()
set_tests_properties(ssltest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# testdsa
if(NOT MSVC)
	add_test(NAME testdsa COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/testdsa.sh)
else()
	add_test(NAME testdsa COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/testdsa.bat $<TARGET_FILE:openssl>)
endif()
set_tests_properties(testdsa PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# testenc
if(NOT MSVC)
	add_test(NAME testenc COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/testenc.sh)
else()
	add_test(NAME testenc COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/testenc.bat $<TARGET_FILE:openssl>)
endif()
set_tests_properties(testenc PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# testrsa
if(NOT MSVC)
	add_test(NAME testrsa COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/testrsa.sh)
else()
	add_test(NAME testrsa COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/testrsa.bat $<TARGET_FILE:openssl>)
endif()
set_tests_properties(testrsa PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# timingsafe
add_executable(timingsafe timingsafe.c)
target_link_libraries(timingsafe ${OPENSSL_LIBS})
add_test(timingsafe timingsafe)

# tlsexttest
if(NOT BUILD_SHARED_LIBS)
	add_executable(tlsexttest tlsexttest.c)
	target_link_libraries(tlsexttest ${OPENSSL_LIBS})
	add_test(tlsexttest tlsexttest)
endif()

# tlstest
set(TLSTEST_SRC tlstest.c)
check_function_exists(pipe2 HAVE_PIPE2)
if(HAVE_PIPE2)
	add_definitions(-DHAVE_PIPE2)
else()
	set(TLSTEST_SRC ${TLSTEST_SRC} compat/pipe2.c)
endif()

add_executable(tlstest ${TLSTEST_SRC})
target_link_libraries(tlstest ${OPENSSL_LIBS})
if(NOT MSVC)
	add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.sh)
else()
	add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.bat $<TARGET_FILE:tlstest>)
endif()
set_tests_properties(tlstest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# tls_ext_alpn
if(NOT BUILD_SHARED_LIBS)
	add_executable(tls_ext_alpn tls_ext_alpn.c)
	target_link_libraries(tls_ext_alpn ${OPENSSL_LIBS})
	add_test(tls_ext_alpn tls_ext_alpn)
endif()

# tls_prf
if(NOT BUILD_SHARED_LIBS)
	add_executable(tls_prf tls_prf.c)
	target_link_libraries(tls_prf ${OPENSSL_LIBS})
	add_test(tls_prf tls_prf)
endif()

# utf8test
if(NOT BUILD_SHARED_LIBS)
	add_executable(utf8test utf8test.c)
	target_link_libraries(utf8test ${OPENSSL_LIBS})
	add_test(utf8test utf8test)
endif()

add_executable(valid_handshakes_terminate valid_handshakes_terminate.c)
target_link_libraries(valid_handshakes_terminate ${OPENSSL_LIBS})
add_test(valid_handshakes_terminate valid_handshakes_terminate)

# verifytest
if(NOT BUILD_SHARED_LIBS)
	add_executable(verifytest verifytest.c)
	target_link_libraries(verifytest ${OPENSSL_LIBS})
	add_test(verifytest verifytest)
endif()

# x25519test
add_executable(x25519test x25519test.c)
target_link_libraries(x25519test ${OPENSSL_LIBS})
add_test(x25519test x25519test)

# x509name
add_executable(x509name x509name.c)
target_link_libraries(x509name ${OPENSSL_LIBS})
add_test(x509name x509name)

if(BUILD_SHARED_LIBS)
	add_custom_command(TARGET x25519test POST_BUILD
		COMMAND "${CMAKE_COMMAND}" -E copy
		"$<TARGET_FILE:tls>"
		"$<TARGET_FILE:ssl>"
		"$<TARGET_FILE:crypto>"
		"${CMAKE_CURRENT_BINARY_DIR}"
		COMMENT "Copying DLLs for regression tests")
endif()

