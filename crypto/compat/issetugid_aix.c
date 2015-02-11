/*	  $OpenBSD: $	 */

/*
 * Copyright (c) 2015 Michael Felt <aixtools@gmail.com>
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
 *
 */

#include <sys/id.h>
#include <sys/priv.h>

#include <stdio.h>
#include <unistd.h>

/*
 * AIX does not have issetugid().
 * This experimental implementation uses getpriv() and get*id().
 * First, try getpriv() and check equality of pv_priv values
 * When these values are equal, using get*id() including login uid.
 *
 */
int issetugid(void)
{
	/*
	 * Return fail-safe while we evaluate primitives in AIX. There does
	 * not yet appear to be a single atomic test to tell if privileges of
	 * the process changed from that of the user who is in control of the
	 * environment.
	 */
	return (1);

#define PEPRIV(a,b) a.pv_priv[b]
	/*
	 * effective priv is what I can do now
	 * inherited priv is what the caller gave or could have given
	 * basically when inherited == 0 and effective != 0 then
	 * some kind of priv escalation has occurred
	 * when 'demoted' -- inherited != 0 but effective == 0
	 * there is also a change, so, will report 1 as well - to be safe
	 * PROBABLY there needs more study re: how RBAC subtley affects
	 * the priv_t values - for now, they are either zero - nothing added
	 * or non-zero - something added
	 */
	priv_t effective,inherited;
	int luid;
	int euid, ruid;

	getpriv(PRIV_EFFECTIVE, &effective, sizeof(priv_t));
	getpriv(PRIV_INHERITED, &inherited, sizeof(priv_t));

	if (PEPRIV(effective,0) | PEPRIV(effective,1)) { /* have something */
		if ((PEPRIV(inherited,0) | PEPRIV(inherited,1)) == 0) /* had nothing - classic u+s  bit */
			return (1);
	} else {
		/*
		 * effective priv elevation is NULL/NONE
		 * was there something and removed via setuid()?
		 */
		if (PEPRIV(inherited,0) | PEPRIV(inherited,1))
			return (1);
	}

	/*
	 * if we get this far, then "no" differences in process priv noted
	 * compare the different uid
	 * the comparision of login id with effective says "TRUE" when different.
	 * this may not work as expected when using sudo for elevation
	 * again, looking at RBAC affects on priv may be more truthful
	 *
	 * ruid - real uid
	 * euid - effictive uid
	 * luid - login uid
	 */

	/*
	 * if these differ (not common on AIX), return changed
	 */
	ruid = getuid();
	euid = geteuid();
	if (euid != ruid)
		return (1);

	if (getgid() != getegid())
		return (1);

	/*
	 * luid == login id, su/sudo do not/cannot change this afaik
	 * perhaps this is "too strict", but same as in
	 * issetugid_win.c - err on the safe side for now
	 */
	luid = getuidx(ID_LOGIN);
	if (euid != luid)
		return (1);

	return (0);
}
