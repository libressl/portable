add_definitions(-DLIBRESSL_CRYPTO_INTERNAL)

include_directories(
	.
	../crypto/asn1
	../crypto/bio
	../crypto/bn
	../crypto/curve25519
	../crypto/evp
	../crypto/modes
	../crypto/x509
	../ssl
	../apps/openssl
	../apps/openssl/compat
	../include
	${CMAKE_BINARY_DIR}/include
	../include/compat
)

add_definitions(-D_PATH_SSL_CA_FILE=\"${CMAKE_CURRENT_SOURCE_DIR}/../cert.pem\")

file(TO_NATIVE_PATH ${CMAKE_CURRENT_SOURCE_DIR} TEST_SOURCE_DIR)

# aeadtest
add_executable(aeadtest aeadtest.c)
target_link_libraries(aeadtest ${OPENSSL_TEST_LIBS})
if(NOT WIN32)
	add_test(NAME aeadtest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/aeadtest.sh)
	set_tests_properties(aeadtest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")
else()
	add_test(aeadtest aeadtest aead ${CMAKE_CURRENT_SOURCE_DIR}/aeadtests.txt)
endif()

# aes_test
add_executable(aes_test aes_test.c)
target_link_libraries(aes_test ${OPENSSL_TEST_LIBS})
add_test(aes_test aes_test)

# aes_wrap
add_executable(aes_wrap aes_wrap.c)
target_link_libraries(aes_wrap ${OPENSSL_TEST_LIBS})
add_test(aes_wrap aes_wrap)

# apitest
add_executable(apitest apitest.c)
target_link_libraries(apitest ${OPENSSL_TEST_LIBS})
set_source_files_properties(apitest.c PROPERTIES COMPILE_FLAGS
	-DCERTSDIR=\\"${CMAKE_CURRENT_SOURCE_DIR}\\")
add_test(apitest apitest)

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

# asn1oct
add_executable(asn1oct asn1oct.c)
target_link_libraries(asn1oct ${OPENSSL_TEST_LIBS})
add_test(asn1oct asn1oct)

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

# asn1_string_to_utf8
add_executable(asn1_string_to_utf8 asn1_string_to_utf8.c)
target_link_libraries(asn1_string_to_utf8 ${OPENSSL_TEST_LIBS})
add_test(asn1_string_to_utf8 asn1_string_to_utf8)

# base64test
add_executable(base64test base64test.c)
target_link_libraries(base64test ${OPENSSL_TEST_LIBS})
add_test(base64test base64test)

# bf_test
add_executable(bf_test bf_test.c)
target_link_libraries(bf_test ${OPENSSL_TEST_LIBS})
add_test(bf_test bf_test)

# bio_asn1
add_executable(bio_asn1 bio_asn1.c)
target_link_libraries(bio_asn1 ${OPENSSL_TEST_LIBS})
add_test(bio_asn1 bio_asn1)

# bio_chain
add_executable(bio_chain bio_chain.c)
target_link_libraries(bio_chain ${OPENSSL_TEST_LIBS})
add_test(bio_chain bio_chain)

# bio_dump
add_executable(bio_dump bio_dump.c)
target_link_libraries(bio_dump ${OPENSSL_TEST_LIBS})
add_test(bio_dump bio_dump)

# bio_host
# this test relies on resolver results that are OS and environment-specific
if(ENABLE_EXTRATESTS)
	add_executable(bio_host bio_host.c)
	target_link_libraries(bio_host ${OPENSSL_TEST_LIBS})
	add_test(bio_host bio_host)
endif()

# bio_mem
add_executable(bio_mem bio_mem.c)
target_link_libraries(bio_mem ${OPENSSL_TEST_LIBS})
add_test(bio_mem bio_mem)

# bn_add_sub
add_executable(bn_add_sub bn_add_sub.c)
target_link_libraries(bn_add_sub ${OPENSSL_TEST_LIBS})
add_test(bn_add_sub bn_add_sub)

# bn_cmp
add_executable(bn_cmp bn_cmp.c)
target_link_libraries(bn_cmp ${OPENSSL_TEST_LIBS})
add_test(bn_cmp bn_cmp)

# bn_convert
add_executable(bn_convert bn_convert.c)
target_link_libraries(bn_convert ${OPENSSL_TEST_LIBS})
add_test(bn_convert bn_convert)

# bn_gcd
add_executable(bn_gcd bn_cmp.c)
target_link_libraries(bn_gcd ${OPENSSL_TEST_LIBS})
add_test(bn_gcd bn_gcd)

# bn_general is a benchmark

# bn_isqrt
add_executable(bn_isqrt bn_isqrt.c)
target_link_libraries(bn_isqrt ${OPENSSL_TEST_LIBS})
add_test(bn_isqrt bn_isqrt)

# bn_mod_exp
add_executable(bn_mod_exp bn_mod_exp.c)
set_source_files_properties(bn_mod_exp.c PROPERTIES COMPILE_FLAGS
	-ULIBRESSL_INTERNAL)
target_link_libraries(bn_mod_exp ${OPENSSL_TEST_LIBS})
add_test(bn_mod_exp bn_mod_exp)

# bn_mod_inverse
add_executable(bn_mod_inverse bn_mod_inverse.c)
target_link_libraries(bn_mod_inverse ${OPENSSL_TEST_LIBS})
add_test(bn_mod_inverse bn_mod_inverse)

# bn_mod_sqrt
add_executable(bn_mod_sqrt bn_mod_sqrt.c)
target_link_libraries(bn_mod_sqrt ${OPENSSL_TEST_LIBS})
add_test(bn_mod_sqrt bn_mod_sqrt)

# bn_mont
add_executable(bn_mont bn_mont.c)
target_link_libraries(bn_mont ${OPENSSL_TEST_LIBS})
add_test(bn_mont bn_mont)

# bn_primes
add_executable(bn_primes bn_primes.c)
target_link_libraries(bn_primes ${OPENSSL_TEST_LIBS})
add_test(bn_primes bn_primes)

# bn_print
add_executable(bn_print bn_print.c)
target_link_libraries(bn_print ${OPENSSL_TEST_LIBS})
add_test(bn_print bn_print)

# bn_shift
add_executable(bn_shift bn_shift.c)
target_link_libraries(bn_shift ${OPENSSL_TEST_LIBS})
add_test(bn_shift bn_shift)

# bn_test
add_executable(bn_test bn_test.c)
set_source_files_properties(bn_test.c PROPERTIES COMPILE_FLAGS
	-ULIBRESSL_INTERNAL)
target_link_libraries(bn_test ${OPENSSL_TEST_LIBS})
add_test(bn_test bn_test)

# bn_to_string
add_executable(bn_to_string bn_to_string.c)
target_link_libraries(bn_to_string ${OPENSSL_TEST_LIBS})
add_test(bn_to_string bn_to_string)

# bn_unit
add_executable(bn_unit bn_unit.c)
target_link_libraries(bn_unit ${OPENSSL_TEST_LIBS})
add_test(bn_unit bn_unit)

# bn_word
add_executable(bn_word bn_word.c)
target_link_libraries(bn_word ${OPENSSL_TEST_LIBS})
add_test(bn_word bn_word)

# buffertest
add_executable(buffertest buffertest.c)
target_link_libraries(buffertest ${OPENSSL_TEST_LIBS})
add_test(buffertest buffertest)

# bytestringtest
add_executable(bytestringtest bytestringtest.c)
target_link_libraries(bytestringtest ${OPENSSL_TEST_LIBS})
add_test(bytestringtest bytestringtest)

# callback
# callbackfailures

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

# cttest
add_executable(cttest cttest.c)
target_link_libraries(cttest ${OPENSSL_TEST_LIBS})
set_source_files_properties(cttest.c PROPERTIES COMPILE_FLAGS
	-DCTPATH=\\"${CMAKE_CURRENT_SOURCE_DIR}\\")
add_test(cttest cttest)

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

# XXX This test is too flaky for CI. Disable it until it is fixed.
# # dtlstest
# if(NOT WIN32)
# 	add_executable(dtlstest dtlstest.c)
# 	target_link_libraries(dtlstest ${OPENSSL_TEST_LIBS})
# 	add_test(NAME dtlstest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/dtlstest.sh)
# 	set_tests_properties(dtlstest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")
# endif()

# ecc_cdh
add_executable(ecc_cdh ecc_cdh.c)
target_link_libraries(ecc_cdh ${OPENSSL_TEST_LIBS})
add_test(ecc_cdh ecc_cdh)

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

# ed25519test
add_executable(ed25519test ed25519test.c)
target_link_libraries(ed25519test ${OPENSSL_TEST_LIBS})
add_test(ed25519test ed25519test)

# evp_ecx_test
add_executable(evp_ecx_test evp_ecx_test.c)
target_link_libraries(evp_ecx_test ${OPENSSL_TEST_LIBS})
add_test(evp_ecx_test evp_ecx_test)

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

# evp_test
add_executable(evp_test evp_test.c)
target_link_libraries(evp_test ${OPENSSL_TEST_LIBS})
add_test(evp_test evp_test)

# exdata_test
add_executable(exdata_test exdata_test.c)
target_link_libraries(exdata_test ${OPENSSL_TEST_LIBS})
add_test(exdata_test exdata_test)

# expirecallback.c

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

# exportertest
add_executable(exportertest exportertest.c)
target_link_libraries(exportertest ${OPENSSL_TEST_LIBS})
add_test(exportertest exportertest)

# freenull
add_executable(freenull freenull.c)
set_source_files_properties(freenull.c PROPERTIES COMPILE_FLAGS
	-ULIBRESSL_INTERNAL)
target_link_libraries(freenull ${OPENSSL_TEST_LIBS})
add_test(freenull freenull)

# gcm128test
add_executable(gcm128test gcm128test.c)
target_link_libraries(gcm128test ${OPENSSL_TEST_LIBS})
add_test(gcm128test gcm128test)

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

# init_pledge

# key_schedule
add_executable(key_schedule key_schedule.c)
target_link_libraries(key_schedule ${OPENSSL_TEST_LIBS})
add_test(key_schedule key_schedule)

# keypair
add_executable(keypairtest keypairtest.c)
target_link_libraries(keypairtest ${LIBTLS_TEST_LIBS})
target_include_directories(keypairtest BEFORE PUBLIC ../tls)
add_test(keypairtest keypairtest
	${CMAKE_CURRENT_SOURCE_DIR}/ca-root-rsa.pem
	${CMAKE_CURRENT_SOURCE_DIR}/server1-rsa.pem
	${CMAKE_CURRENT_SOURCE_DIR}/server1-rsa.pem)

# md_test
add_executable(md_test md_test.c)
target_link_libraries(md_test ${OPENSSL_TEST_LIBS})
add_test(md_test md_test)

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

# policy
add_executable(policy policy.c)
set_source_files_properties(policy.c PROPERTIES COMPILE_FLAGS
	-DCERTSDIR=\\"${CMAKE_CURRENT_SOURCE_DIR}\\")
target_link_libraries(policy ${OPENSSL_TEST_LIBS})
add_test(policy policy)

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

# quictest
set(QUICTEST_SRC quictest.c)
add_executable(quictest ${QUICTEST_SRC})
target_link_libraries(quictest ${OPENSSL_TEST_LIBS})
if(NOT MSVC)
	add_test(NAME quictest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/quictest.sh)
else()
	add_test(NAME quictest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/quictest.bat $<TARGET_FILE:quictest>)
endif()
set_tests_properties(quictest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# randtest
add_executable(randtest randtest.c)
target_link_libraries(randtest ${OPENSSL_TEST_LIBS})
add_test(randtest randtest)

# rc2_test
add_executable(rc2_test rc2_test.c)
target_link_libraries(rc2_test ${OPENSSL_TEST_LIBS})
add_test(rc2_test rc2_test)

# rc4_test
add_executable(rc4_test rc4_test.c)
target_link_libraries(rc4_test ${OPENSSL_TEST_LIBS})
add_test(rc4_test rc4_test)

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

# rmd_test
add_executable(rmd_test rmd_test.c)
target_link_libraries(rmd_test ${OPENSSL_TEST_LIBS})
add_test(rmd_test rmd_test)

# rsa_test
add_executable(rsa_test rsa_test.c)
target_link_libraries(rsa_test ${OPENSSL_TEST_LIBS})
add_test(rsa_test rsa_test)

# server.c

# servertest
add_executable(servertest servertest.c)
target_link_libraries(servertest ${OPENSSL_TEST_LIBS})
if(NOT MSVC)
	add_test(NAME servertest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/servertest.sh)
else()
	add_test(NAME servertest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/servertest.bat $<TARGET_FILE:servertest>)
endif()
set_tests_properties(servertest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# sha_test
add_executable(sha_test sha_test.c)
target_link_libraries(sha_test ${OPENSSL_TEST_LIBS})
add_test(sha_test sha_test)

# shutdowntest
set(SHUTDOWNTEST_SRC shutdowntest.c)
add_executable(shutdowntest ${SHUTDOWNTEST_SRC})
target_link_libraries(shutdowntest ${OPENSSL_TEST_LIBS})
if(NOT MSVC)
	add_test(NAME shutdowntest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/shutdowntest.sh)
else()
	add_test(NAME shutdowntest COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/shutdowntest.bat $<TARGET_FILE:shutdowntest>)
endif()
set_tests_properties(shutdowntest PROPERTIES ENVIRONMENT "srcdir=${TEST_SOURCE_DIR}")

# signertest
if(NOT CMAKE_SYSTEM_NAME MATCHES "WindowsStore")
	set(SIGNERTEST_SRC signertest.c)
	check_function_exists(pipe2 HAVE_PIPE2)
	if(HAVE_PIPE2)
		add_definitions(-DHAVE_PIPE2)
	else()
		set(SIGNERTEST_SRC ${SIGNERTEST_SRC} compat/pipe2.c)
	endif()

	set_source_files_properties(signertest.c PROPERTIES COMPILE_FLAGS
	      -DCERTSDIR=\\"${CMAKE_CURRENT_SOURCE_DIR}\\")
	add_executable(signertest ${SIGNERTEST_SRC})
	target_link_libraries(signertest ${LIBTLS_TEST_LIBS})
	target_include_directories(signertest BEFORE PUBLIC ../tls)
	add_test(signertest signertest)
endif()

# sm2crypttest
# sm2evptest
# sm2sigtest

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

# ssl_set_alpn_protos
add_executable(ssl_set_alpn_protos ssl_set_alpn_protos.c)
target_link_libraries(ssl_set_alpn_protos ${OPENSSL_TEST_LIBS})
add_test(ssl_set_alpn_protos ssl_set_alpn_protos)

# ssl_verify_param
add_executable(ssl_verify_param ssl_verify_param.c)
target_link_libraries(ssl_verify_param ${OPENSSL_TEST_LIBS})
add_test(ssl_verify_param ssl_verify_param)

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

# x509_algor
add_executable(x509_algor x509_algor.c)
target_link_libraries(x509_algor ${OPENSSL_TEST_LIBS})
add_test(x509_algor x509_algor)

# x509_asn1
add_executable(x509_asn1 x509_asn1.c)
target_link_libraries(x509_asn1 ${OPENSSL_TEST_LIBS})
add_test(x509_asn1 x509_asn1)

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
