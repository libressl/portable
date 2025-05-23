/* $OpenBSD: crypto_cpu_caps.c,v 1.2 2024/11/12 13:52:31 jsing Exp $ */
/*
 * Copyright (c) 2025 Brent Cook <bcook@openbsd.org>
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

#include <windows.h>

#include "crypto_arch.h"

/* Machine dependent CPU capabilities. */
uint64_t crypto_cpu_caps_aarch64;

void
crypto_cpu_caps_init(void)
{
	crypto_cpu_caps_aarch64 = 0;

	if (IsProcessorFeaturePresent(PF_ARM_V8_CRYPTO_INSTRUCTIONS_AVAILABLE)) {
		crypto_cpu_caps_aarch64 |= CRYPTO_CPU_CAPS_AARCH64_AES;
		crypto_cpu_caps_aarch64 |= CRYPTO_CPU_CAPS_AARCH64_PMULL;
		crypto_cpu_caps_aarch64 |= CRYPTO_CPU_CAPS_AARCH64_SHA1;
		crypto_cpu_caps_aarch64 |= CRYPTO_CPU_CAPS_AARCH64_SHA2;
	}
}
