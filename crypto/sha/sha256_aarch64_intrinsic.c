/* sha256-arm.c - ARMv8 SHA extensions using C intrinsics	 */
/*   Written and placed in public domain by Jeffrey Walton	*/
/*   Based on code from ARM, and by Johannes Schneiders, Skip */
/*   Hovsmith and Barry O'Rourke for the mbedTLS project.	 */

#include <stdint.h>

#if defined(__ARM_NEON) || defined(_MSC_VER) || defined(__GNUC__)
# include <arm_neon.h>
#endif

/* GCC and LLVM Clang, but not Apple Clang */
#if defined(__GNUC__) && !defined(__apple_build_version__)
# if defined(__ARM_ACLE) || defined(__ARM_FEATURE_CRYPTO)
#  include <arm_acle.h>
# endif
#endif

#include <openssl/sha.h>

static const uint32_t k256[] =
{
	0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5,
	0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5,
	0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3,
	0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174,
	0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC,
	0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
	0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7,
	0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967,
	0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13,
	0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85,
	0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3,
	0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
	0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5,
	0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3,
	0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208,
	0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2,
};

void
sha256_block_ce(SHA256_CTX *ctx, const void *in, size_t num)
{
	uint32_t *state = (uint32_t *)ctx->h;
	const uint8_t *data = in;

	uint32x4_t hs0, hs1, hc0, hc1;
	uint32x4_t msg0, msg1, msg2, msg3;
	uint32x4_t tmp0, tmp1, tmp2;

	/* Load state */
	hs0 = vld1q_u32(&state[0]);
	hs1 = vld1q_u32(&state[4]);

	while (num >= 1)
	{
		/* Save state */
		hc0 = hs0;
		hc1 = hs1;

		/* Load message */
		msg0 = vld1q_u32((const uint32_t *)(data +  0));
		msg1 = vld1q_u32((const uint32_t *)(data + 16));
		msg2 = vld1q_u32((const uint32_t *)(data + 32));
		msg3 = vld1q_u32((const uint32_t *)(data + 48));

		/* Reverse for little endian */
		msg0 = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg0)));
		msg1 = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg1)));
		msg2 = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg2)));
		msg3 = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg3)));

		tmp0 = vaddq_u32(msg0, vld1q_u32(&k256[0x00]));

		/* Rounds 0-3 */
		msg0 = vsha256su0q_u32(msg0, msg1);
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg1, vld1q_u32(&k256[0x04]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);
		msg0 = vsha256su1q_u32(msg0, msg2, msg3);

		/* Rounds 4-7 */
		msg1 = vsha256su0q_u32(msg1, msg2);
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg2, vld1q_u32(&k256[0x08]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);
		msg1 = vsha256su1q_u32(msg1, msg3, msg0);

		/* Rounds 8-11 */
		msg2 = vsha256su0q_u32(msg2, msg3);
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg3, vld1q_u32(&k256[0x0c]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);
		msg2 = vsha256su1q_u32(msg2, msg0, msg1);

		/* Rounds 12-15 */
		msg3 = vsha256su0q_u32(msg3, msg0);
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg0, vld1q_u32(&k256[0x10]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);
		msg3 = vsha256su1q_u32(msg3, msg1, msg2);

		/* Rounds 16-19 */
		msg0 = vsha256su0q_u32(msg0, msg1);
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg1, vld1q_u32(&k256[0x14]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);
		msg0 = vsha256su1q_u32(msg0, msg2, msg3);

		/* Rounds 20-23 */
		msg1 = vsha256su0q_u32(msg1, msg2);
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg2, vld1q_u32(&k256[0x18]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);
		msg1 = vsha256su1q_u32(msg1, msg3, msg0);

		/* Rounds 24-27 */
		msg2 = vsha256su0q_u32(msg2, msg3);
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg3, vld1q_u32(&k256[0x1c]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);
		msg2 = vsha256su1q_u32(msg2, msg0, msg1);

		/* Rounds 28-31 */
		msg3 = vsha256su0q_u32(msg3, msg0);
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg0, vld1q_u32(&k256[0x20]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);
		msg3 = vsha256su1q_u32(msg3, msg1, msg2);

		/* Rounds 32-35 */
		msg0 = vsha256su0q_u32(msg0, msg1);
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg1, vld1q_u32(&k256[0x24]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);
		msg0 = vsha256su1q_u32(msg0, msg2, msg3);

		/* Rounds 36-39 */
		msg1 = vsha256su0q_u32(msg1, msg2);
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg2, vld1q_u32(&k256[0x28]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);
		msg1 = vsha256su1q_u32(msg1, msg3, msg0);

		/* Rounds 40-43 */
		msg2 = vsha256su0q_u32(msg2, msg3);
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg3, vld1q_u32(&k256[0x2c]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);
		msg2 = vsha256su1q_u32(msg2, msg0, msg1);

		/* Rounds 44-47 */
		msg3 = vsha256su0q_u32(msg3, msg0);
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg0, vld1q_u32(&k256[0x30]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);
		msg3 = vsha256su1q_u32(msg3, msg1, msg2);

		/* Rounds 48-51 */
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg1, vld1q_u32(&k256[0x34]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);

		/* Rounds 52-55 */
		tmp2 = hs0;
		tmp0 = vaddq_u32(msg2, vld1q_u32(&k256[0x38]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);

		/* Rounds 56-59 */
		tmp2 = hs0;
		tmp1 = vaddq_u32(msg3, vld1q_u32(&k256[0x3c]));
		hs0 = vsha256hq_u32(hs0, hs1, tmp0);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp0);

		/* Rounds 60-63 */
		tmp2 = hs0;
		hs0 = vsha256hq_u32(hs0, hs1, tmp1);
		hs1 = vsha256h2q_u32(hs1, tmp2, tmp1);

		/* Combine state */
		hs0 = vaddq_u32(hs0, hc0);
		hs1 = vaddq_u32(hs1, hc1);

		data += 64;
		num -= 1;
	}

	/* Save state */
	vst1q_u32(&state[0], hs0);
	vst1q_u32(&state[4], hs1);
}

