#if defined(__linux__)
#include "arc4random_linux.h"

#elif defined(__APPLE__)
#include "arc4random_osx.h"

#elif defined(__sun)
#include "arc4random_solaris.h"

#elif defined(__WIN32)
#include "arc4random_win.h"

#else
#error "No arc4random hooks defined for this platform."

#endif

