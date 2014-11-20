#!/usr/bin/env bash
set -e

openbsd_branch=`cat OPENBSD_BRANCH`
libressl_version=`cat VERSION`

if [ ! -d openbsd ]; then
	if [ -z "$LIBRESSL_GIT" ]; then
		git clone https://github.com/libressl-portable/openbsd.git
	else
		git clone $LIBRESSL_GIT/openbsd
	fi
fi
(cd openbsd
 git checkout $openbsd_branch
 git pull --rebase)

dir=`pwd`
libssl_src=$dir/openbsd/src/lib/libssl
libssl_regress=$dir/openbsd/src/regress/lib/libssl
libc_src=$dir/openbsd/src/lib/libc
libc_regress=$dir/openbsd/src/regress/lib/libc
libcrypto_src=$dir/openbsd/src/lib/libcrypto
openssl_cmd_src=$dir/openbsd/src/usr.bin/openssl
libcrypto_regress=$dir/openbsd/src/regress/lib/libcrypto

source $libssl_src/ssl/shlib_version
libssl_version=$major:$minor:0
echo libssl version $libssl_version

source $libcrypto_src/crypto/shlib_version
libcrypto_version=$major:$minor:0
echo libcrypto version $libcrypto_version

CP='cp -p'

copy_src() {
	mkdir -p $1
	rm -f $1/*.c
	for file in $3; do
		if [ -e $2/src/$1/$file ]; then
			$CP $2/src/$1/$file $1
		else
			$CP crypto/compat/$file $1
		fi
	done
}

copy_hdrs() {
	for file in $2; do
		$CP $libssl_src/src/$1/$file include/openssl
	done
}

copy_crypto() {
	copy_src crypto/$1 $libssl_src "$2"
	crypto_subdirs="$crypto_subdirs $1"
}

$CP $libssl_src/src/LICENSE COPYING

$CP $libcrypto_src/crypto/arch/amd64/opensslconf.h include/openssl
$CP $libssl_src/src/crypto/opensslfeatures.h include/openssl
$CP $libssl_src/src/e_os2.h include/openssl
$CP $libssl_src/src/ssl/pqueue.h include

for i in explicit_bzero.c strlcpy.c strlcat.c strndup.c strnlen.c \
		timingsafe_bcmp.c timingsafe_memcmp.c; do
	$CP $libc_src/string/$i crypto/compat
done
$CP $libc_src/stdlib/reallocarray.c crypto/compat
$CP $libc_src/crypt/arc4random.c crypto/compat
$CP $libc_src/crypt/chacha_private.h crypto/compat
$CP $libcrypto_src/crypto/getentropy_*.c crypto/compat
$CP $libcrypto_src/crypto/arc4random_*.h crypto/compat

(cd $libssl_src/src/crypto/objects/;
	perl objects.pl objects.txt obj_mac.num obj_mac.h;
	perl obj_dat.pl obj_mac.h obj_dat.h )
mkdir -p include/openssl crypto/objects
mv $libssl_src/src/crypto/objects/obj_mac.h ./include/openssl/obj_mac.h
mv $libssl_src/src/crypto/objects/obj_dat.h ./crypto/objects/obj_dat.h

copy_hdrs crypto "stack/stack.h lhash/lhash.h stack/safestack.h opensslv.h
	ossl_typ.h err/err.h crypto.h comp/comp.h x509/x509.h buffer/buffer.h
	objects/objects.h asn1/asn1.h bn/bn.h ec/ec.h ecdsa/ecdsa.h
	ecdh/ecdh.h rsa/rsa.h sha/sha.h x509/x509_vfy.h pkcs7/pkcs7.h pem/pem.h
	pem/pem2.h hmac/hmac.h rand/rand.h md5/md5.h
	krb5/krb5_asn.h asn1/asn1_mac.h x509v3/x509v3.h conf/conf.h ocsp/ocsp.h
	aes/aes.h modes/modes.h asn1/asn1t.h dso/dso.h bf/blowfish.h
	bio/bio.h cast/cast.h cmac/cmac.h conf/conf_api.h des/des.h dh/dh.h
	dsa/dsa.h cms/cms.h engine/engine.h ui/ui.h pkcs12/pkcs12.h ts/ts.h
	md4/md4.h ripemd/ripemd.h whrlpool/whrlpool.h idea/idea.h mdc2/mdc2.h
	rc2/rc2.h rc4/rc4.h rc5/rc5.h ui/ui_compat.h txt_db/txt_db.h
	chacha/chacha.h evp/evp.h poly1305/poly1305.h camellia/camellia.h
	gost/gost.h"

copy_hdrs ssl "srtp.h ssl.h ssl2.h ssl3.h ssl23.h tls1.h dtls1.h"

for i in ssl/srtp.h ssl/ssl_locl.h; do
	$CP $libssl_src/src/$i ssl
done

copy_src ssl $libssl_src \
	"s3_meth.c s3_srvr.c s3_clnt.c s3_lib.c s3_enc.c s3_pkt.c
	s3_both.c s23_meth.c s23_srvr.c s23_clnt.c s23_lib.c s23_pkt.c t1_meth.c
	t1_srvr.c t1_clnt.c t1_lib.c t1_enc.c d1_meth.c d1_srvr.c d1_clnt.c
	d1_lib.c d1_pkt.c d1_both.c d1_enc.c d1_srtp.c ssl_lib.c ssl_err2.c
	ssl_cert.c ssl_sess.c ssl_ciph.c ssl_stat.c ssl_rsa.c ssl_asn1.c ssl_txt.c
	ssl_algs.c bio_ssl.c ssl_err.c t1_reneg.c s3_cbc.c pqueue.c"

copy_src crypto $libssl_src \
	"cryptlib.h cryptlib.c malloc-wrapper.c mem_clr.c mem_dbg.c cversion.c
	ex_data.c cpt_err.c o_time.c o_time.h o_str.c o_init.c md32_common.h"

copy_crypto aes "aes_cbc.c aes_core.c aes_misc.c aes_ecb.c aes_cfb.c aes_ofb.c aes_ctr.c
	aes_ige.c aes_wrap.c aes_locl.h"

copy_crypto asn1 "a_object.c a_bitstr.c a_utctm.c a_gentm.c a_time.c
	a_int.c a_octet.c a_print.c a_type.c a_dup.c a_d2i_fp.c a_i2d_fp.c a_enum.c
	a_utf8.c a_sign.c a_digest.c a_verify.c a_mbstr.c a_strex.c x_algor.c
	x_val.c x_pubkey.c x_sig.c x_req.c x_attrib.c x_bignum.c x_long.c x_name.c
	x_x509.c x_x509a.c x_crl.c x_info.c x_spki.c nsseq.c x_nx509.c d2i_pu.c
	d2i_pr.c i2d_pu.c i2d_pr.c t_req.c t_x509.c t_x509a.c t_crl.c t_pkey.c
	t_spki.c t_bitst.c tasn_new.c tasn_fre.c tasn_enc.c tasn_dec.c tasn_utl.c
	tasn_typ.c tasn_prn.c ameth_lib.c f_int.c f_string.c n_pkey.c f_enum.c
	x_pkey.c a_bool.c x_exten.c bio_asn1.c bio_ndef.c asn_mime.c asn1_gen.c
	asn1_par.c asn1_lib.c asn1_err.c a_bytes.c a_strnid.c evp_asn1.c asn_pack.c
	p5_pbe.c p5_pbev2.c p8_pkey.c asn_moid.c a_set.c asn1_locl.h charmap.h"

copy_crypto bf "bf_skey.c bf_ecb.c bf_enc.c bf_cfb64.c bf_ofb64.c bf_locl.h bf_pi.h"

copy_crypto bio "bio_lib.c bio_cb.c bio_err.c bss_mem.c bss_null.c bss_fd.c
	bss_file.c bss_sock.c bss_conn.c bf_null.c bf_buff.c b_dump.c
	b_sock.c bss_acpt.c bf_nbio.c bss_log.c bss_bio.c bss_dgram.c b_print.c
	b_posix.c b_win.c"

copy_crypto bn "bn_add.c bn_asm.c bn_div.c bn_exp.c bn_lib.c bn_ctx.c bn_mul.c
	bn_mod.c bn_print.c bn_rand.c bn_shift.c bn_word.c bn_blind.c bn_kron.c
	bn_sqrt.c bn_gcd.c bn_prime.c bn_err.c bn_sqr.c bn_recp.c bn_mont.c
	bn_mpi.c bn_exp2.c bn_gf2m.c bn_nist.c bn_depr.c bn_const.c bn_x931p.c
	bn_lcl.h bn_prime.h"

copy_crypto buffer "buffer.c buf_err.c buf_str.c"

copy_crypto camellia "cmll_cfb.c cmll_ctr.c cmll_ecb.c cmll_ofb.c camellia.c
	cmll_cbc.c cmll_misc.c cmll_locl.h"

copy_crypto cast "c_skey.c c_ecb.c c_enc.c c_cfb64.c c_ofb64.c cast_lcl.h
	cast_s.h"

copy_crypto chacha "chacha.c chacha-merged.c"

copy_crypto cmac "cmac.c cm_ameth.c cm_pmeth.c"

#copy_crypto cms "cms_lib.c cms_asn1.c cms_att.c cms_io.c cms_smime.c cms_err.c
#	cms_sd.c cms_dd.c cms_cd.c cms_env.c cms_enc.c cms_ess.c cms_pwri.c cms.h cms_lcl.h"

copy_crypto comp "comp_lib.c comp_err.c c_rle.c c_zlib.c"

copy_crypto conf "conf_err.c conf_lib.c conf_api.c conf_def.c conf_mod.c
	conf_mall.c conf_sap.c conf_def.h"

copy_crypto des "cbc_cksm.c cbc_enc.c cfb64enc.c cfb_enc.c ecb3_enc.c
	ecb_enc.c  enc_read.c enc_writ.c fcrypt.c fcrypt_b.c ofb64enc.c ofb_enc.c
	pcbc_enc.c qud_cksm.c rand_key.c set_key.c xcbc_enc.c str2key.c
	cfb64ede.c ofb64ede.c ede_cbcm_enc.c des_enc.c des_locl.h ncbc_enc.c
	spr.h"

copy_crypto dh "dh_asn1.c dh_gen.c dh_key.c dh_lib.c dh_check.c dh_err.c
	dh_depr.c dh_ameth.c dh_pmeth.c dh_prn.c"

copy_crypto dsa "dsa_gen.c dsa_key.c dsa_lib.c dsa_asn1.c dsa_vrf.c
	dsa_sign.c dsa_err.c dsa_ossl.c dsa_depr.c dsa_ameth.c dsa_pmeth.c
	dsa_prn.c dsa_locl.h"

copy_crypto dso "dso_dlfcn.c dso_err.c dso_lib.c dso_null.c dso_openssl.c"

copy_crypto ec "ec_lib.c ecp_smpl.c ecp_mont.c ecp_nist.c ec_cvt.c ec_mult.c
	ec_err.c ec_curve.c ec_check.c ec_print.c ec_asn1.c ec_key.c ec2_smpl.c
	ec2_mult.c ec_ameth.c ec_pmeth.c eck_prn.c ecp_oct.c ec2_oct.c ec_oct.c
	ec_lcl.h"

copy_crypto ecdh "ech_lib.c ech_ossl.c ech_key.c ech_err.c ech_locl.h"

copy_crypto ecdsa "ecs_lib.c ecs_asn1.c ecs_ossl.c ecs_sign.c ecs_vrf.c
	ecs_err.c ecs_locl.h"

# Engine interface is disabled
copy_crypto engine "eng_err.c eng_lib.c eng_list.c eng_init.c eng_ctrl.c
	eng_table.c eng_pkey.c eng_fat.c eng_all.c tb_rsa.c tb_dsa.c tb_ecdsa.c
	tb_dh.c tb_ecdh.c tb_rand.c tb_store.c tb_cipher.c tb_digest.c tb_pkmeth.c
	tb_asnmth.c eng_openssl.c eng_cnf.c eng_dyn.c eng_rsax.c eng_int.h"

copy_crypto err "err.c err_all.c err_prn.c"

copy_crypto evp "encode.c digest.c evp_enc.c evp_key.c e_des.c e_bf.c
	e_idea.c e_des3.c e_rc4.c e_aes.c names.c e_xcbc_d.c e_rc2.c e_cast.c
	m_null.c m_md4.c m_md5.c m_sha.c m_sha1.c m_wp.c m_dss.c m_dss1.c m_mdc2.c
	m_ripemd.c m_ecdsa.c p_open.c p_seal.c p_sign.c p_verify.c p_lib.c p_enc.c
	p_dec.c bio_md.c bio_b64.c bio_enc.c evp_err.c e_null.c c_all.c c_allc.c
	c_alld.c evp_lib.c evp_pkey.c evp_pbe.c p5_crpt.c p5_crpt2.c
	e_old.c pmeth_lib.c pmeth_fn.c pmeth_gn.c m_sigver.c e_aes_cbc_hmac_sha1.c
	e_rc4_hmac_md5.c evp_locl.h e_chacha.c evp_aead.c e_chacha20poly1305.c
	e_camellia.c e_gost2814789.c m_gost2814789.c m_gostr341194.c m_streebog.c"

copy_crypto gost "gost2814789.c gost89_keywrap.c gost89_params.c
	gost89imit_ameth.c gost89imit_pmeth.c gost_asn1.c gost_err.c gostr341001.c
	gostr341001_ameth.c gostr341001_key.c gostr341001_params.c
	gostr341001_pmeth.c gostr341194.c streebog.c gost.h gost_asn1.h
	gost_locl.h"

copy_crypto hmac "hmac.c hm_ameth.c hm_pmeth.c"

copy_crypto idea "i_cbc.c i_cfb64.c i_ofb64.c i_ecb.c i_skey.c idea_lcl.h"

copy_crypto krb5 "krb5_asn.c"

copy_crypto lhash "lhash.c lh_stats.c"

copy_crypto md4 "md4_dgst.c md4_one.c md4_locl.h"

copy_crypto md5 "md5_dgst.c md5_one.c md5_locl.h"

copy_crypto mdc2 "mdc2dgst.c mdc2_one.c"

copy_crypto modes "cbc128.c ctr128.c cts128.c cfb128.c ofb128.c gcm128.c
	ccm128.c xts128.c modes_lcl.h"

copy_crypto objects "o_names.c obj_dat.c obj_lib.c obj_err.c obj_xref.c obj_xref.h"

copy_crypto ocsp "ocsp_asn.c ocsp_ext.c ocsp_ht.c ocsp_lib.c ocsp_cl.c
	ocsp_srv.c ocsp_prn.c ocsp_vfy.c ocsp_err.c"

copy_crypto pem "pem_sign.c pem_seal.c pem_info.c pem_lib.c pem_all.c pem_err.c
	pem_x509.c pem_xaux.c pem_oth.c pem_pk8.c pem_pkey.c pvkfmt.c"

copy_crypto pkcs12 "p12_add.c p12_asn.c p12_attr.c p12_crpt.c p12_crt.c
	p12_decr.c p12_init.c p12_key.c p12_kiss.c p12_mutl.c p12_utl.c p12_npas.c
	pk12err.c p12_p8d.c p12_p8e.c"

copy_crypto pkcs7 "pk7_asn1.c pk7_lib.c pkcs7err.c pk7_doit.c pk7_smime.c
	pk7_attr.c pk7_mime.c bio_pk7.c"

copy_crypto poly1305 "poly1305-donna.c poly1305.c"

copy_crypto rand "randfile.c rand_err.c rand_lib.c"

copy_crypto rc2 "rc2_ecb.c rc2_skey.c rc2_cbc.c rc2cfb64.c rc2ofb64.c rc2_locl.h"

copy_crypto rc4 "rc4_enc.c rc4_skey.c rc4_locl.h"

copy_crypto ripemd "rmd_dgst.c rmd_one.c rmd_locl.h rmdconst.h"

copy_crypto rsa "rsa_eay.c rsa_gen.c rsa_lib.c rsa_sign.c rsa_saos.c rsa_err.c
	rsa_pk1.c rsa_ssl.c rsa_none.c rsa_oaep.c rsa_chk.c rsa_pss.c
	rsa_x931.c rsa_asn1.c rsa_depr.c rsa_ameth.c rsa_prn.c rsa_pmeth.c
	rsa_crpt.c rsa_locl.h"

copy_crypto sha "sha_dgst.c sha1dgst.c sha_one.c sha1_one.c sha256.c sha512.c sha_locl.h"

copy_crypto stack "stack.c"

copy_crypto ts "ts_err.c ts_req_utils.c ts_req_print.c ts_rsp_utils.c
	ts_rsp_print.c ts_rsp_sign.c ts_rsp_verify.c ts_verify_ctx.c ts_lib.c
	ts_conf.c ts_asn1.c"

copy_crypto txt_db "txt_db.c"

copy_crypto ui "ui_err.c ui_lib.c ui_openssl.c ui_openssl_win.c ui_util.c ui_locl.h"

copy_crypto whrlpool "wp_block.c wp_dgst.c wp_locl.h"

copy_crypto x509 "x509_def.c x509_d2.c x509_r2x.c x509_cmp.c x509_obj.c
	x509_req.c x509spki.c x509_vfy.c x509_set.c x509cset.c x509rset.c
	x509_err.c x509name.c x509_v3.c x509_ext.c x509_att.c x509type.c x509_lu.c
	x_all.c x509_txt.c x509_trs.c by_file.c by_dir.c x509_vpm.c x509_lcl.h"

copy_crypto x509v3 "v3_bcons.c v3_bitst.c v3_conf.c v3_extku.c v3_ia5.c v3_lib.c
	v3_prn.c v3_utl.c v3err.c v3_genn.c v3_alt.c v3_skey.c v3_akey.c v3_pku.c
	v3_int.c v3_enum.c v3_sxnet.c v3_cpols.c v3_crld.c v3_purp.c v3_info.c
	v3_ocsp.c v3_akeya.c v3_pmaps.c v3_pcons.c v3_ncons.c v3_pcia.c v3_pci.c
	pcy_cache.c pcy_node.c pcy_data.c pcy_map.c pcy_tree.c pcy_lib.c
	pcy_int.h ext_dat.h"

for i in $openssl_cmd_src/*; do
	cp $i apps
done

for i in aead/aeadtest.c aeswrap/aes_wrap.c base64/base64test.c bf/bftest.c \
	bn/general/bntest.c bn/mont/mont.c \
	cast/casttest.c chacha/chachatest.c cts128/cts128test.c \
	des/destest.c dh/dhtest.c dsa/dsatest.c ec/ectest.c ecdh/ecdhtest.c \
	ecdsa/ecdsatest.c engine/enginetest.c evp/evptest.c exp/exptest.c \
	gcm128/gcm128test.c hmac/hmactest.c idea/ideatest.c ige/igetest.c \
	md4/md4test.c md5/md5test.c mdc2/mdc2test.c poly1305/poly1305test.c \
	pkcs7/pkcs7test.c pqueue/pq_test.c rand/randtest.c rc2/rc2test.c \
	rc4/rc4test.c rmd/rmdtest.c sha/shatest.c sha1/sha1test.c \
	sha256/sha256test.c sha512/sha512test.c utf8/utf8test.c; do
	 $CP $libcrypto_regress/$i tests
done
$CP $libc_regress/arc4random-fork/arc4random-fork.c tests/arc4randomforktest.c
$CP $libc_regress/explicit_bzero/explicit_bzero.c tests
$CP $libc_regress/timingsafe/timingsafe.c tests

for i in asn1/asn1test.c ssl/ssltest.c ssl/testssl certs/ca.pem certs/server.pem; do
	$CP $libssl_regress/$i tests
done

# do not directly run all test programs
test_drivers=(
	aeadtest
	evptest
	pq_test
	ssltest
	arc4randomforktest
	pidwraptest
)
# disabled by-default tests
tests_disabled=(
	biotest
)
tests_posix_only=(
	arc4randomforktest
	explicit_bzero
	pidwraptest
)
$CP $libc_src/string/memmem.c tests/
(cd tests
	$CP Makefile.am.tpl Makefile.am

	for i in `ls -1 *.c|sort|grep -v memmem.c`; do
		TEST=`echo $i|sed -e "s/\.c//"`
		if [[ ${tests_posix_only[*]} =~ "$TEST" ]]; then
			echo "if !HOST_WIN" >> Makefile.am
		fi
		if ! [[ ${test_drivers[*]} =~ "$TEST" ]]; then
			echo "TESTS += $TEST" >> Makefile.am
		fi
		echo "check_PROGRAMS += $TEST" >> Makefile.am
		echo "${TEST}_SOURCES = $i" >> Makefile.am
		if [[ ${TEST} = "explicit_bzero" ]]; then
			echo "if !HAVE_MEMMEM" >> Makefile.am
			echo "explicit_bzero_SOURCES += memmem.c" >> Makefile.am
			echo "endif" >> Makefile.am
		fi
		if [[ ${tests_posix_only[*]} =~ "$TEST" ]]; then
			echo "endif" >> Makefile.am
		fi
	done
)
$CP $libcrypto_regress/evp/evptests.txt tests
$CP $libcrypto_regress/aead/aeadtests.txt tests
$CP $libcrypto_regress/pqueue/expected.txt tests/pq_expected.txt
chmod 755 tests/testssl
for i in "${test_drivers[@]}"; do
	if [ -e tests/${i}.sh ]; then
		if [[ ${tests_posix_only[*]} =~ "$i" ]]; then
			echo "if !HOST_WIN" >> tests/Makefile.am
		fi
		if ! [[ ${tests_disabled[*]} =~ "$i" ]]; then
			echo "TESTS += ${i}.sh" >> tests/Makefile.am
		else
			rm -f tests/$i*
		fi
		if [[ ${tests_posix_only[*]} =~ "$i" ]]; then
			echo "endif" >> tests/Makefile.am
		fi
		echo "EXTRA_DIST += ${i}.sh" >> tests/Makefile.am
	fi
done
echo "EXTRA_DIST += aeadtests.txt" >> tests/Makefile.am
echo "EXTRA_DIST += evptests.txt" >> tests/Makefile.am
echo "EXTRA_DIST += pq_expected.txt" >> tests/Makefile.am
echo "EXTRA_DIST += testssl ca.pem server.pem" >> tests/Makefile.am

(cd include/openssl
	$CP Makefile.am.tpl Makefile.am
	for i in `ls -1 *.h|sort`; do
		echo "opensslinclude_HEADERS += $i" >> Makefile.am
	done
)

(cd ssl
	sed -e "s/libssl-version/${libssl_version}/" Makefile.am.tpl > Makefile.am
	for i in `ls -1 *.c|sort`; do
		echo "libssl_la_SOURCES += $i" >> Makefile.am
	done
	for i in `ls -1 *.h|sort`; do
		echo "noinst_HEADERS += $i" >> Makefile.am
	done
)

# do not directly compile C files that are included in other C files
crypto_excludes=(
	des/ncbc_enc.c
	chacha/chacha-merged.c
	poly1305/poly1305-donna.c
	)
crypto_posix_only=(
	bio/b_posix.c
	ui/ui_openssl.c
	)
crypto_win32_only=(
	bio/b_win.c
	ui/ui_openssl_win.c
	)
(cd crypto
	sed -e "s/libcrypto-version/${libcrypto_version}/" Makefile.am.tpl > Makefile.am
	for i in `ls -1 *.c|sort`; do
		echo "libcrypto_la_SOURCES += $i" >> Makefile.am
	done
	for i in `ls -1 *.h|sort`; do
		echo "noinst_HEADERS += $i" >> Makefile.am
	done
	for subdir in $crypto_subdirs; do
		echo >> Makefile.am
		echo "# ${subdir}" >> Makefile.am
		for i in `ls -1 $subdir/*.c|sort`; do
			if [[ ${crypto_excludes[*]} =~ $i ]]; then
				echo "EXTRA_libcrypto_la_SOURCES += $i" >> Makefile.am
			elif [[ ${crypto_posix_only[*]} =~ $i ]]; then
				echo "if !HOST_WIN" >> Makefile.am
				echo "libcrypto_la_SOURCES += ${i}" >> Makefile.am
				echo "endif" >> Makefile.am
			elif [[ ${crypto_win32_only[*]} =~ $i ]]; then
				echo "if HOST_WIN" >> Makefile.am
				echo "libcrypto_la_SOURCES += ${i}" >> Makefile.am
				echo "endif" >> Makefile.am
			else
				echo "libcrypto_la_SOURCES += $i" >> Makefile.am
			fi
		done
		headers=`ls -1 $subdir/*.h 2>/dev/null |sort`
		if [ "$headers" != "" ]; then
			for i in $headers; do
				echo "noinst_HEADERS += $i" >> Makefile.am
			done
		fi
	done
)

# conditional compiles
$CP $libc_src/stdlib/strtonum.c apps/
apps_excludes=(
	poll.c
	strtonum.c
	)
apps_posix_only=(
	apps_posix.c
	)
apps_win32_only=(
	apps_win.c
	)
(cd apps
	$CP Makefile.am.tpl Makefile.am
	for i in `ls -1 *.c|sort`; do
		if [[ ${apps_posix_only[*]} =~ $i ]]; then
			echo "if !HOST_WIN" >> Makefile.am
			echo "openssl_SOURCES += ${i}" >> Makefile.am
			echo "endif" >> Makefile.am
		elif [[ ${apps_win32_only[*]} =~ $i ]]; then
			echo "if HOST_WIN" >> Makefile.am
			echo "openssl_SOURCES += ${i}" >> Makefile.am
			echo "endif" >> Makefile.am
		elif ! [[ ${apps_excludes[*]} =~ $i ]]; then
			echo "openssl_SOURCES += $i" >> Makefile.am
		fi
	done
	for i in `ls -1 *.h|sort`; do
		echo "noinst_HEADERS += $i" >> Makefile.am
	done
)

(cd man
	$CP Makefile.am.tpl Makefile.am

	# update new-style manpages
	for i in `ls -1 $libssl_src/src/doc/ssl/*.3 | sort`; do
		NAME=`basename "$i"`
		cp $i .
		echo "dist_man_MANS += $NAME" >> Makefile.am
	done
	$CP $openssl_cmd_src/openssl.1 .
	echo "dist_man_MANS += openssl.1" >> Makefile.am

	# convert remaining POD manpages
	for i in `ls -1 $libssl_src/src/doc/crypto/*.pod | sort`; do
		BASE=`echo $i|sed -e "s/\.pod//"`
		NAME=`basename "$BASE"`
		# reformat file if new
		if [ ! -f $NAME.3 -o $BASE.pod -nt $NAME.3 -o ../VERSION -nt $NAME.3 ]; then
			echo processing $NAME
			pod2man --official --release="LibreSSL $VERSION" --center=LibreSSL \
				--section=3 $POD2MAN --name=$NAME < $BASE.pod > $NAME.3
		fi
		echo "dist_man_MANS += $NAME.3" >> Makefile.am
	done

	echo "install-data-hook:" >> Makefile.am
	source ./links
	for i in $MLINKS; do
		IFS=","; set $i; unset IFS
		echo "	ln -f \$(DESTDIR)\$(mandir)/man3/$1 \$(DESTDIR)\$(mandir)/man3/$2" >> Makefile.am
	done
)
