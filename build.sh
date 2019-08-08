#!/bin/bash
ER=1
chk () {
	if [  $? -eq 0  ]
	then
		echo "$1 succesful";
		let ER++;
	else
		echo "$1 failed";
		exit $ER;
	fi
}
chkBld () {
	if [  $? -eq 0  ]
	then
		echo "Build succesful";
		let ER++;
	else
		echo "Build failed";
		make -j 1
		if [  $? -eq 0  ]
		then
			echo "Second build attempt succesful";
			let ER++;
		else
			echo "Second build attempt failed";
			exit $ER;
		fi
		exit $ER;
	fi
}
build () {
	rm -f .config
	chk "Clean .config"
	rm -rf files/*
	chk "Clean files"
	cp -f ../openwrt-config/$1/.config .config
	chk "Copy .config"
	cp -rf ../openwrt-config/$1/etc files
	chk "Copy files"
	make clean
	chk "Clean"
	make download
	chk "Download"
	make -j 1
	chkBld
	for file in bin/targets/*/*/openwrt-*-squashfs-*.bin
	do
		file2=`basename $file`
		file2=${file2##*-*-*-*-*-*-*-}
		mv $file "${file%%openwrt-*-squashfs-*.bin}${1}-${file2}"
	done
	chk "Copy results"
}
build "sverdlova-1"
build "sverdlova-2"
build "danilevskii-1"
build "danilevskii-2"
build "danilevskii-3"
build "danilevskii-4"

