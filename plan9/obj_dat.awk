#!/bin/awk -f
# usage: obj_dat.awk input output

BEGIN {
	cmd = "uname"
	if((cmd | getline osname) <= 0)
		exit(1)
	close(cmd)
	if(osname == "Plan9")
		stderr = "/fd/2"
	else
		stderr = "/dev/stderr"

	output = ARGV[2]
	ARGV[2] = ""
}

$1 != "#define" {
	next
}
{	v = $2
	d = field_string(3)
	sub(/^"/, "", d)
	sub(/"$/, "", d)
}
v ~ /^SN_/ {
	if(d in snames){
		printf "WARNING: Duplicate short name \"%s\"\n", d >>stderr
		next
	}
	snames[d] = "X"
	sn[substr(v, 4)] = d
}
v ~ /^LN_/ {
	if(d in lnames){
		printf "WARNING: Duplicate long name \"%s\"\n", d >>stderr
		next
	}
	lnames[d] = "X"
	ln[substr(v, 4)] = d
}
v ~ /^NID_/ {
	nid[d] = substr(v, 5)
}
v ~ /^OBJ_/ {
	obj[substr(v, 5)] = v
	objd[v] = d
}

END {
	expand_obj(objd, ob)
	noff = getoffsets(nid, offs)
	qsort(offs, 1, noff)
	n = offs[noff]
	for(i = 0; i <= n; i++){
		if(!(i in nid)){
			out[++nout] = "{NULL,NULL,NID_undef,0,NULL,0},\n"
			continue
		}
		mysn = "NULL"
		if(nid[i] in sn)
			mysn = sn[nid[i]]
		myln = "NULL"
		if(nid[i] in ln)
			myln = ln[nid[i]]
		if(mysn == "NULL"){
			mysn = myln
			sn[nid[i]] = myln
		}
		if(myln == "NULL"){
			myln = mysn
			ln[nid[i]] = mysn
		}

		s = sprintf("{\"%s\",\"%s\",NID_%s,", mysn, myln, nid[i])
		if(nid[i] in obj && index(objd[obj[nid[i]]], ",") > 0){
			p = obj[nid[i]]
			v = objd[p]
			gsub(/L/, "", v)
			gsub(/,/, " ", v)
			len = der_it(v, bytes)
			z = ""
			for(j = 1; j <= len; j++)
				z = sprintf("%s0x%02X,", z, bytes[j])
			obj_der[p] = z
			obj_len[p] = len

			lvalues[++nlvalue] = sprintf("%-45s/* [%3d] %s */\n", z, lsz, p)
			s = sprintf("%s%d,&(lvalues[%d]),0", s, len, lsz)
			lsz += len
		}else{
			s = s "0,NULL,0"
		}
		s = s "},\n"
		out[++nout] = s
	}
	l = sort_nm(sn, n, a)
	for(i = 1; i <= l; i++){
		p = a[i]
		osn[++nosn] = sprintf("%2d,\t/* \"%s\" */\n", p, sn[nid[p]])
	}
	l = sort_nm(ln, n, a)
	for(i = 1; i <= l; i++){
		p = a[i]
		oln[++noln] = sprintf("%2d,\t/* \"%s\" */\n", p, ln[nid[p]])
	}
	l = sort_obj(obj, n, a)
	for(i = 1; i <= l; i++){
		p = a[i]
		m = obj[nid[p]]
		v = objd[m]
		gsub(/L/, "", v)
		gsub(/,/, " ", v)
		oobj[++noobj] = sprintf("%2d,\t/* %-32s %s */\n", p, m, v)
	}

	print "/* crypto/objects/obj_dat.h */\n" >output
	copyright(output)
	print "" >>output
	printf "#define NUM_NID %d\n", n+1 >>output
	printf "#define NUM_SN %d\n", nosn >>output
	printf "#define NUM_LN %d\n", noln >>output
	printf "#define NUM_OBJ %d\n\n", noobj >>output

	printf "static const unsigned char lvalues[%d]={\n", lsz+1 >>output
	dump(lvalues, nlvalue, output)
	print "};\n" >>output

	print "static const ASN1_OBJECT nid_objs[NUM_NID]={" >>output
	for(i = 1; i <= nout; i++){
		p = out[i]
		if(length(p) > 75){
			s = ""
			nx = split(p, x, "[,]")		# need to contain \n
			for(j = 1; j <= nx; j++){
				t = s x[j] ","
				if(length(t) > 70){
					print s >>output
					t = "\t" x[j] ","
				}
				s = t
			}
			printf "%s", substr(s, 1, length(s)-1) >>output
		}else
			printf "%s", p >>output
	}
	print "};\n" >>output

	print "static const unsigned int sn_objs[NUM_SN]={" >>output
	dump(osn, nosn, output)
	print "};\n" >>output

	print "static const unsigned int ln_objs[NUM_LN]={" >>output
	dump(oln, noln, output)
	print "};\n" >>output

	print "static const unsigned int obj_objs[NUM_OBJ]={" >>output
	dump(oobj, noobj, output)
	print "};\n" >>output
	close(output)
}

function sort_nm(a, n, d, 		i,l,r,m,t) {
	for(i = 0; i <= n; i++)
		if(nid[i] in a){
			d[++l] = a[nid[i]]
			r[d[l],++m[d[l]]] = i
		}
	qsort(d, 1, l)
	for(i = 1; i <= l; i++)
		d[i] = r[d[i],++t[d[i]]]
	return l
}

function sort_obj(a, n, d,		i,l,r,p) {
	for(i = 0; i <= n; i++)
		if(nid[i] in a){
			d[++l] = a[nid[i]]
			r[d[l]] = i
		}
	qsort_obj(d, 1, l, r)
	for(i = 1; i <= l; i++)
		d[i] = r[d[i]]
	return l
}

function dump(a, n, file,		i) {
	for(i = 1; i <= n; i++)
		printf "%s", a[i] >>file
}

function field_string(p,		s,i,t) {
	s = $0
	for(i = 1; i < p; i++)
		$i = ""
	t = trim_left($0)
	$0 = s
	return t
}

function trim_left(s) {
	sub(/^[ \t]+/, "", s)
	return s
}

# expand_obj expands OBJ_xx in a, and counts elements into b.
function expand_obj(a, b,		k,s,t,n,x,c) {
	for(;; c = 0){
		for(k in a){
			while(match(a[k], /OBJ_[^,]+,/) > 0){
				s = substr(a[k], 1, RSTART-1)
				t = substr(a[k], RSTART, RLENGTH-1)
				a[k] = s a[t] "," substr(a[k], RSTART+RLENGTH)
				c++
			}
		}
		if(c == 0)
			break
	}
	for(k in a){
		n = split(a[k], x, ",")
		b[k] = n+1
	}
}

function getoffsets(a, dest,		n,i) {
	for(i in a)
		dest[++n] = i+0
	return n
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

function qsort_obj(a, l, r, ids,	last,i) {
	if(l >= r)
		return
	swap(a, l, int((l+r)/2))
	last = l
	for(i = l+1; i <= r; i++){
		if(obj_cmp(a, i, l, ids) < 0)
			swap(a, ++last, i)
	}
	swap(a, l, last)
	qsort_obj(a, l, last-1, ids)
	qsort_obj(a, last+1, r, ids)
}

# ids contains index of a[x]
function obj_cmp(a, i, j, ids) {
	if(obj_len[a[i]] < obj_len[a[j]])
		return -1
	else if(obj_len[a[i]] > obj_len[a[j]])
		return 1
	if(obj_der[a[i]] < obj_der[a[j]])
		return -1
	else if(obj_der[a[i]] > obj_der[a[j]])
		return 1
	return ids[a[i]] - ids[a[j]]
}

function der_it(v, r,		a,n,i,t,u,buf,nbuf,x) {
	n = split(v, a)
	r[++u] = a[1]*40 + a[2]
	for(i = 3; i <= n; i++){
		nbuf = t = 0
		while(a[i] >= 128){
			x = a[i] % 128
			a[i] = int(a[i]/128)
			if(t > 0)
				x += 128	# x |= 0x80
			buf[++nbuf] = x
			t++
		}
		if(t > 0)
			a[i] += 128
		buf[++nbuf] = a[i]
		reverse(buf, nbuf)
		u = append(r, u, buf, nbuf)
	}
	return u
}

function append(a1, n1, a2, n2,		i) {
	for(i = 1; i <= n2; i++)
		a1[n1+i] = a2[i]
	return n1+n2
}

function reverse(a, n,		i) {
	for(i = 1; i <= int(n/2); i++)
		swap(a, i, n-i+1)
}

function chr(a, n,		i) {
	for(i = 1; i <= n; i++)
		a[i] = sprintf("%c", a[i]+0)
	return n
}

function ord(a,	n,		i) {
	if(length(ascii) == 0){
		for(i = 0; i <= 255; i++)
			ascii[sprintf("%c", i)] = i
	}
	for(i = 1; i <= n; i++)
		a[i] = ascii[a[i]]
	return n
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
