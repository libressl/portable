/*
 * issetugid implementation for Windows
 * Public domain
 */

#include <unistd.h>

/*
 * Windows does not have a native setuid/setgid functionality.
 * A user must enter credentials each time a process elevates its
 * privileges.
 *
 * So, in theory, this could always return 0, given what I know currently.
 * However, it makes sense to stub out initially in 'safe' mode until we
 * understand more (and determine if any disabled functionality is actually
 * useful on Windows anyway).
 *
 * Future versions of this function that are made more 'open' should thoroughly
 * consider the case of this code running as a privileged service with saved
 * user credentials or privilege escalations by other means (e.g. the old
 * RunAsEx utility.)
 */
int issetugid(void)
{
	return 1;
}
