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

#include <sys/sysctl.h>

#include "crypto_arch.h"

/* Machine dependent CPU capabilities. */
uint64_t crypto_cpu_caps_aarch64;

static uint64_t
check_cpu_cap(const char *cap_name, uint64_t cap_flag)
{
	int has_cap = 0;
	size_t len = sizeof(has_cap);

	sysctlbyname(cap_name, &has_cap, &len, NULL, 0);

	return has_cap ? cap_flag : 0;
}

void
crypto_cpu_caps_init(void)
{
	crypto_cpu_caps_aarch64 = 0;

	/* from https://developer.apple.com/documentation/kernel/1387446-sysctlbyname/determining_instruction_set_characteristics#3918855 */

	crypto_cpu_caps_aarch64 |= check_cpu_cap("hw.optional.arm.FEAT_AES",
		CRYPTO_CPU_CAPS_AARCH64_AES);

	crypto_cpu_caps_aarch64 |= check_cpu_cap("hw.optional.arm.FEAT_PMULL",
		CRYPTO_CPU_CAPS_AARCH64_PMULL);

	crypto_cpu_caps_aarch64 |= check_cpu_cap("hw.optional.arm.FEAT_SHA1",
		CRYPTO_CPU_CAPS_AARCH64_SHA1);

	crypto_cpu_caps_aarch64 |= check_cpu_cap("hw.optional.arm.FEAT_SHA256",
		CRYPTO_CPU_CAPS_AARCH64_SHA2);

	crypto_cpu_caps_aarch64 |= check_cpu_cap("hw.optional.arm.FEAT_SHA512",
		CRYPTO_CPU_CAPS_AARCH64_SHA512);

	crypto_cpu_caps_aarch64 |= check_cpu_cap("hw.optional.arm.FEAT_SHA3",
		CRYPTO_CPU_CAPS_AARCH64_SHA3);
}
