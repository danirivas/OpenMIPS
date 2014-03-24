
BASE_PATH=`readlink -f .`

SOURCE_URL="http://ftp.gnu.org/gnu/gcc/gcc-4.8.0/gcc-4.8.0.tar.bz2"
SOURCE_CHECKSUM="e6040024eb9e761c3bea348d1fa5abb0"
GCC_PREFIX=$BASE_PATH/toolchain/

function down_extract {
	CALC=`md5sum $BASE_PATH/dl/gcc-4.8.0.tar.bz2 | cut -d" " -f 1`
	if [ "$CALC" != "$SOURCE_CHECKSUM" ]; then
		echo "Need to download gcc sources"
		rm -f $BASE_PATH/dl/gcc-4.8.0.tar.bz2
		wget -O $BASE_PATH/dl/gcc-4.8.0.tar.bz2 "$SOURCE_URL"
	fi
	
	echo "Extracting files into source folder..."
	
	rm -rf   $BASE_PATH/src/gcc/
	mkdir -p $BASE_PATH/src/gcc/
	tar -xf $BASE_PATH/dl/gcc-4.8.0.tar.bz2 -C $BASE_PATH/src/gcc/
}

if [ "$1" == "check" ]; then
	flist="mips-elf-gcc mips-elf-g++"

	for elem in $flist; do
		if [ ! -f $BASE_PATH/toolchain/bin/$elem ]; then
			exit 1;
		fi
	done
	exit 0
elif [ "$1" == "build-pre" ] || [ "$1" == "build" ] || [ "$1" == "clean" ]; then

	echo "Cleaning..."
	rm -rf   $BASE_PATH/src/gcc/
	rm -rf $BASE_PATH/build/gcc/
	rm -rf   $BASE_PATH/src/gcc-pre/
	rm -rf $BASE_PATH/build/gcc-pre/

fi	
if [ "$1" == "build-pre" ]; then

	down_extract
	
	echo "Configure gcc..."
	
	rm -rf $BASE_PATH/build/gcc-pre/
	mkdir -p $BASE_PATH/build/gcc-pre
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin/
	
	(cd $BASE_PATH/build/gcc-pre; $BASE_PATH/src/gcc/gcc-4.8.0/configure --target=mips-elf --prefix=$GCC_PREFIX --enable-languages=c --without-headers --with-newlib --disable-libssp )
	
	echo "Compiling gcc..."
	make -j 8 -C $BASE_PATH/build/gcc-pre all
	
	echo "Install GCC"
	make -C $BASE_PATH/build/gcc-pre install

elif [ "$1" == "build" ]; then
	down_extract
	
	echo "Configure gcc..."
	
	rm -rf $BASE_PATH/build/gcc/
	mkdir -p $BASE_PATH/build/gcc
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin/
	
	(cd $BASE_PATH/build/gcc; $BASE_PATH/src/gcc/gcc-4.8.0/configure --target=mips-elf --prefix=$GCC_PREFIX --enable-languages=c,c++ --without-headers --with-newlib --disable-libssp )
	
	echo "Compiling gcc..."
	make -j 8 -C $BASE_PATH/build/gcc all
	
	echo "Install GCC"
	make -C $BASE_PATH/build/gcc install
fi	
