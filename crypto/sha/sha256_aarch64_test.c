/* $OpenBSD: sha256_aarch64.c,v 1.1 2025/03/07 14:21:22 jsing Exp $ */
/*
 * Copyright (c) 2025 Joel Sing <jsing@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include <openssl/sha.h>

#include "crypto_arch.h"

void sha256_block_ce(SHA256_CTX *ctx, const void *in, size_t num);
void sha256_block_generic(SHA256_CTX *ctx, const void *in, size_t num);
void sha256_block_intrinsic(SHA256_CTX *ctx, const void *in, size_t num);

#include <stdlib.h>
#include <string.h>

static int mode = 0;
#define SHA_MODE_CE 1
#define SHA_MODE_GENERIC 2
#define SHA_MODE_INTRINSIC 3

void
sha256_block_data_order(SHA256_CTX *ctx, const void *in, size_t num)
{
	if (mode == 0) {
		const char *mode_str = getenv("SHA_MODE");
		if (mode_str) {
			if (strcmp(mode_str, "ce") == 0)
				mode = SHA_MODE_CE;
			else if (strcmp(mode_str, "generic") == 0)
				mode = SHA_MODE_GENERIC;
			else if (strcmp(mode_str, "intrinsic") == 0)
				mode = SHA_MODE_INTRINSIC;
			else
				mode = SHA_MODE_GENERIC;
		}
	}
	if ((crypto_cpu_caps_aarch64 & CRYPTO_CPU_CAPS_AARCH64_SHA2) != 0) {
		if (mode == SHA_MODE_CE)
			sha256_block_ce(ctx, in, num);
		else if (mode == SHA_MODE_INTRINSIC)
			sha256_block_intrinsic(ctx, in, num);
		else
			sha256_block_generic(ctx, in, num);
	} else {
		sha256_block_generic(ctx, in, num);
	}
}
