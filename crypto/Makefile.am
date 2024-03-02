include $(top_srcdir)/Makefile.am.common

AM_CPPFLAGS += -DLIBRESSL_CRYPTO_INTERNAL
AM_CPPFLAGS += -I$(top_srcdir)/crypto/asn1
AM_CPPFLAGS += -I$(top_srcdir)/crypto/bio
AM_CPPFLAGS += -I$(top_srcdir)/crypto/bn
AM_CPPFLAGS += -I$(top_srcdir)/crypto/bytestring
AM_CPPFLAGS += -I$(top_srcdir)/crypto/curve25519
AM_CPPFLAGS += -I$(top_srcdir)/crypto/dh
AM_CPPFLAGS += -I$(top_srcdir)/crypto/dsa
AM_CPPFLAGS += -I$(top_srcdir)/crypto/ec
AM_CPPFLAGS += -I$(top_srcdir)/crypto/ecdh
AM_CPPFLAGS += -I$(top_srcdir)/crypto/ecdsa
AM_CPPFLAGS += -I$(top_srcdir)/crypto/evp
AM_CPPFLAGS += -I$(top_srcdir)/crypto/hmac
AM_CPPFLAGS += -I$(top_srcdir)/crypto/lhash
AM_CPPFLAGS += -I$(top_srcdir)/crypto/modes
AM_CPPFLAGS += -I$(top_srcdir)/crypto/ocsp
AM_CPPFLAGS += -I$(top_srcdir)/crypto/pkcs12
AM_CPPFLAGS += -I$(top_srcdir)/crypto/rsa
AM_CPPFLAGS += -I$(top_srcdir)/crypto/sha
AM_CPPFLAGS += -I$(top_srcdir)/crypto/stack
AM_CPPFLAGS += -I$(top_srcdir)/crypto/x509
AM_CPPFLAGS += -I$(top_srcdir)/crypto

noinst_LTLIBRARIES = libcompat.la

if ENABLE_LIBTLS_ONLY
noinst_LTLIBRARIES += libcrypto.la
else
lib_LTLIBRARIES = libcrypto.la
endif

EXTRA_DIST = VERSION
EXTRA_DIST += CMakeLists.txt
EXTRA_DIST += crypto.sym
EXTRA_DIST += empty.c

# needed for a CMake target
EXTRA_DIST += compat/strcasecmp.c
EXTRA_DIST += compat/getopt_long.c

BUILT_SOURCES = crypto_portable.sym
CLEANFILES = crypto_portable.sym
CLEANFILES += libcrypto_la_objects.mk

crypto_portable.sym: crypto.sym  Makefile
	-echo "generating crypto_portable.sym ..."
	-cp $(top_srcdir)/crypto/crypto.sym crypto_portable.sym
	-chmod u+w crypto_portable.sym
if HOST_WIN
	-grep -v BIO_s_log crypto_portable.sym > crypto_portable.sym.tmp
	-mv crypto_portable.sym.tmp crypto_portable.sym
endif

libcrypto_la_objects.mk: Makefile
	@echo "libcrypto_la_objects= $(libcrypto_la_OBJECTS)" \
	  | sed 's/  */ $$\(abs_top_builddir\)\/crypto\//g' \
	  > libcrypto_la_objects.mk
	@echo "libcompat_la_objects= $(libcompat_la_OBJECTS)" \
	  | sed 's/compat\// $$\(abs_top_builddir\)\/crypto\/&/g' \
	  >> libcrypto_la_objects.mk
	@echo "libcompatnoopt_la_objects= $(libcompatnoopt_la_OBJECTS)" \
	  | sed 's/compat\// $$\(abs_top_builddir\)\/crypto\/&/g' \
	  >> libcrypto_la_objects.mk

libcrypto_la_LDFLAGS = -version-info @LIBCRYPTO_VERSION@ -no-undefined -export-symbols crypto_portable.sym
EXTRA_libcrypto_la_DEPENDENCIES = crypto_portable.sym
EXTRA_libcrypto_la_DEPENDENCIES += libcrypto_la_objects.mk
libcrypto_la_LIBADD = libcompat.la
if !HAVE_EXPLICIT_BZERO
libcrypto_la_LIBADD += libcompatnoopt.la
endif
libcrypto_la_CPPFLAGS = -I$(top_srcdir)/crypto/hidden ${AM_CPPFLAGS}
libcrypto_la_CPPFLAGS += -DLIBRESSL_INTERNAL
libcrypto_la_CPPFLAGS += -DOPENSSL_NO_HW_PADLOCK

if OPENSSLDIR_DEFINED
libcrypto_la_CPPFLAGS += -DOPENSSLDIR=\"@OPENSSLDIR@\"
else
libcrypto_la_CPPFLAGS += -DOPENSSLDIR=\"$(sysconfdir)/ssl\"
endif

# compatibility functions that need to be built without optimizations
if !HAVE_EXPLICIT_BZERO
noinst_LTLIBRARIES += libcompatnoopt.la

libcompatnoopt_la_CFLAGS = -O0
libcompatnoopt_la_SOURCES =

if HOST_WIN
libcompatnoopt_la_SOURCES += compat/explicit_bzero_win.c
else
libcompatnoopt_la_SOURCES += compat/explicit_bzero.c
endif
endif

# other compatibility functions
libcompat_la_SOURCES =
libcompat_la_LIBADD = $(PLATFORM_LDADD)

if !HAVE_STRLCAT
libcompat_la_SOURCES += compat/strlcat.c
endif

if !HAVE_STRLCPY
libcompat_la_SOURCES += compat/strlcpy.c
endif

if !HAVE_STRNDUP
libcompat_la_SOURCES += compat/strndup.c
# the only user of strnlen is strndup, so only build it if needed
if !HAVE_STRNLEN
libcompat_la_SOURCES += compat/strnlen.c
endif
endif

if !HAVE_STRSEP
libcompat_la_SOURCES += compat/strsep.c
endif

if !HAVE_STRTONUM
libcompat_la_SOURCES += compat/strtonum.c
endif

if !HAVE_ASPRINTF
libcompat_la_SOURCES += compat/bsd-asprintf.c
endif

if !HAVE_FREEZERO
libcompat_la_SOURCES += compat/freezero.c
endif

if !HAVE_GETPAGESIZE
libcompat_la_SOURCES += compat/getpagesize.c
endif

if !HAVE_GETPROGNAME
if HOST_LINUX
libcompat_la_SOURCES += compat/getprogname_linux.c
else
if HOST_WIN
libcompat_la_SOURCES += compat/getprogname_windows.c
else
libcompat_la_SOURCES += compat/getprogname_unimpl.c
endif
endif
endif

if !HAVE_TIMEGM
libcompat_la_SOURCES += compat/timegm.c
endif

if !HAVE_REALLOCARRAY
libcompat_la_SOURCES += compat/reallocarray.c
endif

if !HAVE_RECALLOCARRAY
libcompat_la_SOURCES += compat/recallocarray.c
endif

if !HAVE_SYSLOG_R
libcompat_la_SOURCES += compat/syslog_r.c
endif

if !HAVE_TIMINGSAFE_MEMCMP
libcompat_la_SOURCES += compat/timingsafe_memcmp.c
endif

if !HAVE_TIMINGSAFE_BCMP
libcompat_la_SOURCES += compat/timingsafe_bcmp.c
endif

if HOST_WIN
libcompat_la_SOURCES += compat/posix_win.c
endif

include Makefile.am.arc4random

libcrypto_la_SOURCES =
EXTRA_libcrypto_la_SOURCES =

include Makefile.am.elf-arm
include Makefile.am.elf-mips
include Makefile.am.elf-mips64
include Makefile.am.elf-x86_64
include Makefile.am.macosx-x86_64
include Makefile.am.masm-x86_64
include Makefile.am.mingw64-x86_64

if !HOST_ASM_ELF_ARM
if !HOST_ASM_ELF_MIPS
if !HOST_ASM_ELF_MIPS64
if !HOST_ASM_ELF_X86_64
if !HOST_ASM_MACOSX_X86_64
if !HOST_ASM_MASM_X86_64
if !HOST_ASM_MINGW64_X86_64
libcrypto_la_CPPFLAGS += -DOPENSSL_NO_ASM
libcrypto_la_SOURCES += aes/aes_cbc.c
libcrypto_la_SOURCES += aes/aes_core.c
libcrypto_la_SOURCES += camellia/camellia.c
libcrypto_la_SOURCES += camellia/cmll_cbc.c
libcrypto_la_SOURCES += rc4/rc4_enc.c
libcrypto_la_SOURCES += rc4/rc4_skey.c
libcrypto_la_SOURCES += whrlpool/wp_block.c
endif
endif
endif
endif
endif
endif
endif

libcrypto_la_SOURCES += cpt_err.c
libcrypto_la_SOURCES += cryptlib.c
libcrypto_la_SOURCES += crypto_init.c
if !HOST_WIN
libcrypto_la_SOURCES += crypto_lock.c
else
libcrypto_la_SOURCES += compat/crypto_lock_win.c
endif
libcrypto_la_SOURCES += cversion.c
libcrypto_la_SOURCES += ex_data.c
libcrypto_la_SOURCES += malloc-wrapper.c
libcrypto_la_SOURCES += mem_clr.c
libcrypto_la_SOURCES += mem_dbg.c
libcrypto_la_SOURCES += o_fips.c
libcrypto_la_SOURCES += o_init.c
libcrypto_la_SOURCES += o_str.c
noinst_HEADERS += arm_arch.h
noinst_HEADERS += constant_time.h
noinst_HEADERS += cryptlib.h
noinst_HEADERS += crypto_internal.h
noinst_HEADERS += crypto_local.h
noinst_HEADERS += md32_common.h
noinst_HEADERS += x86_arch.h

# aes
libcrypto_la_SOURCES += aes/aes_cfb.c
libcrypto_la_SOURCES += aes/aes_ctr.c
libcrypto_la_SOURCES += aes/aes_ecb.c
libcrypto_la_SOURCES += aes/aes_ige.c
libcrypto_la_SOURCES += aes/aes_ofb.c
libcrypto_la_SOURCES += aes/aes_wrap.c
noinst_HEADERS += aes/aes_local.h

# asn1
libcrypto_la_SOURCES += asn1/a_bitstr.c
libcrypto_la_SOURCES += asn1/a_enum.c
libcrypto_la_SOURCES += asn1/a_int.c
libcrypto_la_SOURCES += asn1/a_mbstr.c
libcrypto_la_SOURCES += asn1/a_object.c
libcrypto_la_SOURCES += asn1/a_octet.c
libcrypto_la_SOURCES += asn1/a_pkey.c
libcrypto_la_SOURCES += asn1/a_print.c
libcrypto_la_SOURCES += asn1/a_pubkey.c
libcrypto_la_SOURCES += asn1/a_strex.c
libcrypto_la_SOURCES += asn1/a_string.c
libcrypto_la_SOURCES += asn1/a_strnid.c
libcrypto_la_SOURCES += asn1/a_time.c
libcrypto_la_SOURCES += asn1/a_time_posix.c
libcrypto_la_SOURCES += asn1/a_time_tm.c
libcrypto_la_SOURCES += asn1/a_type.c
libcrypto_la_SOURCES += asn1/a_utf8.c
libcrypto_la_SOURCES += asn1/asn1_err.c
libcrypto_la_SOURCES += asn1/asn1_gen.c
libcrypto_la_SOURCES += asn1/asn1_item.c
libcrypto_la_SOURCES += asn1/asn1_lib.c
libcrypto_la_SOURCES += asn1/asn1_old.c
libcrypto_la_SOURCES += asn1/asn1_old_lib.c
libcrypto_la_SOURCES += asn1/asn1_par.c
libcrypto_la_SOURCES += asn1/asn1_types.c
libcrypto_la_SOURCES += asn1/asn_mime.c
libcrypto_la_SOURCES += asn1/asn_moid.c
libcrypto_la_SOURCES += asn1/bio_asn1.c
libcrypto_la_SOURCES += asn1/bio_ndef.c
libcrypto_la_SOURCES += asn1/p5_pbe.c
libcrypto_la_SOURCES += asn1/p5_pbev2.c
libcrypto_la_SOURCES += asn1/p8_pkey.c
libcrypto_la_SOURCES += asn1/t_crl.c
libcrypto_la_SOURCES += asn1/t_req.c
libcrypto_la_SOURCES += asn1/t_spki.c
libcrypto_la_SOURCES += asn1/t_x509.c
libcrypto_la_SOURCES += asn1/t_x509a.c
libcrypto_la_SOURCES += asn1/tasn_dec.c
libcrypto_la_SOURCES += asn1/tasn_enc.c
libcrypto_la_SOURCES += asn1/tasn_fre.c
libcrypto_la_SOURCES += asn1/tasn_new.c
libcrypto_la_SOURCES += asn1/tasn_prn.c
libcrypto_la_SOURCES += asn1/tasn_typ.c
libcrypto_la_SOURCES += asn1/tasn_utl.c
libcrypto_la_SOURCES += asn1/x_algor.c
libcrypto_la_SOURCES += asn1/x_attrib.c
libcrypto_la_SOURCES += asn1/x_bignum.c
libcrypto_la_SOURCES += asn1/x_crl.c
libcrypto_la_SOURCES += asn1/x_exten.c
libcrypto_la_SOURCES += asn1/x_info.c
libcrypto_la_SOURCES += asn1/x_long.c
libcrypto_la_SOURCES += asn1/x_name.c
libcrypto_la_SOURCES += asn1/x_pkey.c
libcrypto_la_SOURCES += asn1/x_pubkey.c
libcrypto_la_SOURCES += asn1/x_req.c
libcrypto_la_SOURCES += asn1/x_sig.c
libcrypto_la_SOURCES += asn1/x_spki.c
libcrypto_la_SOURCES += asn1/x_val.c
libcrypto_la_SOURCES += asn1/x_x509.c
libcrypto_la_SOURCES += asn1/x_x509a.c
noinst_HEADERS += asn1/asn1_local.h
noinst_HEADERS += asn1/charmap.h

# bf
libcrypto_la_SOURCES += bf/bf_cfb64.c
libcrypto_la_SOURCES += bf/bf_ecb.c
libcrypto_la_SOURCES += bf/bf_enc.c
libcrypto_la_SOURCES += bf/bf_ofb64.c
libcrypto_la_SOURCES += bf/bf_skey.c
noinst_HEADERS += bf/bf_local.h

# bio
libcrypto_la_SOURCES += bio/b_dump.c
if !HOST_WIN
libcrypto_la_SOURCES += bio/b_posix.c
endif
libcrypto_la_SOURCES += bio/b_print.c
libcrypto_la_SOURCES += bio/b_sock.c
if HOST_WIN
libcrypto_la_SOURCES += bio/b_win.c
endif
libcrypto_la_SOURCES += bio/bf_buff.c
libcrypto_la_SOURCES += bio/bf_nbio.c
libcrypto_la_SOURCES += bio/bf_null.c
libcrypto_la_SOURCES += bio/bio_cb.c
libcrypto_la_SOURCES += bio/bio_err.c
libcrypto_la_SOURCES += bio/bio_lib.c
libcrypto_la_SOURCES += bio/bio_meth.c
libcrypto_la_SOURCES += bio/bss_acpt.c
libcrypto_la_SOURCES += bio/bss_bio.c
libcrypto_la_SOURCES += bio/bss_conn.c
libcrypto_la_SOURCES += bio/bss_dgram.c
libcrypto_la_SOURCES += bio/bss_fd.c
libcrypto_la_SOURCES += bio/bss_file.c
if !HOST_WIN
libcrypto_la_SOURCES += bio/bss_log.c
endif
libcrypto_la_SOURCES += bio/bss_mem.c
libcrypto_la_SOURCES += bio/bss_null.c
libcrypto_la_SOURCES += bio/bss_sock.c
noinst_HEADERS += bio/bio_local.h

# bn
libcrypto_la_SOURCES += bn/bn_add.c
libcrypto_la_SOURCES += bn/bn_bpsw.c
libcrypto_la_SOURCES += bn/bn_const.c
libcrypto_la_SOURCES += bn/bn_convert.c
libcrypto_la_SOURCES += bn/bn_ctx.c
libcrypto_la_SOURCES += bn/bn_div.c
libcrypto_la_SOURCES += bn/bn_err.c
libcrypto_la_SOURCES += bn/bn_exp.c
libcrypto_la_SOURCES += bn/bn_gcd.c
libcrypto_la_SOURCES += bn/bn_isqrt.c
libcrypto_la_SOURCES += bn/bn_kron.c
libcrypto_la_SOURCES += bn/bn_lib.c
libcrypto_la_SOURCES += bn/bn_mod.c
libcrypto_la_SOURCES += bn/bn_mod_sqrt.c
libcrypto_la_SOURCES += bn/bn_mont.c
libcrypto_la_SOURCES += bn/bn_mul.c
libcrypto_la_SOURCES += bn/bn_prime.c
libcrypto_la_SOURCES += bn/bn_primitives.c
libcrypto_la_SOURCES += bn/bn_print.c
libcrypto_la_SOURCES += bn/bn_rand.c
libcrypto_la_SOURCES += bn/bn_recp.c
libcrypto_la_SOURCES += bn/bn_shift.c
libcrypto_la_SOURCES += bn/bn_small_primes.c
libcrypto_la_SOURCES += bn/bn_sqr.c
libcrypto_la_SOURCES += bn/bn_word.c
noinst_HEADERS += bn/bn_internal.h
noinst_HEADERS += bn/bn_local.h
noinst_HEADERS += bn/bn_prime.h
noinst_HEADERS += bn/s2n_bignum.h
noinst_HEADERS += bn/s2n_bignum_internal.h

# bn/arch
if HOST_AARCH64
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/aarch64/
endif
noinst_HEADERS += bn/arch/aarch64/bn_arch.h

if HOST_ARM
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/arm/
endif
noinst_HEADERS += bn/arch/arm/bn_arch.h

if HOST_I386
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/i386/
endif
noinst_HEADERS += bn/arch/i386/bn_arch.h

if HOST_MIPS
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/mips/
endif
noinst_HEADERS += bn/arch/mips/bn_arch.h

if HOST_MIPS64
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/mips64/
endif
noinst_HEADERS += bn/arch/mips64/bn_arch.h

if HOST_POWERPC
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/powerpc/
endif
noinst_HEADERS += bn/arch/powerpc/bn_arch.h

if HOST_POWERPC64
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/powerpc64/
endif
noinst_HEADERS += bn/arch/powerpc64/bn_arch.h

if HOST_RISCV64
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/riscv64/
endif
noinst_HEADERS += bn/arch/riscv64/bn_arch.h

if HOST_SPARC64
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/sparc64/
endif
noinst_HEADERS += bn/arch/sparc64/bn_arch.h

if HOST_X86_64
libcrypto_la_CPPFLAGS += -I$(top_srcdir)/crypto/bn/arch/amd64/
endif
noinst_HEADERS += bn/arch/amd64/bn_arch.h

# buffer
libcrypto_la_SOURCES += buffer/buf_err.c
libcrypto_la_SOURCES += buffer/buffer.c
noinst_HEADERS += bytestring/bytestring.h

# bytestring
libcrypto_la_SOURCES += bytestring/bs_ber.c
libcrypto_la_SOURCES += bytestring/bs_cbb.c
libcrypto_la_SOURCES += bytestring/bs_cbs.c

# camellia
libcrypto_la_SOURCES += camellia/cmll_cfb.c
libcrypto_la_SOURCES += camellia/cmll_ctr.c
libcrypto_la_SOURCES += camellia/cmll_ecb.c
libcrypto_la_SOURCES += camellia/cmll_misc.c
libcrypto_la_SOURCES += camellia/cmll_ofb.c
noinst_HEADERS += camellia/camellia.h
noinst_HEADERS += camellia/cmll_local.h

# cast
libcrypto_la_SOURCES += cast/c_cfb64.c
libcrypto_la_SOURCES += cast/c_ecb.c
libcrypto_la_SOURCES += cast/c_enc.c
libcrypto_la_SOURCES += cast/c_ofb64.c
libcrypto_la_SOURCES += cast/c_skey.c
noinst_HEADERS += cast/cast_local.h
noinst_HEADERS += cast/cast_s.h

# chacha
EXTRA_libcrypto_la_SOURCES += chacha/chacha-merged.c
libcrypto_la_SOURCES += chacha/chacha.c

# cmac
libcrypto_la_SOURCES += cmac/cm_ameth.c
libcrypto_la_SOURCES += cmac/cm_pmeth.c
libcrypto_la_SOURCES += cmac/cmac.c

# cms
libcrypto_la_SOURCES += cms/cms_asn1.c
libcrypto_la_SOURCES += cms/cms_att.c
libcrypto_la_SOURCES += cms/cms_dd.c
libcrypto_la_SOURCES += cms/cms_enc.c
libcrypto_la_SOURCES += cms/cms_env.c
libcrypto_la_SOURCES += cms/cms_err.c
libcrypto_la_SOURCES += cms/cms_ess.c
libcrypto_la_SOURCES += cms/cms_io.c
libcrypto_la_SOURCES += cms/cms_kari.c
libcrypto_la_SOURCES += cms/cms_lib.c
libcrypto_la_SOURCES += cms/cms_pwri.c
libcrypto_la_SOURCES += cms/cms_sd.c
libcrypto_la_SOURCES += cms/cms_smime.c
noinst_HEADERS += cms/cms_local.h

# conf
libcrypto_la_SOURCES += conf/conf_api.c
libcrypto_la_SOURCES += conf/conf_def.c
libcrypto_la_SOURCES += conf/conf_err.c
libcrypto_la_SOURCES += conf/conf_lib.c
libcrypto_la_SOURCES += conf/conf_mall.c
libcrypto_la_SOURCES += conf/conf_mod.c
libcrypto_la_SOURCES += conf/conf_sap.c
noinst_HEADERS += conf/conf_def.h

# ct
libcrypto_la_SOURCES += ct/ct_b64.c
libcrypto_la_SOURCES += ct/ct_err.c
libcrypto_la_SOURCES += ct/ct_log.c
libcrypto_la_SOURCES += ct/ct_oct.c
libcrypto_la_SOURCES += ct/ct_policy.c
libcrypto_la_SOURCES += ct/ct_prn.c
libcrypto_la_SOURCES += ct/ct_sct.c
libcrypto_la_SOURCES += ct/ct_sct_ctx.c
libcrypto_la_SOURCES += ct/ct_vfy.c
libcrypto_la_SOURCES += ct/ct_x509v3.c
noinst_HEADERS += ct/ct_local.h

# curve25519
libcrypto_la_SOURCES += curve25519/curve25519-generic.c
libcrypto_la_SOURCES += curve25519/curve25519.c
noinst_HEADERS += curve25519/curve25519_internal.h


# des
libcrypto_la_SOURCES += des/cbc_cksm.c
libcrypto_la_SOURCES += des/cbc_enc.c
libcrypto_la_SOURCES += des/cfb64ede.c
libcrypto_la_SOURCES += des/cfb64enc.c
libcrypto_la_SOURCES += des/cfb_enc.c
libcrypto_la_SOURCES += des/des_enc.c
libcrypto_la_SOURCES += des/ecb3_enc.c
libcrypto_la_SOURCES += des/ecb_enc.c
libcrypto_la_SOURCES += des/ede_cbcm_enc.c
libcrypto_la_SOURCES += des/enc_read.c
libcrypto_la_SOURCES += des/enc_writ.c
libcrypto_la_SOURCES += des/fcrypt.c
libcrypto_la_SOURCES += des/fcrypt_b.c
EXTRA_libcrypto_la_SOURCES += des/ncbc_enc.c
libcrypto_la_SOURCES += des/ofb64ede.c
libcrypto_la_SOURCES += des/ofb64enc.c
libcrypto_la_SOURCES += des/ofb_enc.c
libcrypto_la_SOURCES += des/pcbc_enc.c
libcrypto_la_SOURCES += des/qud_cksm.c
libcrypto_la_SOURCES += des/set_key.c
libcrypto_la_SOURCES += des/str2key.c
libcrypto_la_SOURCES += des/xcbc_enc.c
noinst_HEADERS += des/des_local.h
noinst_HEADERS += des/spr.h

# dh
libcrypto_la_SOURCES += dh/dh_ameth.c
libcrypto_la_SOURCES += dh/dh_asn1.c
libcrypto_la_SOURCES += dh/dh_check.c
libcrypto_la_SOURCES += dh/dh_err.c
libcrypto_la_SOURCES += dh/dh_gen.c
libcrypto_la_SOURCES += dh/dh_key.c
libcrypto_la_SOURCES += dh/dh_lib.c
libcrypto_la_SOURCES += dh/dh_pmeth.c
noinst_HEADERS += dh/dh_local.h

# dsa
libcrypto_la_SOURCES += dsa/dsa_ameth.c
libcrypto_la_SOURCES += dsa/dsa_asn1.c
libcrypto_la_SOURCES += dsa/dsa_err.c
libcrypto_la_SOURCES += dsa/dsa_gen.c
libcrypto_la_SOURCES += dsa/dsa_key.c
libcrypto_la_SOURCES += dsa/dsa_lib.c
libcrypto_la_SOURCES += dsa/dsa_meth.c
libcrypto_la_SOURCES += dsa/dsa_ossl.c
libcrypto_la_SOURCES += dsa/dsa_pmeth.c
libcrypto_la_SOURCES += dsa/dsa_prn.c
noinst_HEADERS += dsa/dsa_local.h

# ec
libcrypto_la_SOURCES += ec/ec_ameth.c
libcrypto_la_SOURCES += ec/ec_asn1.c
libcrypto_la_SOURCES += ec/ec_check.c
libcrypto_la_SOURCES += ec/ec_curve.c
libcrypto_la_SOURCES += ec/ec_cvt.c
libcrypto_la_SOURCES += ec/ec_err.c
libcrypto_la_SOURCES += ec/ec_key.c
libcrypto_la_SOURCES += ec/ec_kmeth.c
libcrypto_la_SOURCES += ec/ec_lib.c
libcrypto_la_SOURCES += ec/ec_mult.c
libcrypto_la_SOURCES += ec/ec_oct.c
libcrypto_la_SOURCES += ec/ec_pmeth.c
libcrypto_la_SOURCES += ec/ec_print.c
libcrypto_la_SOURCES += ec/eck_prn.c
libcrypto_la_SOURCES += ec/ecp_mont.c
libcrypto_la_SOURCES += ec/ecp_oct.c
libcrypto_la_SOURCES += ec/ecp_smpl.c
libcrypto_la_SOURCES += ec/ecx_methods.c
noinst_HEADERS += ec/ec_local.h

# ecdh
libcrypto_la_SOURCES += ecdh/ecdh.c

# ecdsa
libcrypto_la_SOURCES += ecdsa/ecdsa.c
noinst_HEADERS += ecdsa/ecdsa_local.h

# engine
libcrypto_la_SOURCES += engine/engine_stubs.c

# err
libcrypto_la_SOURCES += err/err.c
libcrypto_la_SOURCES += err/err_all.c
libcrypto_la_SOURCES += err/err_prn.c

# evp
libcrypto_la_SOURCES += evp/bio_b64.c
libcrypto_la_SOURCES += evp/bio_enc.c
libcrypto_la_SOURCES += evp/bio_md.c
libcrypto_la_SOURCES += evp/e_aes.c
libcrypto_la_SOURCES += evp/e_bf.c
libcrypto_la_SOURCES += evp/e_camellia.c
libcrypto_la_SOURCES += evp/e_cast.c
libcrypto_la_SOURCES += evp/e_chacha.c
libcrypto_la_SOURCES += evp/e_chacha20poly1305.c
libcrypto_la_SOURCES += evp/e_des.c
libcrypto_la_SOURCES += evp/e_des3.c
libcrypto_la_SOURCES += evp/e_idea.c
libcrypto_la_SOURCES += evp/e_null.c
libcrypto_la_SOURCES += evp/e_rc2.c
libcrypto_la_SOURCES += evp/e_rc4.c
libcrypto_la_SOURCES += evp/e_sm4.c
libcrypto_la_SOURCES += evp/e_xcbc_d.c
libcrypto_la_SOURCES += evp/evp_aead.c
libcrypto_la_SOURCES += evp/evp_cipher.c
libcrypto_la_SOURCES += evp/evp_digest.c
libcrypto_la_SOURCES += evp/evp_encode.c
libcrypto_la_SOURCES += evp/evp_err.c
libcrypto_la_SOURCES += evp/evp_key.c
libcrypto_la_SOURCES += evp/evp_names.c
libcrypto_la_SOURCES += evp/evp_pbe.c
libcrypto_la_SOURCES += evp/evp_pkey.c
libcrypto_la_SOURCES += evp/m_md4.c
libcrypto_la_SOURCES += evp/m_md5.c
libcrypto_la_SOURCES += evp/m_md5_sha1.c
libcrypto_la_SOURCES += evp/m_null.c
libcrypto_la_SOURCES += evp/m_ripemd.c
libcrypto_la_SOURCES += evp/m_sha1.c
libcrypto_la_SOURCES += evp/m_sha3.c
libcrypto_la_SOURCES += evp/m_sigver.c
libcrypto_la_SOURCES += evp/m_sm3.c
libcrypto_la_SOURCES += evp/m_wp.c
libcrypto_la_SOURCES += evp/p_legacy.c
libcrypto_la_SOURCES += evp/p_lib.c
libcrypto_la_SOURCES += evp/p_sign.c
libcrypto_la_SOURCES += evp/p_verify.c
libcrypto_la_SOURCES += evp/pmeth_fn.c
libcrypto_la_SOURCES += evp/pmeth_gn.c
libcrypto_la_SOURCES += evp/pmeth_lib.c
noinst_HEADERS += evp/evp_local.h

# hidden
noinst_HEADERS += hidden/crypto_namespace.h
noinst_HEADERS += hidden/openssl/asn1.h
noinst_HEADERS += hidden/openssl/asn1t.h
noinst_HEADERS += hidden/openssl/bio.h
noinst_HEADERS += hidden/openssl/bn.h
noinst_HEADERS += hidden/openssl/buffer.h
noinst_HEADERS += hidden/openssl/cast.h
noinst_HEADERS += hidden/openssl/chacha.h
noinst_HEADERS += hidden/openssl/cmac.h
noinst_HEADERS += hidden/openssl/cms.h
noinst_HEADERS += hidden/openssl/conf_api.h
noinst_HEADERS += hidden/openssl/crypto.h
noinst_HEADERS += hidden/openssl/ct.h
noinst_HEADERS += hidden/openssl/curve25519.h
noinst_HEADERS += hidden/openssl/dh.h
noinst_HEADERS += hidden/openssl/dsa.h
noinst_HEADERS += hidden/openssl/ec.h
noinst_HEADERS += hidden/openssl/err.h
noinst_HEADERS += hidden/openssl/hkdf.h
noinst_HEADERS += hidden/openssl/hmac.h
noinst_HEADERS += hidden/openssl/idea.h
noinst_HEADERS += hidden/openssl/lhash.h
noinst_HEADERS += hidden/openssl/md4.h
noinst_HEADERS += hidden/openssl/md5.h
noinst_HEADERS += hidden/openssl/modes.h
noinst_HEADERS += hidden/openssl/objects.h
noinst_HEADERS += hidden/openssl/ocsp.h
noinst_HEADERS += hidden/openssl/pem.h
noinst_HEADERS += hidden/openssl/pkcs12.h
noinst_HEADERS += hidden/openssl/pkcs7.h
noinst_HEADERS += hidden/openssl/poly1305.h
noinst_HEADERS += hidden/openssl/posix_time.h
noinst_HEADERS += hidden/openssl/rand.h
noinst_HEADERS += hidden/openssl/rc2.h
noinst_HEADERS += hidden/openssl/rsa.h
noinst_HEADERS += hidden/openssl/sha.h
noinst_HEADERS += hidden/openssl/sm3.h
noinst_HEADERS += hidden/openssl/sm4.h
noinst_HEADERS += hidden/openssl/stack.h
noinst_HEADERS += hidden/openssl/ts.h
noinst_HEADERS += hidden/openssl/txt_db.h
noinst_HEADERS += hidden/openssl/ui.h
noinst_HEADERS += hidden/openssl/x509.h
noinst_HEADERS += hidden/openssl/x509_vfy.h
noinst_HEADERS += hidden/openssl/x509v3.h

# hkdf
libcrypto_la_SOURCES += hkdf/hkdf.c

# hmac
libcrypto_la_SOURCES += hmac/hm_ameth.c
libcrypto_la_SOURCES += hmac/hm_pmeth.c
libcrypto_la_SOURCES += hmac/hmac.c
noinst_HEADERS += hmac/hmac_local.h

# idea
libcrypto_la_SOURCES += idea/i_cbc.c
libcrypto_la_SOURCES += idea/i_cfb64.c
libcrypto_la_SOURCES += idea/i_ecb.c
libcrypto_la_SOURCES += idea/i_ofb64.c
libcrypto_la_SOURCES += idea/i_skey.c
noinst_HEADERS += idea/idea_local.h

# kdf
libcrypto_la_SOURCES += kdf/hkdf_evp.c
libcrypto_la_SOURCES += kdf/kdf_err.c

# lhash
libcrypto_la_SOURCES += lhash/lhash.c
noinst_HEADERS += lhash/lhash_local.h

# md4
libcrypto_la_SOURCES += md4/md4.c

# md5
libcrypto_la_SOURCES += md5/md5.c

# modes
libcrypto_la_SOURCES += modes/cbc128.c
libcrypto_la_SOURCES += modes/ccm128.c
libcrypto_la_SOURCES += modes/cfb128.c
libcrypto_la_SOURCES += modes/ctr128.c
libcrypto_la_SOURCES += modes/gcm128.c
libcrypto_la_SOURCES += modes/ofb128.c
libcrypto_la_SOURCES += modes/xts128.c
noinst_HEADERS += modes/modes_local.h

# objects
libcrypto_la_SOURCES += objects/obj_dat.c
libcrypto_la_SOURCES += objects/obj_err.c
libcrypto_la_SOURCES += objects/obj_lib.c
libcrypto_la_SOURCES += objects/obj_xref.c
noinst_HEADERS += objects/obj_dat.h

# ocsp
libcrypto_la_SOURCES += ocsp/ocsp_asn.c
libcrypto_la_SOURCES += ocsp/ocsp_cl.c
libcrypto_la_SOURCES += ocsp/ocsp_err.c
libcrypto_la_SOURCES += ocsp/ocsp_ext.c
libcrypto_la_SOURCES += ocsp/ocsp_ht.c
libcrypto_la_SOURCES += ocsp/ocsp_lib.c
libcrypto_la_SOURCES += ocsp/ocsp_prn.c
libcrypto_la_SOURCES += ocsp/ocsp_srv.c
libcrypto_la_SOURCES += ocsp/ocsp_vfy.c
noinst_HEADERS += ocsp/ocsp_local.h

# pem
libcrypto_la_SOURCES += pem/pem_all.c
libcrypto_la_SOURCES += pem/pem_err.c
libcrypto_la_SOURCES += pem/pem_info.c
libcrypto_la_SOURCES += pem/pem_lib.c
libcrypto_la_SOURCES += pem/pem_oth.c
libcrypto_la_SOURCES += pem/pem_pk8.c
libcrypto_la_SOURCES += pem/pem_pkey.c
libcrypto_la_SOURCES += pem/pem_sign.c
libcrypto_la_SOURCES += pem/pem_x509.c
libcrypto_la_SOURCES += pem/pem_xaux.c
libcrypto_la_SOURCES += pem/pvkfmt.c

# pkcs12
libcrypto_la_SOURCES += pkcs12/p12_add.c
libcrypto_la_SOURCES += pkcs12/p12_asn.c
libcrypto_la_SOURCES += pkcs12/p12_attr.c
libcrypto_la_SOURCES += pkcs12/p12_crt.c
libcrypto_la_SOURCES += pkcs12/p12_decr.c
libcrypto_la_SOURCES += pkcs12/p12_init.c
libcrypto_la_SOURCES += pkcs12/p12_key.c
libcrypto_la_SOURCES += pkcs12/p12_kiss.c
libcrypto_la_SOURCES += pkcs12/p12_mutl.c
libcrypto_la_SOURCES += pkcs12/p12_npas.c
libcrypto_la_SOURCES += pkcs12/p12_p8d.c
libcrypto_la_SOURCES += pkcs12/p12_p8e.c
libcrypto_la_SOURCES += pkcs12/p12_sbag.c
libcrypto_la_SOURCES += pkcs12/p12_utl.c
libcrypto_la_SOURCES += pkcs12/pk12err.c
noinst_HEADERS += pkcs12/pkcs12_local.h

# pkcs7
libcrypto_la_SOURCES += pkcs7/pk7_asn1.c
libcrypto_la_SOURCES += pkcs7/pk7_attr.c
libcrypto_la_SOURCES += pkcs7/pk7_doit.c
libcrypto_la_SOURCES += pkcs7/pk7_lib.c
libcrypto_la_SOURCES += pkcs7/pk7_mime.c
libcrypto_la_SOURCES += pkcs7/pk7_smime.c
libcrypto_la_SOURCES += pkcs7/pkcs7err.c

# poly1305
EXTRA_libcrypto_la_SOURCES += poly1305/poly1305-donna.c
libcrypto_la_SOURCES += poly1305/poly1305.c

# rand
libcrypto_la_SOURCES += rand/rand_err.c
libcrypto_la_SOURCES += rand/rand_lib.c
libcrypto_la_SOURCES += rand/randfile.c

# rc2
libcrypto_la_SOURCES += rc2/rc2_cbc.c
libcrypto_la_SOURCES += rc2/rc2_ecb.c
libcrypto_la_SOURCES += rc2/rc2_skey.c
libcrypto_la_SOURCES += rc2/rc2cfb64.c
libcrypto_la_SOURCES += rc2/rc2ofb64.c
noinst_HEADERS += rc2/rc2_local.h

# rc4
noinst_HEADERS += rc4/rc4_local.h

# ripemd
libcrypto_la_SOURCES += ripemd/ripemd.c

# rsa
libcrypto_la_SOURCES += rsa/rsa_ameth.c
libcrypto_la_SOURCES += rsa/rsa_asn1.c
libcrypto_la_SOURCES += rsa/rsa_blinding.c
libcrypto_la_SOURCES += rsa/rsa_chk.c
libcrypto_la_SOURCES += rsa/rsa_eay.c
libcrypto_la_SOURCES += rsa/rsa_err.c
libcrypto_la_SOURCES += rsa/rsa_gen.c
libcrypto_la_SOURCES += rsa/rsa_lib.c
libcrypto_la_SOURCES += rsa/rsa_meth.c
libcrypto_la_SOURCES += rsa/rsa_none.c
libcrypto_la_SOURCES += rsa/rsa_oaep.c
libcrypto_la_SOURCES += rsa/rsa_pk1.c
libcrypto_la_SOURCES += rsa/rsa_pmeth.c
libcrypto_la_SOURCES += rsa/rsa_prn.c
libcrypto_la_SOURCES += rsa/rsa_pss.c
libcrypto_la_SOURCES += rsa/rsa_saos.c
libcrypto_la_SOURCES += rsa/rsa_sign.c
libcrypto_la_SOURCES += rsa/rsa_x931.c
noinst_HEADERS += rsa/rsa_local.h

# sha
libcrypto_la_SOURCES += sha/sha1.c
libcrypto_la_SOURCES += sha/sha256.c
libcrypto_la_SOURCES += sha/sha3.c
libcrypto_la_SOURCES += sha/sha512.c
noinst_HEADERS += sha/sha_internal.h
noinst_HEADERS += sha/sha3_internal.h

# sm3
libcrypto_la_SOURCES += sm3/sm3.c

# sm4
libcrypto_la_SOURCES += sm4/sm4.c

# stack
libcrypto_la_SOURCES += stack/stack.c
noinst_HEADERS += stack/stack_local.h

# ts
libcrypto_la_SOURCES += ts/ts_asn1.c
libcrypto_la_SOURCES += ts/ts_conf.c
libcrypto_la_SOURCES += ts/ts_err.c
libcrypto_la_SOURCES += ts/ts_lib.c
libcrypto_la_SOURCES += ts/ts_req_print.c
libcrypto_la_SOURCES += ts/ts_req_utils.c
libcrypto_la_SOURCES += ts/ts_rsp_print.c
libcrypto_la_SOURCES += ts/ts_rsp_sign.c
libcrypto_la_SOURCES += ts/ts_rsp_utils.c
libcrypto_la_SOURCES += ts/ts_rsp_verify.c
libcrypto_la_SOURCES += ts/ts_verify_ctx.c
noinst_HEADERS += ts/ts_local.h

# txt_db
libcrypto_la_SOURCES += txt_db/txt_db.c

# ui
libcrypto_la_SOURCES += ui/ui_err.c
libcrypto_la_SOURCES += ui/ui_lib.c
libcrypto_la_SOURCES += ui/ui_null.c
if !HOST_WIN
libcrypto_la_SOURCES += ui/ui_openssl.c
endif
if HOST_WIN
libcrypto_la_SOURCES += ui/ui_openssl_win.c
endif
libcrypto_la_SOURCES += ui/ui_util.c
noinst_HEADERS += ui/ui_local.h

# whrlpool
libcrypto_la_SOURCES += whrlpool/wp_dgst.c
noinst_HEADERS += whrlpool/wp_local.h

# x509
libcrypto_la_SOURCES += x509/by_dir.c
libcrypto_la_SOURCES += x509/by_file.c
libcrypto_la_SOURCES += x509/by_mem.c
libcrypto_la_SOURCES += x509/x509_addr.c
libcrypto_la_SOURCES += x509/x509_akey.c
libcrypto_la_SOURCES += x509/x509_akeya.c
libcrypto_la_SOURCES += x509/x509_alt.c
libcrypto_la_SOURCES += x509/x509_att.c
libcrypto_la_SOURCES += x509/x509_asid.c
libcrypto_la_SOURCES += x509/x509_bcons.c
libcrypto_la_SOURCES += x509/x509_bitst.c
libcrypto_la_SOURCES += x509/x509_cmp.c
libcrypto_la_SOURCES += x509/x509_conf.c
libcrypto_la_SOURCES += x509/x509_constraints.c
libcrypto_la_SOURCES += x509/x509_cpols.c
libcrypto_la_SOURCES += x509/x509_crld.c
libcrypto_la_SOURCES += x509/x509_d2.c
libcrypto_la_SOURCES += x509/x509_def.c
libcrypto_la_SOURCES += x509/x509_err.c
libcrypto_la_SOURCES += x509/x509_ext.c
libcrypto_la_SOURCES += x509/x509_extku.c
libcrypto_la_SOURCES += x509/x509_genn.c
libcrypto_la_SOURCES += x509/x509_ia5.c
libcrypto_la_SOURCES += x509/x509_info.c
libcrypto_la_SOURCES += x509/x509_int.c
libcrypto_la_SOURCES += x509/x509_issuer_cache.c
libcrypto_la_SOURCES += x509/x509_lib.c
libcrypto_la_SOURCES += x509/x509_lu.c
libcrypto_la_SOURCES += x509/x509_ncons.c
libcrypto_la_SOURCES += x509/x509_obj.c
libcrypto_la_SOURCES += x509/x509_ocsp.c
libcrypto_la_SOURCES += x509/x509_pcons.c
libcrypto_la_SOURCES += x509/x509_pku.c
libcrypto_la_SOURCES += x509/x509_policy.c
libcrypto_la_SOURCES += x509/x509_pmaps.c
libcrypto_la_SOURCES += x509/x509_prn.c
libcrypto_la_SOURCES += x509/x509_purp.c
libcrypto_la_SOURCES += x509/x509_r2x.c
libcrypto_la_SOURCES += x509/x509_req.c
libcrypto_la_SOURCES += x509/x509_set.c
libcrypto_la_SOURCES += x509/x509_skey.c
libcrypto_la_SOURCES += x509/x509_trs.c
libcrypto_la_SOURCES += x509/x509_txt.c
libcrypto_la_SOURCES += x509/x509_utl.c
libcrypto_la_SOURCES += x509/x509_v3.c
libcrypto_la_SOURCES += x509/x509_verify.c
libcrypto_la_SOURCES += x509/x509_vfy.c
libcrypto_la_SOURCES += x509/x509_vpm.c
libcrypto_la_SOURCES += x509/x509cset.c
libcrypto_la_SOURCES += x509/x509name.c
libcrypto_la_SOURCES += x509/x509rset.c
libcrypto_la_SOURCES += x509/x509spki.c
libcrypto_la_SOURCES += x509/x509type.c
libcrypto_la_SOURCES += x509/x_all.c
noinst_HEADERS += x509/x509_internal.h
noinst_HEADERS += x509/x509_issuer_cache.h
noinst_HEADERS += x509/x509_local.h
noinst_HEADERS += x509/x509_verify.h
