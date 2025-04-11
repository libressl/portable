add_definitions(-DLIBRESSL_CRYPTO_INTERNAL)

if(HOST_ASM_ELF_ARMV4)
	set(
		ASM_ARMV4_ELF_SRC
		aes/aes-elf-armv4.S
		bn/mont-elf-armv4.S
		sha/sha1-elf-armv4.S
		sha/sha512-elf-armv4.S
		sha/sha256-elf-armv4.S
		modes/ghash-elf-armv4.S
		armv4cpuid.S
		armcap.c
	)
	add_definitions(-DAES_ASM)
	add_definitions(-DOPENSSL_BN_ASM_MONT)
	add_definitions(-DGHASH_ASM)
	add_definitions(-DOPENSSL_CPUID_OBJ)
	set(CRYPTO_SRC ${CRYPTO_SRC} ${ASM_ARMV4_ELF_SRC})
endif()

if(HOST_ASM_ELF_X86_64)
	set(
		ASM_X86_64_ELF_SRC
		aes/aes-elf-x86_64.S
		aes/bsaes-elf-x86_64.S
		aes/vpaes-elf-x86_64.S
		aes/aesni-elf-x86_64.S
		bn/modexp512-elf-x86_64.S
		bn/mont-elf-x86_64.S
		bn/mont5-elf-x86_64.S
		modes/ghash-elf-x86_64.S
		rc4/rc4-elf-x86_64.S

		bn/arch/amd64/bignum_add.S
		bn/arch/amd64/bignum_cmadd.S
		bn/arch/amd64/bignum_cmul.S
		bn/arch/amd64/bignum_mul.S
		bn/arch/amd64/bignum_mul_4_8_alt.S
		bn/arch/amd64/bignum_mul_8_16_alt.S
		bn/arch/amd64/bignum_sqr.S
		bn/arch/amd64/bignum_sqr_4_8_alt.S
		bn/arch/amd64/bignum_sqr_8_16_alt.S
		bn/arch/amd64/bignum_sub.S
		bn/arch/amd64/word_clz.S
		bn/arch/amd64/bn_arch.c
	)
	add_definitions(-DAES_ASM)
	add_definitions(-DBSAES_ASM)
	add_definitions(-DVPAES_ASM)
	add_definitions(-DOPENSSL_IA32_SSE2)
	add_definitions(-DOPENSSL_BN_ASM_MONT)
	add_definitions(-DOPENSSL_BN_ASM_MONT5)
	add_definitions(-DGHASH_ASM)
	add_definitions(-DRSA_ASM)
	set(CRYPTO_SRC ${CRYPTO_SRC} ${ASM_X86_64_ELF_SRC})
endif()

if(HOST_ASM_MACOSX_X86_64)
	set(
		ASM_X86_64_MACOSX_SRC
		aes/aes-macosx-x86_64.S
		aes/bsaes-macosx-x86_64.S
		aes/vpaes-macosx-x86_64.S
		aes/aesni-macosx-x86_64.S
		bn/modexp512-macosx-x86_64.S
		bn/mont-macosx-x86_64.S
		bn/mont5-macosx-x86_64.S
		modes/ghash-macosx-x86_64.S
		rc4/rc4-macosx-x86_64.S

		bn/arch/amd64/bignum_add.S
		bn/arch/amd64/bignum_cmadd.S
		bn/arch/amd64/bignum_cmul.S
		bn/arch/amd64/bignum_mul.S
		bn/arch/amd64/bignum_mul_4_8_alt.S
		bn/arch/amd64/bignum_mul_8_16_alt.S
		bn/arch/amd64/bignum_sqr.S
		bn/arch/amd64/bignum_sqr_4_8_alt.S
		bn/arch/amd64/bignum_sqr_8_16_alt.S
		bn/arch/amd64/bignum_sub.S
		bn/arch/amd64/word_clz.S
		bn/arch/amd64/bn_arch.c
	)
	add_definitions(-DAES_ASM)
	add_definitions(-DBSAES_ASM)
	add_definitions(-DVPAES_ASM)
	add_definitions(-DOPENSSL_IA32_SSE2)
	add_definitions(-DOPENSSL_BN_ASM_MONT)
	add_definitions(-DOPENSSL_BN_ASM_MONT5)
	add_definitions(-DGHASH_ASM)
	add_definitions(-DRSA_ASM)
	set(CRYPTO_SRC ${CRYPTO_SRC} ${ASM_X86_64_MACOSX_SRC})
	set_property(SOURCE ${ASM_X86_64_MACOSX_SRC} PROPERTY XCODE_EXPLICIT_FILE_TYPE "sourcecode.asm")
endif()

if(HOST_ASM_MASM_X86_64)
	set(
		ASM_X86_64_MASM_SRC
		aes/aes-masm-x86_64.S
		aes/bsaes-masm-x86_64.S
		aes/vpaes-masm-x86_64.S
		aes/aesni-masm-x86_64.S
		#bn/modexp512-masm-x86_64.S
		#bn/mont-masm-x86_64.S
		#bn/mont5-masm-x86_64.S
		modes/ghash-masm-x86_64.S
		rc4/rc4-masm-x86_64.S
	)
	add_definitions(-Dendbr64=)
	add_definitions(-DAES_ASM)
	add_definitions(-DBSAES_ASM)
	add_definitions(-DVPAES_ASM)
	add_definitions(-DOPENSSL_IA32_SSE2)
	#add_definitions(-DOPENSSL_BN_ASM_MONT)
	#add_definitions(-DOPENSSL_BN_ASM_MONT5)
	add_definitions(-DGHASH_ASM)
	add_definitions(-DRSA_ASM)
	set(CRYPTO_SRC ${CRYPTO_SRC} ${ASM_X86_64_MASM_SRC})
	set_property(SOURCE ${ASM_X86_64_MASM_SRC} PROPERTY LANGUAGE ASM_MASM)
endif()

if(HOST_ASM_MINGW64_X86_64)
	set(
		ASM_X86_64_MINGW64_SRC
		aes/aes-mingw64-x86_64.S
		aes/bsaes-mingw64-x86_64.S
		aes/vpaes-mingw64-x86_64.S
		aes/aesni-mingw64-x86_64.S
		#bn/modexp512-mingw64-x86_64.S
		#bn/mont-mingw64-x86_64.S
		#bn/mont5-mingw64-x86_64.S
		modes/ghash-mingw64-x86_64.S
		rc4/rc4-mingw64-x86_64.S
	)
	add_definitions(-Dendbr32=endbr64)
	add_definitions(-DAES_ASM)
	add_definitions(-DBSAES_ASM)
	add_definitions(-DVPAES_ASM)
	add_definitions(-DOPENSSL_IA32_SSE2)
	#add_definitions(-DOPENSSL_BN_ASM_MONT)
	#add_definitions(-DOPENSSL_BN_ASM_MONT5)
	add_definitions(-DGHASH_ASM)
	add_definitions(-DRSA_ASM)
	set(CRYPTO_SRC ${CRYPTO_SRC} ${ASM_X86_64_MINGW64_SRC})
endif()

if(HOST_AARCH64)
	set(CRYPTO_SRC ${CRYPTO_SRC} arch/aarch64/crypto_cpu_caps.c)
elseif(HOST_X86_64)
	set(CRYPTO_SRC ${CRYPTO_SRC} arch/amd64/crypto_cpu_caps.c)
elseif(HOST_I386)
	set(CRYPTO_SRC ${CRYPTO_SRC} arch/i386/crypto_cpu_caps.c)
endif()

set(
	CRYPTO_SRC
	${CRYPTO_SRC}
	crypto_err.c
	crypto_ex_data.c
	crypto_init.c
	crypto_legacy.c
	crypto_memory.c
	aes/aes.c
	aes/aes_core.c
	aes/aes_ige.c
	asn1/a_bitstr.c
	asn1/a_enum.c
	asn1/a_int.c
	asn1/a_mbstr.c
	asn1/a_object.c
	asn1/a_octet.c
	asn1/a_pkey.c
	asn1/a_print.c
	asn1/a_pubkey.c
	asn1/a_strex.c
	asn1/a_string.c
	asn1/a_strnid.c
	asn1/a_time.c
	asn1/a_time_posix.c
	asn1/a_time_tm.c
	asn1/a_type.c
	asn1/a_utf8.c
	asn1/asn1_err.c
	asn1/asn1_gen.c
	asn1/asn1_item.c
	asn1/asn1_lib.c
	asn1/asn1_old.c
	asn1/asn1_old_lib.c
	asn1/asn1_par.c
	asn1/asn1_types.c
	asn1/asn_mime.c
	asn1/asn_moid.c
	asn1/bio_asn1.c
	asn1/bio_ndef.c
	asn1/p5_pbe.c
	asn1/p5_pbev2.c
	asn1/p8_pkey.c
	asn1/t_crl.c
	asn1/t_req.c
	asn1/t_spki.c
	asn1/t_x509.c
	asn1/t_x509a.c
	asn1/tasn_dec.c
	asn1/tasn_enc.c
	asn1/tasn_fre.c
	asn1/tasn_new.c
	asn1/tasn_prn.c
	asn1/tasn_typ.c
	asn1/tasn_utl.c
	asn1/x_algor.c
	asn1/x_attrib.c
	asn1/x_bignum.c
	asn1/x_crl.c
	asn1/x_exten.c
	asn1/x_info.c
	asn1/x_long.c
	asn1/x_name.c
	asn1/x_pkey.c
	asn1/x_pubkey.c
	asn1/x_req.c
	asn1/x_sig.c
	asn1/x_spki.c
	asn1/x_val.c
	asn1/x_x509.c
	asn1/x_x509a.c
	bf/blowfish.c
	bio/b_dump.c
	bio/b_print.c
	bio/b_sock.c
	bio/bf_buff.c
	bio/bf_nbio.c
	bio/bf_null.c
	bio/bio_cb.c
	bio/bio_err.c
	bio/bio_lib.c
	bio/bio_meth.c
	bio/bss_acpt.c
	bio/bss_bio.c
	bio/bss_conn.c
	bio/bss_dgram.c
	bio/bss_fd.c
	bio/bss_file.c
	bio/bss_mem.c
	bio/bss_null.c
	bio/bss_sock.c
	bn/bn_add.c
	bn/bn_bpsw.c
	bn/bn_const.c
	bn/bn_convert.c
	bn/bn_ctx.c
	bn/bn_div.c
	bn/bn_err.c
	bn/bn_exp.c
	bn/bn_gcd.c
	bn/bn_isqrt.c
	bn/bn_kron.c
	bn/bn_lib.c
	bn/bn_mod.c
	bn/bn_mod_sqrt.c
	bn/bn_mont.c
	bn/bn_mul.c
	bn/bn_prime.c
	bn/bn_primitives.c
	bn/bn_print.c
	bn/bn_rand.c
	bn/bn_recp.c
	bn/bn_shift.c
	bn/bn_small_primes.c
	bn/bn_sqr.c
	bn/bn_word.c
	buffer/buf_err.c
	buffer/buffer.c
	bytestring/bs_ber.c
	bytestring/bs_cbb.c
	bytestring/bs_cbs.c
	camellia/camellia.c
	cast/cast.c
	chacha/chacha.c
	cmac/cm_ameth.c
	cmac/cm_pmeth.c
	cmac/cmac.c
	cms/cms_asn1.c
	cms/cms_att.c
	cms/cms_dd.c
	cms/cms_enc.c
	cms/cms_env.c
	cms/cms_err.c
	cms/cms_ess.c
	cms/cms_io.c
	cms/cms_kari.c
	cms/cms_lib.c
	cms/cms_pwri.c
	cms/cms_sd.c
	cms/cms_smime.c
	conf/conf_api.c
	conf/conf_def.c
	conf/conf_err.c
	conf/conf_lib.c
	conf/conf_mod.c
	conf/conf_sap.c
	ct/ct_b64.c
	ct/ct_err.c
	ct/ct_log.c
	ct/ct_oct.c
	ct/ct_policy.c
	ct/ct_prn.c
	ct/ct_sct.c
	ct/ct_sct_ctx.c
	ct/ct_vfy.c
	ct/ct_x509v3.c
	curve25519/curve25519-generic.c
	curve25519/curve25519.c
	des/des.c
	des/des_cksum.c
	des/des_enc.c
	des/des_fcrypt.c
	des/des_key.c
	dh/dh_ameth.c
	dh/dh_asn1.c
	dh/dh_check.c
	dh/dh_err.c
	dh/dh_gen.c
	dh/dh_key.c
	dh/dh_lib.c
	dh/dh_pmeth.c
	dsa/dsa_ameth.c
	dsa/dsa_asn1.c
	dsa/dsa_err.c
	dsa/dsa_gen.c
	dsa/dsa_key.c
	dsa/dsa_lib.c
	dsa/dsa_meth.c
	dsa/dsa_ossl.c
	dsa/dsa_pmeth.c
	dsa/dsa_prn.c
	ec/ec_ameth.c
	ec/ec_asn1.c
	ec/ec_convert.c
	ec/ec_curve.c
	ec/ec_err.c
	ec/ec_key.c
	ec/ec_lib.c
	ec/ec_mult.c
	ec/ec_pmeth.c
	ec/eck_prn.c
	ec/ecp_methods.c
	ec/ecx_methods.c
	ecdh/ecdh.c
	ecdsa/ecdsa.c
	engine/engine_stubs.c
	err/err.c
	err/err_all.c
	err/err_prn.c
	evp/bio_b64.c
	evp/bio_enc.c
	evp/bio_md.c
	evp/e_aes.c
	evp/e_bf.c
	evp/e_camellia.c
	evp/e_cast.c
	evp/e_chacha.c
	evp/e_chacha20poly1305.c
	evp/e_des.c
	evp/e_des3.c
	evp/e_idea.c
	evp/e_null.c
	evp/e_rc2.c
	evp/e_rc4.c
	evp/e_sm4.c
	evp/e_xcbc_d.c
	evp/evp_aead.c
	evp/evp_cipher.c
	evp/evp_digest.c
	evp/evp_encode.c
	evp/evp_err.c
	evp/evp_key.c
	evp/evp_names.c
	evp/evp_pbe.c
	evp/evp_pkey.c
	evp/m_md4.c
	evp/m_md5.c
	evp/m_md5_sha1.c
	evp/m_null.c
	evp/m_ripemd.c
	evp/m_sha1.c
	evp/m_sha3.c
	evp/m_sigver.c
	evp/m_sm3.c
	evp/p_legacy.c
	evp/p_lib.c
	evp/p_sign.c
	evp/p_verify.c
	evp/pmeth_fn.c
	evp/pmeth_gn.c
	evp/pmeth_lib.c
	hkdf/hkdf.c
	hmac/hm_ameth.c
	hmac/hm_pmeth.c
	hmac/hmac.c
	idea/idea.c
	kdf/hkdf_evp.c
	kdf/kdf_err.c
	kdf/tls1_prf.c
	lhash/lhash.c
	md4/md4.c
	md5/md5.c
	mlkem/mlkem768.c
	mlkem/mlkem1024.c
	modes/cbc128.c
	modes/ccm128.c
	modes/cfb128.c
	modes/ctr128.c
	modes/gcm128.c
	modes/ofb128.c
	modes/xts128.c
	objects/obj_dat.c
	objects/obj_err.c
	objects/obj_lib.c
	objects/obj_xref.c
	ocsp/ocsp_asn.c
	ocsp/ocsp_cl.c
	ocsp/ocsp_err.c
	ocsp/ocsp_ext.c
	ocsp/ocsp_ht.c
	ocsp/ocsp_lib.c
	ocsp/ocsp_prn.c
	ocsp/ocsp_srv.c
	ocsp/ocsp_vfy.c
	pem/pem_all.c
	pem/pem_err.c
	pem/pem_info.c
	pem/pem_lib.c
	pem/pem_oth.c
	pem/pem_pk8.c
	pem/pem_pkey.c
	pem/pem_sign.c
	pem/pem_x509.c
	pem/pem_xaux.c
	pem/pvkfmt.c
	pkcs12/p12_add.c
	pkcs12/p12_asn.c
	pkcs12/p12_attr.c
	pkcs12/p12_crt.c
	pkcs12/p12_decr.c
	pkcs12/p12_init.c
	pkcs12/p12_key.c
	pkcs12/p12_kiss.c
	pkcs12/p12_mutl.c
	pkcs12/p12_npas.c
	pkcs12/p12_p8d.c
	pkcs12/p12_p8e.c
	pkcs12/p12_sbag.c
	pkcs12/p12_utl.c
	pkcs12/pk12err.c
	pkcs7/pk7_asn1.c
	pkcs7/pk7_attr.c
	pkcs7/pk7_doit.c
	pkcs7/pk7_lib.c
	pkcs7/pk7_mime.c
	pkcs7/pk7_smime.c
	pkcs7/pkcs7err.c
	poly1305/poly1305.c
	rand/rand_err.c
	rand/rand_lib.c
	rand/randfile.c
	rc2/rc2_cbc.c
	rc2/rc2_ecb.c
	rc2/rc2_skey.c
	rc2/rc2cfb64.c
	rc2/rc2ofb64.c
	rc4/rc4.c
	ripemd/ripemd.c
	rsa/rsa_ameth.c
	rsa/rsa_asn1.c
	rsa/rsa_blinding.c
	rsa/rsa_chk.c
	rsa/rsa_eay.c
	rsa/rsa_err.c
	rsa/rsa_gen.c
	rsa/rsa_lib.c
	rsa/rsa_meth.c
	rsa/rsa_none.c
	rsa/rsa_oaep.c
	rsa/rsa_pk1.c
	rsa/rsa_pmeth.c
	rsa/rsa_prn.c
	rsa/rsa_pss.c
	rsa/rsa_saos.c
	rsa/rsa_sign.c
	rsa/rsa_x931.c
	sha/sha1.c
	sha/sha256.c
	sha/sha3.c
	sha/sha512.c
	sm3/sm3.c
	sm4/sm4.c
	stack/stack.c
	ts/ts_asn1.c
	ts/ts_conf.c
	ts/ts_err.c
	ts/ts_lib.c
	ts/ts_req_print.c
	ts/ts_req_utils.c
	ts/ts_rsp_print.c
	ts/ts_rsp_sign.c
	ts/ts_rsp_utils.c
	ts/ts_rsp_verify.c
	ts/ts_verify_ctx.c
	txt_db/txt_db.c
	ui/ui_err.c
	ui/ui_lib.c
	ui/ui_null.c
	x509/by_dir.c
	x509/by_file.c
	x509/by_mem.c
	x509/x509_addr.c
	x509/x509_akey.c
	x509/x509_akeya.c
	x509/x509_alt.c
	x509/x509_asid.c
	x509/x509_att.c
	x509/x509_bcons.c
	x509/x509_bitst.c
	x509/x509_cmp.c
	x509/x509_conf.c
	x509/x509_constraints.c
	x509/x509_cpols.c
	x509/x509_crld.c
	x509/x509_d2.c
	x509/x509_def.c
	x509/x509_err.c
	x509/x509_ext.c
	x509/x509_extku.c
	x509/x509_genn.c
	x509/x509_ia5.c
	x509/x509_info.c
	x509/x509_int.c
	x509/x509_issuer_cache.c
	x509/x509_lib.c
	x509/x509_lu.c
	x509/x509_ncons.c
	x509/x509_obj.c
	x509/x509_ocsp.c
	x509/x509_pcons.c
	x509/x509_pku.c
	x509/x509_pmaps.c
	x509/x509_policy.c
	x509/x509_prn.c
	x509/x509_purp.c
	x509/x509_r2x.c
	x509/x509_req.c
	x509/x509_set.c
	x509/x509_siginfo.c
	x509/x509_skey.c
	x509/x509_trs.c
	x509/x509_txt.c
	x509/x509_utl.c
	x509/x509_v3.c
	x509/x509_verify.c
	x509/x509_vfy.c
	x509/x509_vpm.c
	x509/x509cset.c
	x509/x509name.c
	x509/x509rset.c
	x509/x509spki.c
	x509/x509type.c
	x509/x_all.c
)

set(COMPAT_SRC empty.c)

if(UNIX)
	set(CRYPTO_SRC ${CRYPTO_SRC} crypto_lock.c)
	set(CRYPTO_SRC ${CRYPTO_SRC} bio/b_posix.c)
	set(CRYPTO_SRC ${CRYPTO_SRC} bio/bss_log.c)
	set(CRYPTO_SRC ${CRYPTO_SRC} ui/ui_openssl.c)
endif()

if(WIN32)
	set(CRYPTO_SRC ${CRYPTO_SRC} compat/crypto_lock_win.c)
	set(CRYPTO_SRC ${CRYPTO_SRC} bio/b_win.c)
	set(CRYPTO_UNEXPORT ${CRYPTO_UNEXPORT} BIO_s_log)
	set(CRYPTO_SRC ${CRYPTO_SRC} ui/ui_openssl_win.c)
endif()

if(WIN32)
	set(COMPAT_SRC ${COMPAT_SRC} compat/posix_win.c)
endif()

if(NOT HAVE_ASPRINTF)
	set(COMPAT_SRC ${COMPAT_SRC} compat/bsd-asprintf.c)
endif()

if(NOT HAVE_FREEZERO)
	set(COMPAT_SRC ${COMPAT_SRC} compat/freezero.c)
endif()

if(NOT HAVE_GETDELIM)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getdelim.c)
endif()

if(NOT HAVE_GETLINE)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getline.c)
endif()

if(NOT HAVE_GETOPT)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getopt_long.c)
endif()

if(NOT HAVE_GETPAGESIZE)
	set(COMPAT_SRC ${COMPAT_SRC} compat/getpagesize.c)
endif()

if(NOT HAVE_GETPROGNAME)
	if(WIN32)
		set(COMPAT_SRC ${COMPAT_SRC} compat/getprogname_windows.c)
	elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
		set(COMPAT_SRC ${COMPAT_SRC} compat/getprogname_linux.c)
	else()
		set(COMPAT_SRC ${COMPAT_SRC} compat/getprogname_unimpl.c)
	endif()
endif()

if(NOT HAVE_REALLOCARRAY)
	set(COMPAT_SRC ${COMPAT_SRC} compat/reallocarray.c)
endif()

if(NOT HAVE_RECALLOCARRAY)
	set(COMPAT_SRC ${COMPAT_SRC} compat/recallocarray.c)
endif()

if(NOT HAVE_STRCASECMP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strcasecmp.c)
endif()

if(NOT HAVE_STRLCAT)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strlcat.c)
endif()

if(NOT HAVE_STRLCPY)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strlcpy.c)
endif()

if(NOT HAVE_STRNDUP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strndup.c)
	if(NOT HAVE_STRNLEN)
		set(COMPAT_SRC ${COMPAT_SRC} compat/strnlen.c)
	endif()
endif()

if(NOT HAVE_STRSEP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strsep.c)
endif()

if(NOT HAVE_STRTONUM)
	set(COMPAT_SRC ${COMPAT_SRC} compat/strtonum.c)
endif()

if(NOT HAVE_SYSLOG_R)
	set(COMPAT_SRC ${COMPAT_SRC} compat/syslog_r.c)
endif()

if(NOT HAVE_EXPLICIT_BZERO)
	if(WIN32)
		set(COMPAT_SRC ${COMPAT_SRC} compat/explicit_bzero_win.c)
	else()
		set(COMPAT_SRC ${COMPAT_SRC} compat/explicit_bzero.c)
		set_source_files_properties(compat/explicit_bzero.c PROPERTIES COMPILE_FLAGS -O0)
	endif()
endif()

if(NOT HAVE_ARC4RANDOM_BUF)
	set(COMPAT_SRC ${COMPAT_SRC} compat/arc4random.c)
	set(COMPAT_SRC ${COMPAT_SRC} compat/arc4random_uniform.c)

	if(NOT HAVE_GETENTROPY)
		if(WIN32)
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_win.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "AIX")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_aix.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_freebsd.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "HP-UX")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_hpux.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_linux.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "NetBSD")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_netbsd.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "Darwin")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_osx.c)
		elseif(CMAKE_SYSTEM_NAME MATCHES "SunOS")
			set(COMPAT_SRC ${COMPAT_SRC} compat/getentropy_solaris.c)
		endif()
	endif()
endif()

if(NOT HAVE_TIMINGSAFE_BCMP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/timingsafe_bcmp.c)
endif()

if(NOT HAVE_TIMINGSAFE_MEMCMP)
	set(COMPAT_SRC ${COMPAT_SRC} compat/timingsafe_memcmp.c)
endif()

if(NOT ENABLE_ASM)
	add_definitions(-DOPENSSL_NO_ASM)
else()
	if(MSVC)
		if((NOT "${CMAKE_GENERATOR}" MATCHES "Win64") AND
		   (NOT "${CMAKE_GENERATOR_PLATFORM}" STREQUAL "x64"))
			add_definitions(-DOPENSSL_NO_ASM)
		endif()
	elseif(WIN32 AND NOT MINGW)
		add_definitions(-DOPENSSL_NO_ASM)
	endif()
endif()

add_definitions(-DOPENSSLDIR=\"${OPENSSLDIR}\")

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/crypto.sym SYMS)
foreach(SYM IN LISTS CRYPTO_UNEXPORT)
	string(REPLACE "${SYM}\n" "" SYMS ${SYMS})
endforeach()
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/crypto_p.sym ${SYMS})

add_library(compat_obj OBJECT ${COMPAT_SRC})
target_include_directories(compat_obj
	PRIVATE
		../include/compat
	PUBLIC
		../include
		${CMAKE_BINARY_DIR}/include)

add_library(crypto_obj OBJECT ${CRYPTO_SRC})
target_include_directories(crypto_obj
	PRIVATE
		.
		asn1
		bio
		bn
		bytestring
		conf
		dh
		dsa
		curve25519
		ec
		ecdh
		ecdsa
		err
		evp
		hidden
		hmac
		lhash
		mlkem
		modes
		ocsp
		pkcs12
		rsa
		sha
		stack
		x509
		../include/compat
	PUBLIC
		../include
		${CMAKE_BINARY_DIR}/include)

if(HOST_AARCH64)
	target_include_directories(crypto_obj PRIVATE arch/aarch64/)
	target_include_directories(crypto_obj PRIVATE bn/arch/aarch64/)
elseif(HOST_ARM)
	target_include_directories(crypto_obj PRIVATE arch/arm/)
	target_include_directories(crypto_obj PRIVATE bn/arch/arm/)
elseif(HOST_I386)
	target_include_directories(crypto_obj PRIVATE arch/i386/)
	target_include_directories(crypto_obj PRIVATE bn/arch/i386/)
elseif(HOST_LOONGARCH64)
	target_include_directories(crypto_obj PRIVATE arch/loongarch64)
	target_include_directories(crypto_obj PRIVATE bn/arch/loongarch64)
elseif(HOST_MIPS64)
	target_include_directories(crypto_obj PRIVATE arch/mips64)
	target_include_directories(crypto_obj PRIVATE bn/arch/mips64)
elseif(HOST_MIPS)
	target_include_directories(crypto_obj PRIVATE arch/mips)
	target_include_directories(crypto_obj PRIVATE bn/arch/mips)
elseif(HOST_POWERPC)
	target_include_directories(crypto_obj PRIVATE arch/powerpc)
	target_include_directories(crypto_obj PRIVATE bn/arch/powerpc)
elseif(HOST_POWERPC64)
	target_include_directories(crypto_obj PRIVATE arch/powerpc64)
	target_include_directories(crypto_obj PRIVATE bn/arch/powerpc64)
elseif(HOST_RISCV64)
	target_include_directories(crypto_obj PRIVATE arch/riscv64)
	target_include_directories(crypto_obj PRIVATE bn/arch/riscv64)
elseif(HOST_SPARC64)
	target_include_directories(crypto_obj PRIVATE arch/sparc64)
	target_include_directories(crypto_obj PRIVATE bn/arch/sparc64)
elseif(HOST_X86_64)
	target_include_directories(crypto_obj PRIVATE arch/amd64)
	target_include_directories(crypto_obj PRIVATE bn/arch/amd64)
endif()

if(MSVC)
	# "C4701" - Potentially uninitialized local variable 'name' used
	set_source_files_properties(bn/bn_convert.c pem/pem_lib.c PROPERTIES
		COMPILE_OPTIONS /wd4701
	)
	# "C4702" - unreachable code
	set_source_files_properties(pkcs7/pk7_doit.c PROPERTIES
		COMPILE_OPTIONS /wd4702
	)
endif()

add_library(crypto $<TARGET_OBJECTS:crypto_obj> $<TARGET_OBJECTS:compat_obj> empty.c)

export_symbol(crypto ${CMAKE_CURRENT_BINARY_DIR}/crypto_p.sym)
target_link_libraries(crypto ${PLATFORM_LIBS})
set_target_properties(crypto PROPERTIES
	OUTPUT_NAME crypto
	ARCHIVE_OUTPUT_NAME crypto
	EXPORT_NAME Crypto
	VERSION ${CRYPTO_VERSION}
	SOVERSION ${CRYPTO_MAJOR_VERSION}
)
if(NOT CMAKE_VERSION VERSION_LESS 3.27.0)
	set_target_properties(crypto PROPERTIES DLL_NAME_WITH_SOVERSION TRUE)
endif()

target_include_directories(
	crypto
	PUBLIC
	$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
	$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

install(
	TARGETS crypto
	EXPORT Crypto-target
)

export(
	EXPORT Crypto-target
	FILE "${LibreSSL_BINARY_DIR}/LibreSSL-Crypto.cmake"
	NAMESPACE LibreSSL::
)

if(ENABLE_LIBRESSL_INSTALL)
	install(
		TARGETS crypto
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
	)
	install(
		EXPORT Crypto-target
		FILE "LibreSSL-Crypto.cmake"
		NAMESPACE LibreSSL::
		DESTINATION "${LIBRESSL_INSTALL_CMAKEDIR}"
	)
endif(ENABLE_LIBRESSL_INSTALL)

# build static library for regression test
if(BUILD_SHARED_LIBS)
	add_library(crypto-static STATIC $<TARGET_OBJECTS:crypto_obj>)
	target_link_libraries(crypto-static ${PLATFORM_LIBS})
endif()
