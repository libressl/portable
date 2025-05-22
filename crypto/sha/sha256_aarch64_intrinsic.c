#include <stdint.h>

#include <arm_neon.h>
#include <arm_acle.h>

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

#define sha256_round(h0, h1, w, k) \
		tmp0 = vaddq_u32(w, k); \
		tmp1 = h0; \
		h0 = vsha256hq_u32(h0, h1, tmp0); \
		h1 = vsha256h2q_u32(h1, tmp1, tmp0);

#define sha256_round_update(h0, h1, m0, m1, m2, m3, k) \
		m0 = vsha256su0q_u32(m0, m1); \
		m0 = vsha256su1q_u32(m0, m2, m3); \
		sha256_round(h0, h1, m0, k);

void
sha256_block_intrinsic(SHA256_CTX *ctx, const void *in, size_t num)
{
	uint32_t *state = (uint32_t *)ctx->h;
	const uint8_t *data = in;

	uint32x4_t hs0, hs1, hc0, hc1;
	uint32x4x4_t msg;
	uint32x4_t tmp0, tmp1;

	uint32x4x4_t k;

	/* Load state */
	hc0 = vld1q_u32(&state[0]);
	hc1 = vld1q_u32(&state[4]);

	while (num >= 1)
	{
//		__builtin_debugtrap();

		/* Copy current hash state. */
		hs0 = hc0;
		hs1 = hc1;

		/* Load and byte swap message schedule */
		msg = vld1q_u32_x4((const uint32_t *)data);
		msg.val[0] = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg.val[0])));
		msg.val[1] = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg.val[1])));
		msg.val[2] = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg.val[2])));
		msg.val[3] = vreinterpretq_u32_u8(vrev32q_u8(vreinterpretq_u8_u32(msg.val[3])));

		/* Rounds 0 through 15 (four rounds at a time). */
		k = vld1q_u32_x4(k256);

		sha256_round(hs0, hs1, msg.val[0], k.val[0])
		sha256_round(hs0, hs1, msg.val[1], k.val[1])
		sha256_round(hs0, hs1, msg.val[2], k.val[2])
		sha256_round(hs0, hs1, msg.val[3], k.val[3])

		/* Rounds 16 through 31 (four rounds at a time). */
		k = vld1q_u32_x4(k256 + 16);

		sha256_round_update(hs0, hs1, msg.val[0], msg.val[1], msg.val[2], msg.val[3], k.val[0])
		sha256_round_update(hs0, hs1, msg.val[1], msg.val[2], msg.val[3], msg.val[0], k.val[1])
		sha256_round_update(hs0, hs1, msg.val[2], msg.val[3], msg.val[0], msg.val[1], k.val[2])
		sha256_round_update(hs0, hs1, msg.val[3], msg.val[0], msg.val[1], msg.val[2], k.val[3])

		/* Rounds 32 through 47 (four rounds at a time). */
		k = vld1q_u32_x4(k256 + 32);

		sha256_round_update(hs0, hs1, msg.val[0], msg.val[1], msg.val[2], msg.val[3], k.val[0])
		sha256_round_update(hs0, hs1, msg.val[1], msg.val[2], msg.val[3], msg.val[0], k.val[1])
		sha256_round_update(hs0, hs1, msg.val[2], msg.val[3], msg.val[0], msg.val[1], k.val[2])
		sha256_round_update(hs0, hs1, msg.val[3], msg.val[0], msg.val[1], msg.val[2], k.val[3])

		/* Rounds 48 through 63 (four rounds at a time). */
		k = vld1q_u32_x4(k256 + 48);

		sha256_round_update(hs0, hs1, msg.val[0], msg.val[1], msg.val[2], msg.val[3], k.val[0])
		sha256_round_update(hs0, hs1, msg.val[1], msg.val[2], msg.val[3], msg.val[0], k.val[1])
		sha256_round_update(hs0, hs1, msg.val[2], msg.val[3], msg.val[0], msg.val[1], k.val[2])
		sha256_round_update(hs0, hs1, msg.val[3], msg.val[0], msg.val[1], msg.val[2], k.val[3])

		/* Add intermediate state to hash state. */
		hc0 = vaddq_u32(hs0, hc0);
		hc1 = vaddq_u32(hs1, hc1);

		data += 64;
		num -= 1;
	}

	/* Save state */
	vst1q_u32(&state[0], hc0);
	vst1q_u32(&state[4], hc1);
}

