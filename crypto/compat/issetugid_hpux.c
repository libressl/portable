#include <stdio.h>
#include <unistd.h>
#include <sys/pstat.h>

/*
 * HP-UX does not have issetugid().
 * Use pstat_getproc() and check PS_CHANGEDPRIV bit of pst_flag. If this call
 * cannot be used, assume we must be running in a privileged environment.
 */
int issetugid(void)
{
	struct pst_status buf;
	if (pstat_getproc(&buf, sizeof(buf), 0, getpid()) == 1 &&
	    !(buf.pst_flag & PS_CHANGEDPRIV))
		return 0;
	return 1;
}
