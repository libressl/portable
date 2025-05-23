#include <stdint.h>

#include <arm_neon.h>
#include <arm_acle.h>

#include <openssl/sha.h>

/*
 * SHA-512 constants - see FIPS 180-4 section 4.2.3.
 */
static const uint64_t k512[] =
{
	0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc,
	0x3956c25bf348b538, 0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118,
	0xd807aa98a3030242, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
	0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 0xc19bf174cf692694,
	0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65,
	0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
	0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4,
	0xc6e00bf33da88fc2, 0xd5a79147930aa725, 0x06ca6351e003826f, 0x142929670a0e6e70,
	0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
	0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b,
	0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30,
	0xd192e819d6ef5218, 0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
	0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8,
	0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3,
	0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
	0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b,
	0xca273eceea26619c, 0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178,
	0x06f067aa72176fba, 0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
	0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c,
	0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817
};


#include <stdio.h>
#include <inttypes.h>

void
sha512_block_intrinsic(SHA512_CTX *ctx, const void *in, size_t num)
{
	uint64_t *state = (uint64_t *)ctx->h;
	const uint8_t *data = in;

	uint64x2_t hs0, hs1, hs2, hs3;
	uint64x2_t hc0, hc1, hc2, hc3;
	uint64x2_t msg0, msg1, msg2, msg3, msg4, msg5, msg6, msg7;
	uint64x2_t tmp0, tmp1, tmp2;

	/* Load state */
	hc0 = vld1q_u64(&state[0]);
	hc1 = vld1q_u64(&state[2]);
	hc2 = vld1q_u64(&state[4]);
	hc3 = vld1q_u64(&state[6]);

	while (num >= 1)
	{
		/* Save state */
		hs0 = hc0;
		hs1 = hc1;
		hs2 = hc2;
		hs3 = hc3;

		/* Load message */
		msg0 = vld1q_u64((const uint64_t *)(data +   0));
		msg1 = vld1q_u64((const uint64_t *)(data +  16));
		msg2 = vld1q_u64((const uint64_t *)(data +  32));
		msg3 = vld1q_u64((const uint64_t *)(data +  48));
		msg4 = vld1q_u64((const uint64_t *)(data +  64));
		msg5 = vld1q_u64((const uint64_t *)(data +  80));
		msg6 = vld1q_u64((const uint64_t *)(data +  96));
		msg7 = vld1q_u64((const uint64_t *)(data + 112));

		/* Reverse for little endian */
		msg0 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg0)));
		msg1 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg1)));
		msg2 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg2)));
		msg3 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg3)));
		msg4 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg4)));
		msg5 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg5)));
		msg6 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg6)));
		msg7 = vreinterpretq_u64_u8(vrev64q_u8(vreinterpretq_u8_u64(msg7)));

		/* Rounds 0 and 1 */
		tmp0 = vaddq_u64(msg0, vld1q_u64(&k512[0]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs3);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs2, hs3, 1), vextq_u64(hs1, hs2, 1));
		hs3 = vsha512h2q_u64(tmp2, hs1, hs0);
		hs1 = vaddq_u64(hs1, tmp2);

		/* Rounds 2 and 3 */
		tmp0 = vaddq_u64(msg1, vld1q_u64(&k512[2]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs2);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs1, hs2, 1), vextq_u64(hs0, hs1, 1));
		hs2 = vsha512h2q_u64(tmp2, hs0, hs3);
		hs0 = vaddq_u64(hs0, tmp2);

		/* Rounds 4 and 5 */
		tmp0 = vaddq_u64(msg2, vld1q_u64(&k512[4]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs1);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs0, hs1, 1), vextq_u64(hs3, hs0, 1));
		hs1 = vsha512h2q_u64(tmp2, hs3, hs2);
		hs3 = vaddq_u64(hs3, tmp2);

		/* Rounds 6 and 7 */
		tmp0 = vaddq_u64(msg3, vld1q_u64(&k512[6]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs0);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs3, hs0, 1), vextq_u64(hs2, hs3, 1));
		hs0 = vsha512h2q_u64(tmp2, hs2, hs1);
		hs2 = vaddq_u64(hs2, tmp2);

		/* Rounds 8 and 9 */
		tmp0 = vaddq_u64(msg4, vld1q_u64(&k512[8]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs3);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs2, hs3, 1), vextq_u64(hs1, hs2, 1));
		hs3 = vsha512h2q_u64(tmp2, hs1, hs0);
		hs1 = vaddq_u64(hs1, tmp2);

		/* Rounds 10 and 11 */
		tmp0 = vaddq_u64(msg5, vld1q_u64(&k512[10]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs2);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs1, hs2, 1), vextq_u64(hs0, hs1, 1));
		hs2 = vsha512h2q_u64(tmp2, hs0, hs3);
		hs0 = vaddq_u64(hs0, tmp2);

		/* Rounds 12 and 13 */
		tmp0 = vaddq_u64(msg6, vld1q_u64(&k512[12]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs1);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs0, hs1, 1), vextq_u64(hs3, hs0, 1));
		hs1 = vsha512h2q_u64(tmp2, hs3, hs2);
		hs3 = vaddq_u64(hs3, tmp2);

		/* Rounds 14 and 15 */
		tmp0 = vaddq_u64(msg7, vld1q_u64(&k512[14]));
		tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs0);
		tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs3, hs0, 1), vextq_u64(hs2, hs3, 1));
		hs0 = vsha512h2q_u64(tmp2, hs2, hs1);
		hs2 = vaddq_u64(hs2, tmp2);

		for (unsigned int t = 16; t < 80; t += 16) {
			/* Rounds t and t + 1 */
			msg0 = vsha512su1q_u64(vsha512su0q_u64(msg0, msg1), msg7, vextq_u64(msg4, msg5, 1));
			tmp0 = vaddq_u64(msg0, vld1q_u64(&k512[t]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs3);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs2, hs3, 1), vextq_u64(hs1, hs2, 1));
			hs3 = vsha512h2q_u64(tmp2, hs1, hs0);
			hs1 = vaddq_u64(hs1, tmp2);

			/* Rounds t + 2 and t + 3 */
			msg1 = vsha512su1q_u64(vsha512su0q_u64(msg1, msg2), msg0, vextq_u64(msg5, msg6, 1));
			tmp0 = vaddq_u64(msg1, vld1q_u64(&k512[t + 2]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs2);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs1, hs2, 1), vextq_u64(hs0, hs1, 1));
			hs2 = vsha512h2q_u64(tmp2, hs0, hs3);
			hs0 = vaddq_u64(hs0, tmp2);

			/* Rounds t + 4 and t + 5 */
			msg2 = vsha512su1q_u64(vsha512su0q_u64(msg2, msg3), msg1, vextq_u64(msg6, msg7, 1));
			tmp0 = vaddq_u64(msg2, vld1q_u64(&k512[t + 4]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs1);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs0, hs1, 1), vextq_u64(hs3, hs0, 1));
			hs1 = vsha512h2q_u64(tmp2, hs3, hs2);
			hs3 = vaddq_u64(hs3, tmp2);

			/* Rounds t + 6 and t + 7 */
			msg3 = vsha512su1q_u64(vsha512su0q_u64(msg3, msg4), msg2, vextq_u64(msg7, msg0, 1));
			tmp0 = vaddq_u64(msg3, vld1q_u64(&k512[t + 6]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs0);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs3, hs0, 1), vextq_u64(hs2, hs3, 1));
			hs0 = vsha512h2q_u64(tmp2, hs2, hs1);
			hs2 = vaddq_u64(hs2, tmp2);

			/* Rounds t + 8 and t + 9 */
			msg4 = vsha512su1q_u64(vsha512su0q_u64(msg4, msg5), msg3, vextq_u64(msg0, msg1, 1));
			tmp0 = vaddq_u64(msg4, vld1q_u64(&k512[t + 8]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs3);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs2, hs3, 1), vextq_u64(hs1, hs2, 1));
			hs3 = vsha512h2q_u64(tmp2, hs1, hs0);
			hs1 = vaddq_u64(hs1, tmp2);

			/* Rounds t + 10 and t + 11 */
			msg5 = vsha512su1q_u64(vsha512su0q_u64(msg5, msg6), msg4, vextq_u64(msg1, msg2, 1));
			tmp0 = vaddq_u64(msg5, vld1q_u64(&k512[t + 10]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs2);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs1, hs2, 1), vextq_u64(hs0, hs1, 1));
			hs2 = vsha512h2q_u64(tmp2, hs0, hs3);
			hs0 = vaddq_u64(hs0, tmp2);

			/* Rounds t + 12 and t + 13 */
			msg6 = vsha512su1q_u64(vsha512su0q_u64(msg6, msg7), msg5, vextq_u64(msg2, msg3, 1));
			tmp0 = vaddq_u64(msg6, vld1q_u64(&k512[t + 12]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs1);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs0, hs1, 1), vextq_u64(hs3, hs0, 1));
			hs1 = vsha512h2q_u64(tmp2, hs3, hs2);
			hs3 = vaddq_u64(hs3, tmp2);

			/* Rounds t + 14 and t + 15 */
			msg7 = vsha512su1q_u64(vsha512su0q_u64(msg7, msg0), msg6, vextq_u64(msg3, msg4, 1));
			tmp0 = vaddq_u64(msg7, vld1q_u64(&k512[t + 14]));
			tmp1 = vaddq_u64(vextq_u64(tmp0, tmp0, 1), hs0);
			tmp2 = vsha512hq_u64(tmp1, vextq_u64(hs3, hs0, 1), vextq_u64(hs2, hs3, 1));
			hs0 = vsha512h2q_u64(tmp2, hs2, hs1);
			hs2 = vaddq_u64(hs2, tmp2);
		}

		/* Combine state */
		hc0 = vaddq_u64(hs0, hc0);
		hc1 = vaddq_u64(hs1, hc1);
		hc2 = vaddq_u64(hs2, hc2);
		hc3 = vaddq_u64(hs3, hc3);

		data += 128;
		num -= 1;
	}

	/* Save state */
	vst1q_u64(&state[0], hc0);
	vst1q_u64(&state[2], hc1);
	vst1q_u64(&state[4], hc2);
	vst1q_u64(&state[6], hc3);
}
