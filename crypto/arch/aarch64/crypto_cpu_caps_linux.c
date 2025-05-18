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

#include <sys/auxv.h>

/* from arch/arm64/include/uapi/asm/hwcap.h */
#define HWCAP_AES       (1 << 3)
#define HWCAP_PMULL     (1 << 4)
#define HWCAP_SHA1      (1 << 5)
#define HWCAP_SHA2      (1 << 6)
#define HWCAP_CRC32     (1 << 7)
#define HWCAP_SHA3      (1 << 17)
#define HWCAP_SHA512    (1 << 21)

#include "crypto_arch.h"

/* Machine dependent CPU capabilities. */
uint64_t crypto_cpu_caps_aarch64;

static uint64_t
check_cpu_cap(unsigned long hwcap, uint64_t cap_flag)
{
	return (getauxval(AT_HWCAP) & hwcap) ? cap_flag : 0;
}

void
crypto_cpu_caps_init(void)
{
	crypto_cpu_caps_aarch64 = 0;

	crypto_cpu_caps_aarch64 |= check_cpu_cap(HWCAP_AES,
		CRYPTO_CPU_CAPS_AARCH64_AES);

	crypto_cpu_caps_aarch64 |= check_cpu_cap(HWCAP_PMULL,
		CRYPTO_CPU_CAPS_AARCH64_PMULL);

	crypto_cpu_caps_aarch64 |= check_cpu_cap(HWCAP_SHA1,
		CRYPTO_CPU_CAPS_AARCH64_SHA1);

	crypto_cpu_caps_aarch64 |= check_cpu_cap(HWCAP_SHA2,
		CRYPTO_CPU_CAPS_AARCH64_SHA2);

	crypto_cpu_caps_aarch64 |= check_cpu_cap(HWCAP_SHA512,
		CRYPTO_CPU_CAPS_AARCH64_SHA512);

	crypto_cpu_caps_aarch64 |= check_cpu_cap(HWCAP_SHA3,
		CRYPTO_CPU_CAPS_AARCH64_SHA3);
}
