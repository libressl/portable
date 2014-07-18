#ifdef __linux__
#include "arc4random_linux.h"
#endif

#ifdef __APPLE__
#include "arc4random_osx.h"
#endif

#ifdef __sun
#include "arc4random_solaris.h"
#endif

#ifdef __WIN32
#include "arc4random_win.h"
#endif

