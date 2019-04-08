srcdir=.

DIRS=\
	crypto\
	ssl\
	tls\
	include\
	apps\

all clean nuke install:V:
	for(i in $DIRS) @{
		cd $i
		mk $target
	}
