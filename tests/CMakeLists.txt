add_definitions(-DLIBRESSL_CRYPTO_INTERNAL)

include_directories(
	.
	../crypto/asn1
	../crypto/bio
	../crypto/evp
	../crypto/modes
	../crypto/x509
	../ssl
	../apps/openssl
	../apps/openssl/compat
	../include
	../include/compat
)

add_definitions(-D_PATH_SSL_CA_FILE=\"${CMAKE_CURRENT_SOURCE_DIR}/../cert.pem\")

file(TO_NATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR} TEST_SOURCE_DIR)

# aeadtest
add_executable(aeadtest aeadtest.c)
target_link_libraries(aeadtest ${OPENSSL_TEST_LIBS})
add_test(aeadtest aeadtest ${CMAKE_CURRENT_SOURCE_DIR}/aeadtests.txt)

# aes_wrap
add_executable(aes_wrap aes_wrap.c)
target_link_libraries(aes_wrap ${OPENSSL_TEST_LIBS})
add_test(aes_wrap aes_wrap)

# arc4randomforktest
# Windows/mingw does not have fork, but Cygwin does.
if(NOT (WIN32 OR (CMAKE_SYSTEM_NAME MATCHES "MINGW")))
	add_executable(arc4randomforktest arc4randomforktest.c)
	target_link_libraries(arc4randomforktest ${OPENSSL_TEST_LIBS})
	add_test(arc4randomforktest ${CMAKE_CURRENT_SOURCE_DIR}/arc4randomforktest.sh)
endif()

# asn1api
add_executable(asn1api asn1api.c)
target_link_libraries(asn1api ${OPENSSL_TEST_LIBS})
add_test(asn1api asn1api)

# asn1basic
add_executable(asn1basic asn1basic.c)
target_link_libraries(asn1basic ${OPENSSL_TEST_LIBS})
add_test(asn1basic asn1basic)

# asn1complex
add_executable(asn1complex asn1complex.c)
target_link_libraries(asn1complex ${OPENSSL_TEST_LIBS})
add_test(asn1complex asn1complex)

# asn1evp
add_executable(asn1evp asn1evp.c)
target_link_libraries(asn1evp ${OPENSSL_TEST_LIBS})
add_test(asn1evp asn1evp)

# asn1object
add_executable(asn1object asn1object.c)
target_link_libraries(asn1object ${OPENSSL_TEST_LIBS})
add_test(asn1object asn1object)

# asn1string_copy
add_executable(asn1string_copy asn1string_copy.c)
target_link_libraries(asn1string_copy ${OPENSSL_TEST_LIBS})
add_test(asn1string_copy asn1string_copy)

# asn1test
add_executable(asn1test asn1test.c)
target_link_libraries(asn1test ${OPENSSL_TEST_LIBS})
add_test(asn1test asn1test)

# asn1time
add_executable(asn1time asn1time.c)
target_link_libraries(asn1time ${OPENSSL_TEST_LIBS})
add_test(asn1time asn1time)

# asn1x509
add_executable(asn1x509 asn1x509.c)
target_link_libraries(asn1x509 ${OPENSSL_TEST_LIBS})
add_test(asn1x509 asn1x509)

# base64test
add_executable(base64test base64test.c)
target_link_libraries(base64test ${OPENSSL_TEST_LIBS})
add_test(base64test base64test)

# bftest
add_executable(bftest bftest.c)
target_link_libraries(bftest ${OPENSSL_TEST_LIBS})
add_test(bftest bftest)

# biotest
# the BIO tests rely on resolver results that are OS and environment-specific
if(ENABLE_EXTRATESTS)
	add_executable(biotest biotest.c)
	target_link_libraries(biotest ${OPENSSL_TEST_LIBS})
	add_test(biotest biotest)
endif()

# bnaddsub
add_executable(bnaddsub bnaddsub.c)
target_link_libraries(bnaddsub ${OPENSSL_TEST_LIBS})
add_test(bnaddsub bnaddsub)

# bn_mod_exp2_mont
add_executable(bn_mod_exp2_mont bn_mod_exp2_mont.c)
target_link_libraries(bn_mod_exp2_mont ${OPENSSL_TEST_LIBS})
add_test(bn_mod_exp2_mont bn_mod_exp2_mont)

# bn_mod_sqrt
add_executable(bn_mod_sqrt bn_mod_sqrt.c)
target_link_libraries(bn_mod_sqrt ${OPENSSL_TEST_LIBS})
add_test(bn_mod_sqrt bn_mod_sqrt)

# bn_rand_interval
add_executable(bn_rand_interval bn_rand_interval.c)
target_link_libraries(bn_rand_interval ${OPENSSL_TEST_LIBS})
add_test(bn_rand_interval bn_rand_interval)

# bntest
add_executable(bntest bntest.c)
set_source_files_properties(bntest.c PROPERTIES COMPILE_FLAGS
	-ULIBRESSL_INTERNAL)
target_link_libraries(bntest ${OPENSSL_TEST_LIBS})
add_test(bntest bntest)

# bn_to_string
add_executable(bn_to_string bn_to_string.c)
target_link_libraries(bn_to_string ${OPENSSL_TEST_LIBS})
add_test(bn_to_string bn_to_string)

# buffertest
add_executable(buffertest buffertest.c)
target_link_libraries(buffertest ${OPENSSL_TEST_LIBS})
add_test(buffertest buffertest)

# bytestringtest
add_executable(bytestringtest bytestringtest.c)
target_link_libraries(bytestringtest ${OPENSSL_TEST_LIBS})
add_test(bytestringtest bytestringtest)

# casttest
add_executable(casttest casttest.c)
target_link_libraries(casttest ${OPENSSL_TEST_LIBS})
add_test(casttest casttest)

# chachatest
add_executable(chachatest chachatest.c)
target_link_libraries(chachatest ${OPENSSL_TEST_LIBS})
add_test(chachatest chachatest)

# cipher_list
add_executable(cipher_list cipher_list.c)
target_link_libraries(cipher_list ${OPENSSL_TEST_LIBS})
add_test(cipher_list cipher_list)

# cipherstest
add_executable(cipherstest cipherstest.c)
target_link_libraries(cipherstest ${OPENSSL_TEST_LIBS})
add_test(cipherstest cipherstest)

# clienttest
add_executable(clienttest clienttest.c)
target_link_libraries(clienttest ${OPENSSL_TEST_LIBS})
add_test(clienttest clienttest)

# cmstest
add_executable(cmstest cmstest.c)
target_link_libraries(cmstest ${OPENSSL_TEST_LIBS})
add_test(cmstest cmstest)

# configtest
add_executable(configtest configtest.c)
target_link_libraries(configtest ${LIBTLS_TEST_LIBS})
add_test(configtest configtest)

# constraints
add_executable(constraints constraints.c)
target_link_libraries(constraints ${OPENSSL_TEST_LIBS})
add_test(constraints constraints)

# cts128test
add_executable(cts128test cts128test.c)
target_link_libraries(cts128test ${OPENSSL_TEST_LIBS})
add_test(cts128test cts128test)

# destest
add_executable(destest destest.c)
target_link_libraries(destest ${OPENSSL_TEST_LIBS})
add_test(destest destest)

# dhtest
add_executable(dhtest dhtest.c)
target_link_libraries(dhtest ${OPENSSL_TEST_LIBS})
add_test(dhtest dhtest)

# dsatest
add_executable(dsatest dsatest.c)
target_link_libraries(dsatest ${OPENSSL_TEST_LIBS})
add_test(dsatest dsatest)

# dtlstest
if(NOT WIN32)
	add_executable(dtlstest dtlstest.c)
	target_link_libraries(dtlstest ${OPENSSL_TEST_LIBS})
	add_test(NAME dtlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/dtlstest.sh)
	set_tests_properties(dtlstest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")
endif()

# ec_asn1_test
add_executable(ec_asn1_test ec_asn1_test.c)
target_link_libraries(ec_asn1_test ${OPENSSL_TEST_LIBS})
add_test(ec_asn1_test ec_asn1_test)

# ec_point_conversion
add_executable(ec_point_conversion ec_point_conversion.c)
target_link_libraries(ec_point_conversion ${OPENSSL_TEST_LIBS})
add_test(ec_point_conversion ec_point_conversion)

# ecdhtest
add_executable(ecdhtest ecdhtest.c)
target_link_libraries(ecdhtest ${OPENSSL_TEST_LIBS})
add_test(ecdhtest ecdhtest)

# ecdsatest
add_executable(ecdsatest ecdsatest.c)
target_link_libraries(ecdsatest ${OPENSSL_TEST_LIBS})
add_test(ecdsatest ecdsatest)

# ectest
add_executable(ectest ectest.c)
target_link_libraries(ectest ${OPENSSL_TEST_LIBS})
add_test(ectest ectest)

# enginetest
add_executable(enginetest enginetest.c)
target_link_libraries(enginetest ${OPENSSL_TEST_LIBS})
add_test(enginetest enginetest)

# evp_pkey_check
add_executable(evp_pkey_check evp_pkey_check.c)
target_link_libraries(evp_pkey_check ${OPENSSL_TEST_LIBS})
add_test(evp_pkey_check evp_pkey_check)

# evp_pkey_cleanup
add_executable(evp_pkey_cleanup evp_pkey_cleanup.c)
target_link_libraries(evp_pkey_cleanup ${OPENSSL_TEST_LIBS})
add_test(evp_pkey_cleanup evp_pkey_cleanup)

# evptest
add_executable(evptest evptest.c)
target_link_libraries(evptest ${OPENSSL_TEST_LIBS})
add_test(evptest evptest ${CMAKE_CURRENT_SOURCE_DIR}/evptests.txt)

# explicit_bzero
# explicit_bzero relies on SA_ONSTACK, which is unavailable on Windows
if(NOT WIN32)
	if(HAVE_MEMMEM)
		add_executable(explicit_bzero explicit_bzero.c)
	else()
		add_executable(explicit_bzero explicit_bzero.c compat/memmem.c)
	endif()
	target_link_libraries(explicit_bzero ${OPENSSL_TEST_LIBS})
	add_test(explicit_bzero explicit_bzero)
endif()

# exptest
add_executable(exptest exptest.c)
set_source_files_properties(exptest.c PROPERTIES COMPILE_FLAGS
	-ULIBRESSL_INTERNAL)
target_link_libraries(exptest ${OPENSSL_TEST_LIBS})
add_test(exptest exptest)

# freenull
add_executable(freenull freenull.c)
target_link_libraries(freenull ${OPENSSL_TEST_LIBS})
add_test(freenull freenull)

# gcm128test
add_executable(gcm128test gcm128test.c)
target_link_libraries(gcm128test ${OPENSSL_TEST_LIBS})
add_test(gcm128test gcm128test)

# gost2814789t
add_executable(gost2814789t gost2814789t.c)
target_link_libraries(gost2814789t ${OPENSSL_TEST_LIBS})
add_test(gost2814789t gost2814789t)

# handshake_table
add_executable(handshake_table handshake_table.c)
target_link_libraries(handshake_table ${OPENSSL_TEST_LIBS})
add_test(handshake_table handshake_table)

# hkdf_test
add_executable(hkdf_test hkdf_test.c)
target_link_libraries(hkdf_test ${OPENSSL_TEST_LIBS})
add_test(hkdf_test hkdf_test)

# hmactest
add_executable(hmactest hmactest.c)
target_link_libraries(hmactest ${OPENSSL_TEST_LIBS})
add_test(hmactest hmactest)

# ideatest
add_executable(ideatest ideatest.c)
target_link_libraries(ideatest ${OPENSSL_TEST_LIBS})
add_test(ideatest ideatest)

# igetest
add_executable(igetest igetest.c)
target_link_libraries(igetest ${OPENSSL_TEST_LIBS})
add_test(igetest igetest)

# keypairtest
add_executable(key_schedule key_schedule.c)
target_link_libraries(key_schedule ${OPENSSL_TEST_LIBS})
add_test(key_schedule key_schedule)

add_executable(keypairtest keypairtest.c)
target_link_libraries(keypairtest ${LIBTLS_TEST_LIBS})
target_include_directories(keypairtest BEFORE PUBLIC ../tls)
add_test(keypairtest keypairtest
	${CMAKE_CURRENT_SOURCE_DIR}/ca.pem
	${CMAKE_CURRENT_SOURCE_DIR}/server.pem
	${CMAKE_CURRENT_SOURCE_DIR}/server.pem)

# md4test
add_executable(md4test md4test.c)
target_link_libraries(md4test ${OPENSSL_TEST_LIBS})
add_test(md4test md4test)

# md5test
add_executable(md5test md5test.c)
target_link_libraries(md5test ${OPENSSL_TEST_LIBS})
add_test(md5test md5test)

# mont
add_executable(mont mont.c)
target_link_libraries(mont ${OPENSSL_TEST_LIBS})
add_test(mont mont)

# objectstest
add_executable(objectstest objectstest.c)
target_link_libraries(objectstest ${OPENSSL_TEST_LIBS})
add_test(objectstest objectstest)

# ocsp_test
if(ENABLE_EXTRATESTS)
	add_executable(ocsp_test ocsp_test.c)
	target_link_libraries(ocsp_test ${OPENSSL_TEST_LIBS})
	if(NOT MSVC)
		add_test(NAME ocsptest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ocsptest.sh)
	else()
		add_test(NAME ocsptest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ocsptest.bat $<TARGET_FILE:ocsp_test>)
	endif()
endif()

# optionstest
add_executable(optionstest optionstest.c)
target_link_libraries(optionstest ${OPENSSL_TEST_LIBS})
add_test(optionstest optionstest)

# pbkdf2
add_executable(pbkdf2 pbkdf2.c)
target_link_libraries(pbkdf2 ${OPENSSL_TEST_LIBS})
add_test(pbkdf2 pbkdf2)

# pidwraptest
# pidwraptest relies on an OS-specific way to give out pids and is generally
# awkward on systems with slow fork
if(ENABLE_EXTRATESTS AND NOT MSVC)
	add_executable(pidwraptest pidwraptest.c)
	target_link_libraries(pidwraptest ${OPENSSL_TEST_LIBS})
	add_test(pidwraptest ${CMAKE_CURRENT_SOURCE_DIR}/pidwraptest.sh)
endif()

# pkcs7test
add_executable(pkcs7test pkcs7test.c)
target_link_libraries(pkcs7test ${OPENSSL_TEST_LIBS})
add_test(pkcs7test pkcs7test)

# poly1305test
add_executable(poly1305test poly1305test.c)
target_link_libraries(poly1305test ${OPENSSL_TEST_LIBS})
add_test(poly1305test poly1305test)

# pq_test
add_executable(pq_test pq_test.c)
target_link_libraries(pq_test ${OPENSSL_TEST_LIBS})
if(NOT MSVC)
	add_test(NAME pq_test COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/pq_test.sh)
else()
	add_test(NAME pq_test COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/pq_test.bat
		$<TARGET_FILE:pq_test>)
endif()
set_tests_properties(pq_test PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# randtest
add_executable(randtest randtest.c)
target_link_libraries(randtest ${OPENSSL_TEST_LIBS})
add_test(randtest randtest)

# rc2test
add_executable(rc2test rc2test.c)
target_link_libraries(rc2test ${OPENSSL_TEST_LIBS})
add_test(rc2test rc2test)

# rc4test
add_executable(rc4test rc4test.c)
target_link_libraries(rc4test ${OPENSSL_TEST_LIBS})
add_test(rc4test rc4test)

# recordtest
add_executable(recordtest recordtest.c)
target_link_libraries(recordtest ${OPENSSL_TEST_LIBS})
add_test(recordtest recordtest)

# record_layer_test
add_executable(record_layer_test record_layer_test.c)
target_link_libraries(record_layer_test ${OPENSSL_TEST_LIBS})
add_test(record_layer_test record_layer_test)

# rfc3779
add_executable(rfc3779 rfc3779.c)
set_source_files_properties(rfc3779.c PROPERTIES COMPILE_FLAGS -D__unused=)
target_link_libraries(rfc3779 ${OPENSSL_TEST_LIBS})
add_test(rfc3779 rfc3779)

# rfc5280time
add_executable(rfc5280time rfc5280time.c)
target_link_libraries(rfc5280time ${OPENSSL_TEST_LIBS})
if(SMALL_TIME_T)
	add_test(rfc5280time ${CMAKE_CURRENT_SOURCE_DIR}/rfc5280time_small.test)
else()
	add_test(rfc5280time rfc5280time)
endif()

# rmdtest
add_executable(rmdtest rmdtest.c)
target_link_libraries(rmdtest ${OPENSSL_TEST_LIBS})
add_test(rmdtest rmdtest)

# rsa_test
add_executable(rsa_test rsa_test.c)
target_link_libraries(rsa_test ${OPENSSL_TEST_LIBS})
add_test(rsa_test rsa_test)

# servertest
add_executable(servertest servertest.c)
target_link_libraries(servertest ${OPENSSL_TEST_LIBS})
if(NOT MSVC)
	add_test(NAME servertest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/servertest.sh)
else()
	add_test(NAME servertest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/servertest.bat $<TARGET_FILE:servertest>)
endif()
set_tests_properties(servertest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# sha1test
add_executable(sha1test sha1test.c)
target_link_libraries(sha1test ${OPENSSL_TEST_LIBS})
add_test(sha1test sha1test)

# sha256test
add_executable(sha256test sha256test.c)
target_link_libraries(sha256test ${OPENSSL_TEST_LIBS})
add_test(sha256test sha256test)

# sha512test
add_executable(sha512test sha512test.c)
target_link_libraries(sha512test ${OPENSSL_TEST_LIBS})
add_test(sha512test sha512test)

# sm3test
add_executable(sm3test sm3test.c)
target_link_libraries(sm3test ${OPENSSL_TEST_LIBS})
add_test(sm3test sm3test)

# sm4test
add_executable(sm4test sm4test.c)
target_link_libraries(sm4test ${OPENSSL_TEST_LIBS})
add_test(sm4test sm4test)

# ssl_get_shared_ciphers
add_executable(ssl_get_shared_ciphers ssl_get_shared_ciphers.c)
set_source_files_properties(ssl_get_shared_ciphers.c PROPERTIES COMPILE_FLAGS
	-DCERTSDIR=\\"${CMAKE_CURRENT_SOURCE_DIR}\\")
target_link_libraries(ssl_get_shared_ciphers ${OPENSSL_TEST_LIBS})
add_test(ssl_get_shared_ciphers ssl_get_shared_ciphers)

# ssl_methods
add_executable(ssl_methods ssl_methods.c)
target_link_libraries(ssl_methods ${OPENSSL_TEST_LIBS})
add_test(ssl_methods ssl_methods)

# ssl_versions
add_executable(ssl_versions ssl_versions.c)
target_link_libraries(ssl_versions ${OPENSSL_TEST_LIBS})
add_test(ssl_versions ssl_versions)

# ssltest
add_executable(ssltest ssltest.c)
target_link_libraries(ssltest ${OPENSSL_TEST_LIBS})
if(NOT MSVC)
	add_test(NAME ssltest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ssltest.sh)
else()
	add_test(NAME ssltest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/ssltest.bat $<TARGET_FILE:ssltest> $<TARGET_FILE:openssl>)
endif()
set_tests_properties(ssltest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# string_table
add_executable(string_table string_table.c)
target_link_libraries(string_table ${OPENSSL_TEST_LIBS})
add_test(string_table string_table)

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
target_link_libraries(timingsafe ${OPENSSL_TEST_LIBS})
add_test(timingsafe timingsafe)

# tlsexttest
add_executable(tlsexttest tlsexttest.c)
target_link_libraries(tlsexttest ${OPENSSL_TEST_LIBS})
add_test(tlsexttest tlsexttest)

# tlslegacytest
add_executable(tlslegacytest tlslegacytest.c)
target_link_libraries(tlslegacytest ${OPENSSL_TEST_LIBS})
add_test(tlslegacytest tlslegacytest)

# tlstest
if(NOT CMAKE_SYSTEM_NAME MATCHES "WindowsStore")
	set(TLSTEST_SRC tlstest.c)
	check_function_exists(pipe2 HAVE_PIPE2)
	if(HAVE_PIPE2)
		add_definitions(-DHAVE_PIPE2)
	else()
		set(TLSTEST_SRC ${TLSTEST_SRC} compat/pipe2.c)
	endif()

	add_executable(tlstest ${TLSTEST_SRC})
	target_link_libraries(tlstest ${LIBTLS_TEST_LIBS})
	if(NOT MSVC)
		add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.sh)
	else()
		add_test(NAME tlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tlstest.bat $<TARGET_FILE:tlstest>)
	endif()
	set_tests_properties(tlstest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")
endif()

# tls_ext_alpn
add_executable(tls_ext_alpn tls_ext_alpn.c)
target_link_libraries(tls_ext_alpn ${OPENSSL_TEST_LIBS})
add_test(tls_ext_alpn tls_ext_alpn)

# tls_prf
add_executable(tls_prf tls_prf.c)
target_link_libraries(tls_prf ${OPENSSL_TEST_LIBS})
add_test(tls_prf tls_prf)

# utf8test
add_executable(utf8test utf8test.c)
target_link_libraries(utf8test ${OPENSSL_TEST_LIBS})
add_test(utf8test utf8test)

# valid_handshakes_terminate
add_executable(valid_handshakes_terminate valid_handshakes_terminate.c)
target_link_libraries(valid_handshakes_terminate ${OPENSSL_TEST_LIBS})
add_test(valid_handshakes_terminate valid_handshakes_terminate)

# verifytest
add_executable(verifytest verifytest.c)
target_link_libraries(verifytest ${LIBTLS_TEST_LIBS})
add_test(verifytest verifytest)

# x25519test
add_executable(x25519test x25519test.c)
target_link_libraries(x25519test ${OPENSSL_TEST_LIBS})
add_test(x25519test x25519test)

# x509attribute
add_executable(x509attribute x509attribute.c)
target_link_libraries(x509attribute ${OPENSSL_TEST_LIBS})
add_test(x509attribute x509attribute)

# x509_info
add_executable(x509_info x509_info.c)
target_link_libraries(x509_info ${OPENSSL_TEST_LIBS})
add_test(x509_info x509_info)

# x509name
add_executable(x509name x509name.c)
target_link_libraries(x509name ${OPENSSL_TEST_LIBS})
add_test(x509name x509name)

# x509req_ext
add_executable(x509req_ext x509req_ext.c)
target_link_libraries(x509req_ext ${OPENSSL_TEST_LIBS})
add_test(x509req_ext x509req_ext)

add_custom_command(TARGET x25519test POST_BUILD
	COMMAND "${CMAKE_COMMAND}" -E copy
	"$<TARGET_FILE:tls>"
	"$<TARGET_FILE:ssl>"
	"$<TARGET_FILE:crypto>"
	"${CMAKE_CURRENT_BINARY_DIR}"
	COMMENT "Copying DLLs for regression tests")
