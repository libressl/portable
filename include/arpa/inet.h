/*
 * Public domain
 * arpa/inet.h compatibility shim
 */

#ifndef _WIN32
#include_next <arpa/inet.h>
#else
#include <win32netcompat.h>
#endif
