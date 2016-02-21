#!/bin/bash

rm -i notamn.in

echo -n "Building notamn.in... "
for (( i=1; i<=20000; i++ ))
do
	if (( i % 5000 == 0 )); then
		echo -n $i ""
	fi
	cat ../../test/fixtures/input/notamn3.in >> notamn.in
	echo "" >> notamn.in
done
echo ""
