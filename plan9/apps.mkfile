DIRS=\
	#ocspcheck\
	#nc\
	openssl\

default:V: all

all clean nuke install:V: $DIRS
	for(i in $DIRS) @{
		cd $i
		mk $target
	}
