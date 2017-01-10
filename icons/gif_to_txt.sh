#!/bin/bash

for img in *.gif
do
	filename=$(basename $img .gif)
	echo $filename
	convert $img $filename.jpg
	jp2a --width=40 -i $filename.jpg > $filename.txt
	rm $filename.jpg
	done
