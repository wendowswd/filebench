#! /bin/sh

if [ $1 == 'configure' ];then
	libtoolize
	aclocal
	autoheader
	automake --add-missing
	autoconf
elif [ $1 == 'makefile' ];then
	./configure
	make
	sudo make install
else
	echo "please input correct params"
fi
