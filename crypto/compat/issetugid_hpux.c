#include <stdio.h>
#include <unistd.h>
#include <sys/pstat.h>

/*
 * HP-UX does not have issetugid().
 * This experimental implementation uses pstat_getproc() and get*id().
 * First, try pstat_getproc() and check PS_CHANGEDPRIV bit of pst_flag. 
 * In case unsuccessful calling pstat_getproc(), using get*id().
 *
 */
int issetugid(void)
{
	struct pst_status buf;
	if(pstat_getproc(&buf, sizeof(buf), 0, getpid()) != 1) {
	    perror("pstat_getproc()");
	} else {
	    if(buf.pst_flag & PS_CHANGEDPRIV)
		return 1;
	}
	if(getuid() != geteuid())
	    return 1;
	if(getgid() != getegid())
	    return 1;
	return 0;
}
