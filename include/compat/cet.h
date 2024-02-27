/*
 * Public domain
 * cet.h compatibility shim
 */

#ifndef LIBCOMPAT_CET_H
#define LIBCOMPAT_CET_H

#ifndef _MSC_VER

#ifdef __CET__
#   include_next <cet.h>
#else
#   define _CET_ENDBR
#endif

#endif

#endif
