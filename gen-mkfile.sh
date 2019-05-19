#!/bin/sh
# usage: gen-mkfiles.sh {lib|bin|include} Makefile.am
set -e

if [ $# -ne 3 -a $# -ne 2 ]; then
	echo "usage: $0 {lib|bin|include} Makefile.am" >&2
	exit 2
fi

# Plan 9 don't have dirname(1), instead use basename -d
if ! type dirname >/dev/null 2>&1
then
	dirname() { basename -d "$@"; }
fi

target=$1
wdir=`dirname $2`
recipe=`basename $2`

cd $wdir
d=`git rev-parse --show-cdup`.
top_srcdir=`echo $d | sed 's!/\.$!!'`
prog="$top_srcdir/`basename $0`"

# Plan 9 isn't having /dev/stderr, instead it has /fd/2.
stderr=/dev/stderr
if [ -w /fd/2 ]; then
	stderr=/fd/2
fi

# filename: current filename
# lineno: current line number of filename
# vars: variables defined in Makefile.am
# defs: variables defined in plan9/defs; these will appear in -D flag too
# config: variable defined in plan9/config
# ifblock: booleans of nested if-statement; will reverse an value when enter to else
# ifpos: index of last ifblock
awk <$recipe '
BEGIN {
	prog = "'"$prog"'"
	stderr = "'"$stderr"'"
	target = "'"$target"'"
	vars["top_srcdir"] = "'"$top_srcdir"'"
	vars["includedir"] = "/sys/include"
	loaddefs(getvar("top_srcdir") "/plan9/defs")
	loadconfig(getvar("top_srcdir") "/plan9/config")
}

function topdir() {
	return getvar("top_srcdir")
}

function loaddefs(file) {
	while((getline s <file) > 0)
		defs[s] = 1
	close(file)
}

function loadconfig(file,	s,a,n) {
	while((getline s <file) > 0){
		n = split(s, a, "=")
		config[a[1]] = join(a, 2, n)
	}
	close(file)
}

function fatal(msg) {
	printf "%s:%d %s\n", filename, lineno, msg >stderr
	exit(1)
}
function assign(name, op, value) {
	if(op != "=" && op != "+=")
		fatal(sprintf("unknown operator: %s %s %s", name, op, value))
	if(op == "=")
		delete vars[name]
	if(value == "")
		return

	if(vars[name] == "")
		vars[name] = value
	else
		vars[name] = vars[name] SUBSEP value
}
function expand(s,	v) {
	while(match(s, /\$\([a-zA-Z0-9_]+\)/)){
		v = substr(s, RSTART+2, RLENGTH-3)
		s = substr(s, 1, RSTART-1) vars[v] substr(s, RSTART+RLENGTH)
	}
	while(match(s, /@[a-zA-Z0-9_]+@/)){
		v = substr(s, RSTART+1, RLENGTH-2)
		s = substr(s, 1, RSTART-1) config[v] substr(s, RSTART+RLENGTH)
	}
	# In Plan 9 shell rc, double-quote do not have special meaning.
	gsub(/\\"/, "\"", s)
	return s
}
function getvar(name) {
	return expand(vars[name])
}
function getarray(name, a,		n,i,u) {
	n = split(getvar(name), a, SUBSEP)
	for(i = 1; i <= n; i++)
		if(a[i] != "")
			a[++u] = a[i]
	return u
}
function iftrue(	i,r) {
	r = 1
	for(i = 1; i <= ifpos; i++)
		r = r && ifblock[i]
	return r
}
function eval(tokens, n,	v,i) {
	if(n == 2 && tokens[1] == "if"){
		ifpos++
		v = tokens[2]
		if(v ~ /^!/){
			v = substr(v, 2)
			ifblock[ifpos] = !(v in defs)
		}else
			ifblock[ifpos] = v in defs
	}else if(n == 1 && tokens[1] == "else"){
		ifblock[ifpos] = !ifblock[ifpos]
	}else if(n == 1 && tokens[1] == "endif"){
		ifpos--
	}
	if(!iftrue())
		return

	if(n >= 2 && tokens[2] == "=" || tokens[2] == "+="){
		for(i = 3; i <= n; i++)
			assign(tokens[1], tokens[2], tokens[i])
		return
	}
	if(n == 2 && tokens[1] == "include")
		evalfile(expand(tokens[2]))
}

# evalfile cannot handle nested include directive referenced with relative path.
function evalfile(file,		s,a,i,n) {
	while((getline s <file) > 0){
		n = split(s, a)
		filename = file
		lineno = ++i
		eval(a, n)
	}
	close(file)
}
{	for(i = 1; i <= NF; i++)
		a[i] = $i
	filename = FILENAME
	lineno = FNR
	eval(a, NF)
	next
}

function aname(file,	n,a) {
	n = split(file, a, "/")
	sub(/\.la$/, ".a", a[n])
	return a[n]
}
function varname(file, name) {
	gsub(/\./, "_", file)
	return file "_" name
}
function getarrayof(file, name, a,		v) {
	v = varname(file, name)
	return getarray(v, a)
}
function merge(a, a1, n1, a2, n2,	x,n,i) {
	for(i = 1; i <= n1; i++)
		x[a1[i]] = 1
	for(i = 1; i <= n2; i++)
		x[a2[i]] = 1
	for(i in x)
		a[++n] = i
	return n
}
function append(a, n, name,		a1,n1) {
	n1 = getarray(name, a1)
	return merge(a, a, n, a1, n1)
}
function join(a, bp, ep,	i,s) {
	for(i = bp; i <= ep; i++){
		if(s != "")
			s = s " "
		s = s a[i]
	}
	return s
}
function dirname(path,		a,n) {
	n = split(path, a, "/")
	return join(a, 1, n-1)
}
function dirnames(a, n, r,		i,x,s) {
	for(i = 1; i <= n; i++){
		s = dirname(a[i])
		x[s] = 1
	}
	n = 0
	for(s in x)
		r[++n] = s
	return n
}
function filter(a, n, path, r,		i,u,s) {
	gsub(/\/+$/, "", path)
	for(i = 1; i <= n; i++){
		s = dirname(a[i])
		if(s != path)
			continue
		if(path == "")
			r[++u] = a[i]
		else
			r[++u] = substr(a[i], length(s)+2)
	}
	return u
}
function objfile(s) {
	sub(/\.c$/, ".$O", s)
	return s
}

function collect(m, name, a,	n,i,l,x) {
	n = getarrayof(m, name, a)
	l = getarrayof(m, "LIBADD", x)
	for(i = 1; i <= l; i++)
		n = append(a, n, varname(x[i], name))
	return n
}

# staticlibs is called if target is "bin" only.
function staticlibs(a,		m,x,n,i,v,u,c) {
	m = getvar("bin_PROGRAMS")
	n = getarrayof(m, "LDADD", x)
	for(i = 1; i <= n; i++){
		u = getarrayof(x[i], "SOURCES", v)
		if(u == 0)
			a[++c] = x[i]
	}
	return c
}

# isbranch: this target, wfile, has one or many sub directories.
END {
	if(target == "include"){
		# TODO(lufia): This is hack; this might be fixed.
		dir = "/sys/include/ape"
		n = getarray("include_HEADERS", a)
		if(n == 0){
			dir = "/sys/include/ape/openssl"
			n = getarray("opensslinclude_HEADERS", a)
		}
		wfile = "mkfile"
		ndir = dirnames(a, n, dirs)
		ndir = append(dirs, ndir, "SUBDIRS")
		qsort(dirs, 1, ndir)
		isbranch = (ndir > 1 || (ndir == 1 && dirs[1] != ""))

		print "HFILES=\\" >wfile
		for(i = 1; i <= n; i++)
			printf "\t%s\\\n", a[i] >>wfile
		print "" >>wfile
		if(isbranch){
			print "DIRS=\\" >>wfile
			for(i = 1; i <= ndir; i++){
				if(dirs[i] == "")
					continue
				printf "\t%s\\\n", dirs[i] >>wfile
			}
			print "" >>wfile
		}
		printf "DIR=%s\n", dir >>wfile
		print "" >>wfile
		print "TARG=${HFILES:%.h=$DIR/%.h}" >>wfile
		print "" >>wfile
		print "all:V: $HFILES" >>wfile
		print "" >>wfile
		if(isbranch)
			print "install:V: $TARG dir-install" >>wfile
		else
			print "install:V: $TARG" >>wfile
		print "" >>wfile
		print "$DIR/%.h: %.h" >>wfile
		print "\tcp $prereq $target" >>wfile
		if(isbranch){
			print "" >>wfile
			printf "<%s/plan9/mkdirs\n", topdir() >>wfile
		}
		close(wfile)
		walksubdirs()
		exit(0)
	}
	if(target == "lib")
		key = "lib_LTLIBRARIES"
	else if(target == "bin")
		key = "bin_PROGRAMS"
	else
		fatal(sprintf("invalid target: %s", target))
	m = getvar(key)
	nc = collect(m, "SOURCES", cfiles)
	nh = getarray("noinst_HEADERS", hfiles)
	ndir = dirnames(cfiles, nc, dirs)
	qsort(dirs, 1, ndir)
	root = topdir()
	for(i = 1; i <= ndir; i++){
		wfile = combine(dirs[i], "mkfile")
		s = relative(dirs[i])
		vars["top_srcdir"] = combine(s, root)
		mkfilehdr(m, wfile)

		n = filter(cfiles, nc, dirs[i], a)
		qsort(a, 1, n)
		print "OFILES=\\" >>wfile
		for(j = 1; j <= n; j++)
			printf "\t%s\\\n", objfile(a[j]) >>wfile
		print "" >>wfile
		n = filter(hfiles, nh, dirs[i], a)
		if(n > 0){
			qsort(a, 1, n)
			print "HFILES=\\" >>wfile
			for(j = 1; j <= n; j++)
				printf "\t%s\\\n", a[j] >>wfile
			print "" >>wfile
		}
		isbranch = (dirs[i] == "")
		if(isbranch && ndir > 1){
			print "" >>wfile
			print "DIRS=\\" >>wfile
			for(j = 1; j <= ndir; j++){
				if(j == i) # dirs[j] == ""
					continue
				printf "\t%s\\\n", dirs[j] >>wfile
			}
			print "" >>wfile
		}

		if(target == "lib"){
			printf "LIB=/$objtype/lib/ape/%s\n", aname(m) >>wfile
			print "" >>wfile
			if(isbranch && ndir > 1){
				print "lib:V: all $DIRS" >>wfile
				print "" >>wfile
				printf "<%s/plan9/mklibdirs\n", topdir() >>wfile
			}else
				print "</sys/src/cmd/mklib" >>wfile
		}else if(target == "bin" && !isbranch){
			printf "LIB=lib.a$O\n" >>wfile
			print "" >>wfile
			print "</sys/src/cmd/mklib" >>wfile
		}else if(target == "bin"){
			n = staticlibs(a)
			if(n > 0){
				print "LIB=\\" >>wfile
				for(j = 1; j <= ndir; j++){
					if(dirs[j] == "")
						continue
					printf "\t%s/lib.a$O\\\n", dirs[j] >>wfile
				}
				for(j = 1; j <= n; j++)
					printf "\t/$objtype/lib/ape/%s\\\n", aname(a[j]) >>wfile
				print "" >>wfile
			}
			print "CLEANFILES=`{ls */*.$O */*.a$O}" >>wfile
			print "BIN=/$objtype/bin" >>wfile
			print "TARG=" m >>wfile
			print "" >>wfile
			print "</sys/src/cmd/mkone" >>wfile
			print "" >>wfile
			print "([^/]*)/(.*)\.a$O:R:" >>wfile
			print "\tcd $stem1" >>wfile
			print "\tmk $MKFLAGS all" >>wfile
		}
		close(wfile)
	}
	vars["top_srcdir"] = root
	walksubdirs()
}

function walksubdirs(		n,a) {
	n = getarray("SUBDIRS", a)
	for(i = 1; i <= n; i++)
		system(sprintf("%s %s %s/Makefile.am\n", prog, target, a[i]))
}

# vars["top_srcdir"] should set to a directory of wfile before call mkfilehdr.
function mkfilehdr(m, wfile,		a,n,i,name) {
	print "</sys/src/ape/config" >wfile
	printf "ROOT=%s\n", topdir() >>wfile
	print "" >>wfile
	# -T flag is dropped; will cause incompatible type signatures error.
	# -w flag is dropped; is very chatty.
	# -B flag is needed because apps/openssl still have K&R style prototype.
	print "CFLAGS=-FV -B -c\\" >>wfile
	printf "\t-I%s/include\\\n", topdir() >>wfile
	printf "\t-I%s/include/compat\\\n", topdir() >>wfile
	for(name in defs)
		a[++n] = "-D" name
	n = append(a, n, "AM_CFLAGS")
	n = append(a, n, "AM_CPPFLAGS")
	n = append(a, n, varname(m, "CPPFLAGS"))
	qsort(a, 1, n)
	for(i = 1; i <= n; i++)
		printf "\t%s\\\n", a[i] >>wfile
	print "" >>wfile
}
function relative(path) {
	gsub(/[^\/]+/, "..", path)
	return path
}
function combine(p, q) {
	if(p == "" || p == ".")
		return q
	return sprintf("%s/%s", p, q)
}
function swap(a, i, j,		v) {
	v = a[i]
	a[i] = a[j]
	a[j] = v
}
function qsort(a, l, r,		last,i) {
	if(l >= r)
		return
	swap(a, l, int((l+r)/2))
	last = l
	for(i = l+1; i <= r; i++)
		if(a[i] < a[l])
			swap(a, ++last, i)
	swap(a, l, last)
	qsort(a, l, last-1)
	qsort(a, last+1, r)
}
'
