
BASE_PATH=`readlink -f .`

SOURCE_URL="http://zlib.net/zlib-1.2.8.tar.gz"
SOURCE_CHECKSUM="44d667c142d7cda120332623eab69f40"
ZLIB_PREFIX=$BASE_PATH/toolchain/

function down_extract {
	CALC=`md5sum $BASE_PATH/dl/zlib-1.2.8.tar.gz | cut -d" " -f 1`
	if [ "$CALC" != "$SOURCE_CHECKSUM" ]; then
		echo "Need to download zlib sources"
		rm -f $BASE_PATH/dl/zlib-1.2.8.tar.gz
		wget -O $BASE_PATH/dl/zlib-1.2.8.tar.gz "$SOURCE_URL"
	fi
	
	echo "Extracting files into source folder..."
	
	rm -rf   $BASE_PATH/src/zlib/
	mkdir -p $BASE_PATH/src/zlib/
	tar -xf $BASE_PATH/dl/zlib-1.2.8.tar.gz -C $BASE_PATH/src/zlib/
}

if [ "$1" == "check" ]; then
	flist="libz.a"

	for elem in $flist; do
		if [ ! -f $BASE_PATH/toolchain/lib/$elem ]; then
			exit 1;
		fi
	done
	exit 0
elif [ "$1" == "build" ]; then
	down_extract
	
	echo "Configure zlib..."

	# zlib needs to be built in source path	
	rm -rf $BASE_PATH/build/zlib/
	cp -r $BASE_PATH/src/zlib/ $BASE_PATH/build/
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin/
	
	(cd $BASE_PATH/build/zlib/zlib-1.2.8; ./configure --prefix=$ZLIB_PREFIX  )
	
	echo "Compiling zlib..."
	make -C $BASE_PATH/build/zlib/zlib-1.2.8 all CC=mips-elf-gcc CFLAGS="$CFLAGS -EL "
	
	echo "Install ZLIB"
	make -C $BASE_PATH/build/zlib/zlib-1.2.8 install
fi	
