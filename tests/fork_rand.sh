#!/usr/bin/env bash
./fork_rand > fork_rand.txt
while read -r a b;
do
	if [ "$a" = "$b" ]; then
		echo "FAIL: $a = $b"
	else
		echo "PASS: $a != $b"
	fi
done < fork_rand.txt
