srcdir=.

DIRS=\
	crypto\
	ssl\
	tls\
	include\
	apps\

default:V: all

all clean nuke install:V:
	for(i in $DIRS) @{
		cd $i
		mk $target
	}
