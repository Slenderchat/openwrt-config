#!/bin/bash
ER=1
chk () {
	if [  $? -eq 0  ]
	then
		echo "$1 Succesful";
		let ER++;
	else
		echo "$1 failed";
		exit $ER;
	fi
}
build () {
	rm -f .config
	chk "Clean .config"
	rm -rf files/*
	chk "Clean files"
	cp -f "../openwrt-config/$1/.config" ".config"
	chk "Copy .config"
	cp -rf "../openwrt-config/$1/etc" "files"
	chk "Copy files"
	make clean
	chk "Clean"
	make download
	chk "Download"
	make -j 1
	chk "Build"
	cp -f "bin/targets/*/*/openwrt-*-squashfs-*.bin" "../openwrt-firmware"
	chk "Copy results"
}
build "sverdlova-1"
build "sverdlova-2"
build "danilevskii-1"
build "danilevskii-2"
build "danilevskii-3"
build "danilevskii-4"
