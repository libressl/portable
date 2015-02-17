/*
 * issetugid implementation for OS X
 * Public domain
 */

#include <unistd.h>

/*
 * OS X has issetugid, but it is not fork-safe as of version 10.10.
 * See this Solaris report for test code that fails similarly:
 * http://mcarpenter.org/blog/2013/01/15/solaris-issetugid%282%29-bug
 */
int issetugid(void)
{
	return 1;
}
