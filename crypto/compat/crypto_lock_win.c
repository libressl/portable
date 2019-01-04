/* $OpenBSD: crypto_lock.c,v 1.1 2018/11/11 06:41:28 bcook Exp $ */
/*
 * Copyright (c) 2019 Brent Cook <bcook@openbsd.org>
 * Copyright (c) 2019 John Norrbin <jlnorrbin@johnex.se>
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

#include <openssl/crypto.h>

static volatile LPCRITICAL_SECTION locks[CRYPTO_NUM_LOCKS] = { NULL };

void
CRYPTO_lock(int mode, int type, const char *file, int line)
{
	if (type < 0 || type >= CRYPTO_NUM_LOCKS)
		return;

	if (locks[type] == NULL) {
		LPCRITICAL_SECTION lcs = malloc(sizeof(CRITICAL_SECTION));
		if (lcs == NULL) exit(ENOMEM);
		InitializeCriticalSection(lcs);
		if (InterlockedCompareExchangePointer((PVOID*)&locks[type], (PVOID)lcs, NULL) != NULL) {
			DeleteCriticalSection(lcs);
			free(lcs);
		}
	}

	if (mode & CRYPTO_LOCK)
		EnterCriticalSection(locks[type]);
	else
		LeaveCriticalSection(locks[type]);
}

int
CRYPTO_add_lock(int *pointer, int amount, int type, const char *file,
    int line)
{
	/*
	 * Windows is LLP64. sizeof(LONG) == sizeof(int) on 32-bit and 64-bit.
	 */
	int ret = InterlockedExchangeAdd((LONG *)pointer, (LONG)amount);
	return ret + amount;
}
