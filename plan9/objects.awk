#!/bin/awk -f
# usage: objects.awk input number output

BEGIN {
	cmd = "uname"
	if((cmd | getline osname) <= 0)
		die("cannot execute uname")
	close(cmd)
	if(osname == "Plan9")
		stderr = "/fd/2"
	else
		stderr = "/dev/stderr"

	# This script should read number file before input file.
	swap(ARGV, 1, 2)
	NUMBER_FILE = 1
	INPUT_FILE = 2

	output = ARGV[3]
	ARGV[3] = ""
}

FILENAME == ARGV[NUMBER_FILE] {
	sub(/#.*/, "")
	if($0 ~ /^[ \t]*$/)
		next
	if($2 in nidn)
		die(sprintf("There's already an object with NID %d on %s:%d\n", $2, FILENAME, order[$2]))
	if($1 in nid)
		die(sprintf("There's already an object with name %s on %s:%d\n", $1, FILENAME, order[nid[$1]]))
	nid[$1] = $2
	nidn[$2] = $1
	order[$2] = FNR
	if($2 > max_nid)
		max_nid = $2
}

FILENAME == ARGV[INPUT_FILE] && $1 == "!module" {
	$1 = ""
	module = trim_left($0) "-"
	module = norm(module)
	next
}
FILENAME == ARGV[INPUT_FILE] && $0 == "!global" {
	module = ""
	next
}
FILENAME == ARGV[INPUT_FILE] && $1 == "!Cname" {
	$1 = ""
	cname = trim_left($0)
	next
}
FILENAME == ARGV[INPUT_FILE] && $1 == "!Alias" {
	cname = module $2
	$1 = $2 = ""
	myoid = process_oid(trim_left($0))
	gsub(/-/, "_", cname)
	ordern[FNR] = cname
	order[cname] = FNR
	obj[cname] = myoid
	cname = ""
	next
}
FILENAME == ARGV[INPUT_FILE] {
	sub(/[!#].*$/, "")
	if($0 ~ /^[ \t]*$/)
		next
	n = split($0, a, ":")
	myoid = trim(a[1])
	mysn = trim(a[2])
	myln = trim(a[3])
	if(myoid != "")
		myoid = process_oid(myoid)
	if(cname == "" && index(myln, " ") == 0){
		cname = norm(myln)
		fn = module cname
		if(cname != "" && fn in ln)
			die(sprintf("There's already an object with long name %s on %s:%d\n", ln[fn], FILENAME, order[fn]))
	}
	if(cname == ""){
		cname = mysn
		gsub(/-/, "_", cname)
		fn = module cname
		if(cname != "" && fn in sn)
			die(sprintf("There's already an object with short name %s on %s:%d\n", sn[fn], FILENAME, order[fn]))
	}
	if(cname == ""){
		cname = norm(myln)
		gsub(/ /, "_", cname)
		if(cname != "" && fn in ln)
			die(sprintf("There's already an object with long name %s on %s:%d\n", ln[fn], FILENAME, order[fn]))
	}
	cname = module norm(cname)
	ordern[FNR] = cname
	order[cname] = FNR
	sn[cname] = mysn
	ln[cname] = myln
	obj[cname] = myoid
	if(!(cname in nid)){
		max_nid++
		nid[cname] = max_nid
		nidn[max_nid] = cname
		printf "Added OID %s\n", cname >>stderr
	}
	cname = ""
}

END {
	print "/* crypto/objects/obj_mac.h */" >output
	print "" >>output
	copyright(output)
	print "" >>output
	print "#define SN_undef\t\t\"UNDEF\"" >>output
	print "#define LN_undef\t\t\"undefined\"" >>output
	print "#define NID_undef\t\t0" >>output
	print "#define OBJ_undef\t\t0L" >>output
	print "" >>output

	n = getoffsets(ordern, offs)
	qsort(offs, 1, n)
	for(i = 1; i <= n; i++){
		cname = ordern[offs[i]]
		if(sn[cname])
			printf "#define SN_%s\t\t\"%s\"\n", cname, sn[cname] >>output
		if(ln[cname])
			printf "#define LN_%s\t\t\"%s\"\n", cname, ln[cname] >>output
		if(nid[cname])
			printf "#define NID_%s\t\t%s\n", cname, nid[cname] >>output
		if(obj[cname])
			printf "#define OBJ_%s\t\t%s\n", cname, obj[cname] >>output
		print "" >>output
	}
	close(output)
}

function getoffsets(a, dest,		n,i) {
	for(i in a)
		dest[++n] = i+0
	return n
}
function process_oid(oid,	a,n,pref_oid,pref_sep,s,i) {
	n = split(oid, a)
	i = 1
	if(a[1] !~ /^[0-9]+$/){
		gsub(/-/, "_", a[1])
		if(!(a[1] in obj))
			die(sprintf("Undefined identifier %s\n", a[1]))
		pref_oid = "OBJ_" a[1]
		pref_sep = ","
		i = 2
	}
	s = join(a, i, n, "L,") "L"
	if(s == "L")
		return pref_oid
	return pref_oid pref_sep s
}
function join(a, i, n, sep,		s) {
	for( ; i <= n; i++){
		if(s != "")
			s = s sep
		s = s a[i]
	}
	return s
}
function norm(s) {
	gsub(/[.-]/, "_", s)
	return s
}
function trim_left(s) {
	sub(/^[ \t]+/, "", s)
	return s
}
function trim(s) {
	s = trim_left(s)
	sub(/[ \t]+$/, "", s)
	return s
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
function die(s) {
	printf "%s:%d %s", FILENAME, FNR, s >>stderr
	exit(1)
}

function copyright(file) {
	print "/* THIS FILE IS GENERATED FROM objects.h by obj_dat.pl via the" >>file
	print " * following command:" >>file
	print " * perl obj_dat.pl obj_mac.h obj_dat.h" >>file
	print " */" >>file
	print "" >>file
	print "/* Copyright (C) 1995-1997 Eric Young (eay@cryptsoft.com)" >>file
	print " * All rights reserved." >>file
	print " *" >>file
	print " * This package is an SSL implementation written" >>file
	print " * by Eric Young (eay@cryptsoft.com)." >>file
	print " * The implementation was written so as to conform with Netscapes SSL." >>file
	print " * " >>file
	print " * This library is free for commercial and non-commercial use as long as" >>file
	print " * the following conditions are aheared to.  The following conditions" >>file
	print " * apply to all code found in this distribution, be it the RC4, RSA," >>file
	print " * lhash, DES, etc., code; not just the SSL code.  The SSL documentation" >>file
	print " * included with this distribution is covered by the same copyright terms" >>file
	print " * except that the holder is Tim Hudson (tjh@cryptsoft.com)." >>file
	print " * " >>file
	print " * Copyright remains Eric Young's, and as such any Copyright notices in" >>file
	print " * the code are not to be removed." >>file
	print " * If this package is used in a product, Eric Young should be given attribution" >>file
	print " * as the author of the parts of the library used." >>file
	print " * This can be in the form of a textual message at program startup or" >>file
	print " * in documentation (online or textual) provided with the package." >>file
	print " * " >>file
	print " * Redistribution and use in source and binary forms, with or without" >>file
	print " * modification, are permitted provided that the following conditions" >>file
	print " * are met:" >>file
	print " * 1. Redistributions of source code must retain the copyright" >>file
	print " *    notice, this list of conditions and the following disclaimer." >>file
	print " * 2. Redistributions in binary form must reproduce the above copyright" >>file
	print " *    notice, this list of conditions and the following disclaimer in the" >>file
	print " *    documentation and/or other materials provided with the distribution." >>file
	print " * 3. All advertising materials mentioning features or use of this software" >>file
	print " *    must display the following acknowledgement:" >>file
	print " *    \"This product includes cryptographic software written by" >>file
	print " *     Eric Young (eay@cryptsoft.com)\"" >>file
	print " *    The word 'cryptographic' can be left out if the rouines from the library" >>file
	print " *    being used are not cryptographic related :-)." >>file
	print " * 4. If you include any Windows specific code (or a derivative thereof) from " >>file
	print " *    the apps directory (application code) you must include an acknowledgement:" >>file
	print " *    \"This product includes software written by Tim Hudson (tjh@cryptsoft.com)\"" >>file
	print " * " >>file
	print " * THIS SOFTWARE IS PROVIDED BY ERIC YOUNG ``AS IS'' AND" >>file
	print " * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE" >>file
	print " * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE" >>file
	print " * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE" >>file
	print " * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL" >>file
	print " * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS" >>file
	print " * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)" >>file
	print " * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT" >>file
	print " * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY" >>file
	print " * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF" >>file
	print " * SUCH DAMAGE." >>file
	print " * " >>file
	print " * The licence and distribution terms for any publically available version or" >>file
	print " * derivative of this code cannot be changed.  i.e. this code cannot simply be" >>file
	print " * copied and put under another distribution licence" >>file
	print " * [including the GNU Public Licence.]" >>file
	print " */" >>file
}
